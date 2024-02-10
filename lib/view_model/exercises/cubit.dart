import 'dart:io';
import 'package:be_fit/constants.dart';
import 'package:be_fit/view/statistics/statistics.dart';
import 'package:be_fit/view_model/exercises/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import '../../models/data_types/add_custom_exercise.dart';
import '../../models/data_types/exercises.dart';
import '../../models/data_types/setRecord_model.dart';
import '../../models/widgets/modules/toast.dart';
import '../plan_creation/cubit.dart';

class ExercisesCubit extends Cubit<ExercisesStates>
{
  ExercisesCubit(super.initialState);
  static ExercisesCubit getInstance(context) => BlocProvider.of(context);

  int currentIndex = 1;
  void changeBody(int newIndex)
  {
    currentIndex = newIndex;
    emit(ChangeBody());
  }

  List<Exercises> exercises = [];
  Future<void> getExercisesForSpecificMuscle(context,{
    required String muscleName,
})async
  {
    exercises = [];
    emit(GetExercisesLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection(muscleName)
          .get()
          .then((value)
      {
        value.docs.forEach((element) {
          exercises.add(
            Exercises(
                video: element.data()['video'],
                name: element.data()['name'],
                image: element.data()['image'],
                docs: element.data()['docs'],
                id: element.id,
                isCustom: element.data()['isCustom']
            ),
          );
        });
        emit(GetExercisesSuccessState());
      });
    } on Exception catch(e)
    {
      emit(GetExercisesErrorState());
      MyMethods.handleError(context, e);
    }
  }

 Future<void> setRecord({
   required SetRecModel recModel,
   required context,
})async
 {
   // set a record for exercise

   emit(SetNewRecordLoadingState());
   double? reps = double.tryParse(recModel.reps);
   double? weight = double.tryParse(recModel.weight);
   try{
     await FirebaseFirestore.instance
         .collection(recModel.muscleName)
         .doc(recModel.exerciseId)
         .collection('records')
         .add(
       {
         'weight' : weight,
         'reps' : reps,
         'dateTime' : Jiffy().yMMMM,
         'uId' : recModel.uId,
       },
     ).then((recordId)async
     {
       // set a record for exercise in plans
       await FirebaseFirestore.instance
           .collection('users')
           .doc(recModel.uId)
           .collection('plans')
           .get()
           .then((value)
       {
         value.docs.forEach((element) async{
           List<int> lists = [1,2,3,4,5,6];
           for(int i = 1; i < lists.length; i++)
           {
             QuerySnapshot checkCollection = await element.reference
                 .collection('list$i').get();
             if(checkCollection.docs.isNotEmpty)
             {
               await element.reference
                   .collection('list$i').doc(recModel.exerciseId)
                   .get().then((value)
               {
                 if(value.exists)
                 {
                   element.reference
                       .collection('list$i')
                       .doc(recModel.exerciseId)
                       .collection('records')
                       .doc(recordId.id)
                       .set(
                     {
                       'weight' : weight,
                       'reps' : reps,
                       'dateTime' : Jiffy().yMMMM
                     },
                   );
                 }
                 else{
                   return;
                 }
               });
             }
             else{
               return;
             }
           }
         });
         MyToast.showToast(context, msg: 'Record added');
       });
       emit(SetNewRecordSuccessState());
     });
   } on Exception catch (e)
   {
     emit(GetExercisesErrorState());
     MyMethods.handleError(context, e);
   }
 }

 List<MyRecord> records = [];
 Future<void> pickRecordsToMakeChart(context,{
   required String muscleName,
   required String exerciseDoc,
   required String uId,
})async
 {
   records = [];
   emit(MakeChartForExerciseLoadingState());
   try{
     await FirebaseFirestore.instance
         .collection(muscleName)
         .doc(exerciseDoc)
         .collection('records')
         .where('uId',isEqualTo: uId)
         .get()
         .then((value)
     {
       value.docs.forEach((element) {
         records.add(
           MyRecord(
             reps: element.data()['reps'],
             weight: element.data()['weight'],
           ),
         );
       });
       emit(MakeChartForExerciseSuccessState());
     });
   } on Exception catch(e)
   {
     emit(GetExercisesErrorState());
     MyMethods.handleError(context, e);
   }
 }

