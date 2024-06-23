import 'dart:io';
import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/model/remote/firebase_service/fireStorage/implementation.dart';
import 'package:be_fit/model/remote/firebase_service/fireStorage/interface.dart';
import 'package:be_fit/model/remote/firebase_service/fireStore_service/implementation.dart';
import 'package:be_fit/model/remote/firebase_service/fireStore_service/interface.dart';
import 'package:be_fit/view/statistics/statistics.dart';
import 'package:be_fit/view_model/exercises/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import '../../models/data_types/add_custom_exercise.dart';
import '../../models/data_types/exercises.dart';
import '../../models/data_types/setRecord_model.dart';
import '../../models/widgets/exercise_model.dart';
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

  List<ExerciseModel> musclesList = [
    ExerciseModel(imageUrl: 'aps', text: 'Aps',numberOfExercises: 2),
    ExerciseModel(imageUrl: 'back', text: 'Back',numberOfExercises: 4),
    ExerciseModel(imageUrl: 'chest', text: 'chest',numberOfExercises: 5),
    ExerciseModel(imageUrl: 'biceps', text: 'biceps',numberOfExercises: 5),
    ExerciseModel(imageUrl: 'triceps', text: 'triceps',numberOfExercises: 5),
    ExerciseModel(imageUrl: 'Legs', text: 'legs',numberOfExercises: 5),
    ExerciseModel(imageUrl: 'shoulders', text: 'Shoulders',numberOfExercises: 5),
  ];

  FireStoreService service = FireStoreCall();

  List<Exercises> exercises = [];
  Future<void> getExercisesForSpecificMuscle(context,{
    required String muscleName,
})async
  {
    exercises = [];
    emit(GetExercisesLoadingState());
      var result = await service.callFireStore(muscleName);
      if(result.isSuccess())
        {
          result.getOrThrow().get().then((value) {
            value.docs.forEach((element) {
              exercises.add(Exercises.fromJson(element as QueryDocumentSnapshot<Map<String, dynamic>>));
            });

            exercisesList = List.from(exercises);
            emit(GetExercisesSuccessState());
          });
        }
      else{
        service.handleError(context, errorMessage: result.tryGetError()?.message);
        emit(GetExercisesErrorState());
      }
  }


  late List<Exercises> exercisesList;
  void exerciseSearch(String pattern)
  {
    if(pattern.isEmpty)
      {
        exercisesList = List.from(exercises);
        emit(NewExerciseSearchState());
      }
    else{
      exercisesList = exercises.where((element) => element.name.contains(pattern)).toList();
      emit(NewExerciseSearchState());
    }
  }

  List<CustomExercises> customExercisesList = [];

  void customExerciseSearch(String pattern)
  {
    if(pattern.isEmpty)
    {
      customExercisesList = List.from(customExercises);
      emit(NewExerciseSearchState());
    }
    else{
      customExercisesList = customExercises.where((element) => element.name.contains(pattern)).toList();
      emit(NewExerciseSearchState());
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

   var result = await service.callFireStore(recModel.muscleName);
   if(result.isSuccess())
     {
       result.getOrThrow().doc(recModel.exerciseId)
           .collection('records')
           .add({
         'weight' : weight,
         'reps' : reps,
         'dateTime' : Jiffy().yMMMM,
         'uId' : recModel.uId,
       }).then((recordId)async
       {
         var result = await service.callFireStore('users');
         result.getOrThrow().doc(recModel.uId)
             .collection('plans')
             .get().then((value)async {

               for(var doc in value.docs)
                 {
                   List<int> lists = [1,2,3,4,5,6];
                   for(int i = 1; i < lists.length; i++)
                   {
                     QuerySnapshot checkCollection = await doc.reference
                         .collection('list$i').get();
                     if(checkCollection.docs.isNotEmpty)
                     {
                       await doc.reference
                           .collection('list$i').doc(recModel.exerciseId)
                           .get().then((value)
                       {
                         if(value.exists)
                         {
                           doc.reference
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
                 }

               MyToast.showToast(context, msg: 'Record added');
         });
       });

       emit(SetNewRecordSuccessState());
     }
   else{
     service.handleError(context);
     emit(GetExercisesErrorState());
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

     var result = await service.callFireStore(muscleName);
     if(result.isSuccess())
       {
         result.getOrThrow().doc(exerciseDoc)
             .collection('records')
             .where('uId',isEqualTo: uId)
             .get().then((value) {
               for(var doc in value.docs)
                 {
                   records.add(
                     MyRecord(
                       reps: doc.data()['reps'],
                       weight: doc.data()['weight'],
                     ),
                   );
                 }
         });
         emit(MakeChartForExerciseSuccessState());
       }
     else{
       service.handleError(context);
       emit(GetExercisesErrorState());
     }

 }

 List<MyRecord> recordsForCustomExercise = [];
 Future<void> pickRecordsForCustomExerciseToMakeChart(context,{
   required String uId,
   required String exerciseDoc,
})async
 {
   recordsForCustomExercise = [];
   var result = await service.callFireStore('users');
   if(result.isSuccess())
   {
     result.getOrThrow() .doc(uId)
         .collection('customExercises')
         .doc(exerciseDoc)
         .collection('records')
         .get().then((value) {
           for(var doc in value.docs)
             {
               recordsForCustomExercise.add(
                   MyRecord(
                     reps: doc.data()['reps'],
                     weight: doc.data()['weight'],
                   ),
               );
             }
     });
   }
   else{
     service.handleError(context);
     emit(GetExercisesErrorState());
   }
 }

  File? selectedExerciseImage;
  late String exerciseImageName;
 Future<void> pickImageForCustomExercise({
    required ImageSource source,
})async
 {
   final ImagePicker picker = ImagePicker();
   await picker.pickImage(source: source).then((value)
   {
     selectedExerciseImage = File(value!.path);
     exerciseImageName = Uri.file(value.path).pathSegments.last;
     emit(PickCustomExerciseImageSuccessState());
   }).catchError((error)
   {
     emit(PickCustomExerciseImageErrorState());
   });
 }


 FireStorageService storage = FireStorageCall();

 Future<void> uploadPickedImageAndAddCustomExercise({
   required AddCustomExerciseModel addCustomExerciseModel,
   required context,
})async
 {
   emit(CreateCustomExerciseLoadingState());

     var result = await storage.callFireStorage(refName: 'exerciseImages/', childName: exerciseImageName);
     if(result.isSuccess())
       {
         result.getOrThrow()
             .putFile(selectedExerciseImage!)
             .then((val) {
           val.ref.getDownloadURL().then((imageUrl)async
           {
             var db = await service.callFireStore('users');
             db.getOrThrow().doc(addCustomExerciseModel.uId)
                 .collection('customExercises')
                 .add(addCustomExerciseModel.toJson(imageUrl))
             .then((value) {
               customExercises.add(
                 CustomExercises(
                   name: addCustomExerciseModel.name,
                   image: [imageUrl],
                   docs: addCustomExerciseModel.description,
                   id: value.id,
                   isCustom: true,
                   video: '',
                 ),
               );

               customExercisesList = List.from(customExercises);

               PlanCreationCubit.getInstance(context).addCustomExerciseToMuscles(
                 addCustomExerciseModel.muscle,
                 CustomExercises(
                     name: addCustomExerciseModel.name,
                     image: [imageUrl],
                     docs: addCustomExerciseModel.description,
                     id: value.id,
                     isCustom: true,
                     video: ''
                 ),
               );

               MyToast.showToast(context, msg: 'New Exercise is Ready');
               Navigator.pop(context);
               selectedExerciseImage = null;

               emit(CreateCustomExerciseSuccessState());

             });
           });
         });
       }
     else{
       storage.handleError(context,errorMessage: result.tryGetError()?.message);
       emit(CreateCustomExerciseErrorState());
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
    var db = await service.callFireStore('users');
    if(db.isSuccess())
      {
        db.getOrThrow().doc(uId)
            .collection('customExercises')
            .where('muscle',isEqualTo: muscle)
            .get().then((value) {
              for(var doc in value.docs)
                {
                  customExercises.add(
                    CustomExercises.fromJson(doc),
                  );
                }
              customExercisesList = List.from(customExercises);
              emit(GetCustomExercisesSuccessState());
        });
      }
    else{
      service.handleError(context,errorMessage: db.tryGetError()?.message);
      emit(GetExercisesErrorState());
    }
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

        });

      });
    }on Exception catch(e)
    {
      MyMethods.handleError(context, e);
    }
  }

  Future<void> deleteCustomExercise(context,{
    required String uId,
    required int index,
    required String muscleName
})async
  {
    var db = await service.callFireStore('users');
    if(db.isSuccess())
      {
        db.getOrThrow().doc(uId)
            .collection('customExercises')
            .doc(customExercises[index].id)
            .delete()
            .then((value) {
          PlanCreationCubit.getInstance(context).removeCustomExerciseFromMuscles(
              muscleName: muscleName,
              exerciseId: customExercises[index].id
          );

          customExercises.remove(customExercises[index]);
          customExercisesList = List.from(customExercises);

          emit(DeleteCustomExerciseSuccessState());
        });
      }
    else{
      service.handleError(context,errorMessage: db.tryGetError()?.message);
      emit(DeleteCustomExerciseErrorState());
    }
  }

  Future<void> setRecordForCustomExercise(context,{
    required SetCustomExerciseRecModel setCustomExerciseRecModel,
})async
  {
    emit(SetRecordForCustomExerciseLoadingState());

    double? reps = double.tryParse(setCustomExerciseRecModel.reps);
    double? weight = double.tryParse(setCustomExerciseRecModel.weight);

    var db = await service.callFireStore('users');
    if(db.isSuccess())
      {
        db.getOrThrow().doc(setCustomExerciseRecModel.uId)
            .collection('customExercises')
            .doc(customExercises[setCustomExerciseRecModel.index].id)
            .collection('records').add(
          {
            'reps' : reps,
            'weight' : weight,
            'dateTime' : Jiffy().yMMM
          },
        ).then((record)async {
          var db = await service.callFireStore('users');
          db.getOrThrow().doc(setCustomExerciseRecModel.uId)
              .collection('plans')
              .get().then((value) async{
            List<int> days = [1,2,3,4,5,6];
            for(int i = 1; i <= days.length; i++)
            {

              for(var doc in value.docs)
                {
                  var myCustomExercise = await doc.reference.collection('list$i')
                      .doc(setCustomExerciseRecModel.exerciseDoc)
                      .get();
                  if(myCustomExercise.exists)
                  {
                    await doc.reference.collection('list$i')
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
                }
            }
          });
        });
      }
    else{
      service.handleError(context,errorMessage: db.tryGetError()?.message);
      emit(SetRecordForCustomExerciseErrorState());
    }
  }

  int dot = 0;
  void changeDot(int newDot)
  {
    dot = newDot;
    emit(ChangeDotSuccessState());
  }

  void removeSelectedImage()
  {
    selectedExerciseImage = null;
    emit(RemoveSelectedImage());
  }
}