 List<MyRecord> recordsForCustomExercise = [];
 Future<void> pickRecordsForCustomExerciseToMakeChart(context,{
   required String uId,
   required String exerciseDoc,
})async
 {
   recordsForCustomExercise = [];
   try{
     await FirebaseFirestore.instance
         .collection('users')
         .doc(uId)
         .collection('customExercises')
         .doc(exerciseDoc)
         .collection('records')
         .get()
         .then((value)
     {
       value.docs.forEach((element) {
         recordsForCustomExercise.add(
             MyRecord(
               reps: element.data()['reps'],
               weight: element.data()['weight'],
             ));
       });
     });
   }on Exception catch(e)
   {
     emit(GetExercisesErrorState());
     MyMethods.handleError(context, e);
   }
 }

  File? selectedExerciseImage;
  late String exerciseImageName;
 Future<void> pickImageForCustomExercise()async
 {
   final ImagePicker picker = ImagePicker();
   await picker.pickImage(source: ImageSource.gallery).then((value)
   {
     selectedExerciseImage = File(value!.path);
     exerciseImageName = Uri.file(value.path).pathSegments.last;
     emit(PickCustomExerciseImageSuccessState());
   }).catchError((error)
   {
     emit(PickCustomExerciseImageErrorState());
   });
 }

 Future<void> uploadPickedImageAndAddCustomExercise({
   required AddCustomExerciseModel addCustomExerciseModel,
   required context,
})async
 {

   emit(CreateCustomExerciseLoadingState());
   try{
     await FirebaseStorage.instance
         .ref('exerciseImages/')
         .child(exerciseImageName)
         .putFile(selectedExerciseImage!)
         .then((value)
     {
       value.ref.getDownloadURL().then((imageUrl)async
       {
         await FirebaseFirestore.instance
             .collection('users')
             .doc(addCustomExerciseModel.uId)
             .collection('customExercises')
             .add(
             {
               'muscle' : addCustomExerciseModel.muscle,
               'name' : addCustomExerciseModel.name,
               'image' : imageUrl,
               'description' : addCustomExerciseModel.description,
               'isCustom' : true,
             }).then((value)
         {
           customExercises.add(
             CustomExercises(
               name: addCustomExerciseModel.name,
               image: imageUrl,
               docs: addCustomExerciseModel.description,
               id: value.id,
               isCustom: true,
               video: '',
             ),
           );

           PlanCreationCubit.getInstance(context).addCustomExerciseToMuscles(
             addCustomExerciseModel.muscle,
             CustomExercises(
                 name: addCustomExerciseModel.name,
                 image: imageUrl,
                 docs: addCustomExerciseModel.description,
                 id: value.id,
                 isCustom: true,
                 video: ''
             ),
           );

           MyToast.showToast(context, msg: 'New Exercise is Ready');
           Navigator.pop(context);
           selectedExerciseImage = null;

           emit(CreateCustomExerciseSuccessState(
             customExercise: CustomExercises(
               name: addCustomExerciseModel.name,
               image: imageUrl,
               docs: addCustomExerciseModel.description,
               id: value.id,
               isCustom: true,
               video: '',
             ),
           ));
         }).catchError((error)
         {
           emit(CreateCustomExerciseErrorState());
         });
       });
     });
   }on Exception catch(e)
   {
     emit(GetExercisesErrorState());
     MyMethods.handleError(context, e);
   }
 }

 List<CustomExercises> customExercises = [];
  Future<void> getCustomExercises(context,{
    required String uId,
    required String muscle,
  })async
  {
    customExercises = [];
    emit(GetCustomExercisesLoadingState());
    try{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('customExercises')
          .where('muscle',isEqualTo: muscle)
          .get()
          .then((value)
      {
        value.docs.forEach((element) {
          customExercises.add(
            CustomExercises(
              video: element.data()['video']?? '',
              name: element.data()['name'],
              image: element.data()['image'],
              docs: element.data()['description'],
              id: element.id,
              isCustom: element.data()['isCustom'],
            ),
          );
        });
        emit(GetCustomExercisesSuccessState());
      });
    }on Exception catch(e)
    {
      emit(GetExercisesErrorState());
      MyMethods.handleError(context, e);
    }
  }

  Future<void> deleteCustomExercise(context,{
    required String uId,
    required int index,
    required String muscleName
})async
  {
    try{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('customExercises')
          .doc(customExercises[index].id)
          .delete()
          .then((value)async
      {
        PlanCreationCubit.getInstance(context).removeCustomExerciseFromMuscles(
            muscleName: muscleName,
            exerciseId: customExercises[index].id
        );

        customExercises.remove(customExercises[index]);

        // await FirebaseFirestore.instance
        // .collection('users')
        // .doc(uId)
        // .collection('plans')
        // .get()
        // .then((value) {
        //   if (value.docs.isNotEmpty) {
        //     log('not empty');
        //     List<int> days = [1,2,3,4,5,6];
        //     value.docs.forEach((element)async {
        //       for(int i = 1; i<= days.length; i++)
        //       {
        //         var myTargetExercise = await element.reference
        //             .collection('list$i')
        //             .doc(customExercises[index].id)
        //             .get();
        //         if(myTargetExercise.exists)
        //         {
        //           log('$myTargetExercise');
        //           log('exists ${customExercises[index].id} at ${element.id} and list$i');
        //           await element.reference
        //               .collection('list$i')
        //               .doc(customExercises[index].id)
        //               .delete();
        //           log('deleted');
        //         }
        //         else{
        //           log('not exists ${customExercises[index].id} at ${element.id} and list$i');
        //           return;
        //         }
        //       }
        //     });
        //   }
        //   else {
        //     log('empty');
        //     return;
        //   }
        // });

        emit(DeleteCustomExerciseSuccessState());
      });
    }on Exception catch(e)
    {
      emit(GetExercisesErrorState());
      MyMethods.handleError(context, e);
    }
  }

  Future<void> setRecordForCustomExercise(context,{
    required SetCustomExerciseRecModel setCustomExerciseRecModel,
})async
  {
    emit(SetRecordForCustomExerciseLoadingState());

    double? reps = double.tryParse(setCustomExerciseRecModel.reps);
    double? weight = double.tryParse(setCustomExerciseRecModel.weight);

    try{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(setCustomExerciseRecModel.uId)
          .collection('customExercises')
          .doc(customExercises[setCustomExerciseRecModel.index].id)
          .collection('records')
          .add(
        {
          'reps' : reps,
          'weight' : weight,
          'dateTime' : Jiffy().yMMM
        },
      ).then((record)
      {

        FirebaseFirestore.instance
        .collection('users')
        .doc(setCustomExerciseRecModel.uId)
        .collection('plans')
        .get()
        .then((value)
        {
          List<int> days = [1,2,3,4,5,6];
          for(int i = 1; i <= days.length; i++)
            {
              value.docs.forEach((element) async{
               var myCustomExercise = await element.reference.collection('list$i')
                    .doc(setCustomExerciseRecModel.exerciseDoc)
                    .get();
               if(myCustomExercise.exists)
                 {
                   await element.reference.collection('list$i')
                       .doc(setCustomExerciseRecModel.exerciseDoc)
                       .collection('records')
                       .doc(record.id)
                       .set(
                       {
                         'reps' : reps,
                         'weight' : weight,
                         'dateTime' : Jiffy().yMMM
                       },
                   );
                 }
               else{
                 return;
               }
              });
            }
        });

        emit(SetRecordForCustomExerciseSuccessState());
        MyToast.showToast(context, msg: 'Record added');
      });
    } on Exception catch(e)
    {
      emit(GetExercisesErrorState());
      MyMethods.handleError(context, e);
    }
  }
}