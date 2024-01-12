import 'dart:developer';
import 'dart:io';
import 'package:be_fit/modules/snackBar.dart';
import 'package:be_fit/modules/toast.dart';
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

class ExercisesCubit extends Cubit<ExercisesStates>
{
  ExercisesCubit(super.initialState);
  static ExercisesCubit getInstance(context) => BlocProvider.of(context);

  List<Exercises> exercises = [];
  Future<void> getExercisesForSpecificMuscle({
    required String muscleName,
})async
  {
    exercises = [];
    emit(GetExercisesLoadingState());
    FirebaseFirestore.instance
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
    }).catchError((error)
    {
      print(error.toString());
      emit(GetExercisesErrorState());
    });
  }

 Future<void> setRecord({
   required SetRecModel recModel,
   required context,
})async
 {
   // set a record for exercise
   double? reps = double.tryParse(recModel.reps);
   double? weight = double.tryParse(recModel.weight);

   emit(SetNewRecordLoadingState());
   await FirebaseFirestore.instance
       .collection(recModel.muscleName)
       .doc(recModel.exerciseId)
       .collection('records')
       .add(
       {
         'weight' : weight,
         'reps' : reps,
         'dateTime' : Jiffy.now().yMMMd,
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
                         'dateTime' : Jiffy.now().yMMMd,
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
   }).catchError((error)
   {
     emit(SetNewRecordErrorState());
   });
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
   await FirebaseStorage.instance
       .ref('exerciseImages/')
       .child(exerciseImageName)
       .putFile(selectedExerciseImage!)
       .then((value)
   {
     value.ref.getDownloadURL().then((imageUrl)
     {
       FirebaseFirestore.instance
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
         MyToast.showToast(context, msg: 'New Exercise is Ready');
         Navigator.pop(context);
         selectedExerciseImage = null;
         emit(CreateCustomExerciseSuccessState());
       }).catchError((error)
       {
         emit(CreateCustomExerciseErrorState());
       });
     });
   });
 }

 List<CustomExercises> customExercises = [];
  Future<void> getCustomExercises({
    required String uId,
    required String muscle,
  })async
  {
    customExercises = [];
    emit(GetCustomExercisesLoadingState());
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
      print(customExercises);
      emit(GetCustomExercisesSuccessState());
    }).catchError((error)
    {
      print(error.toString());
      emit(GetCustomExercisesErrorState());
    });
  }

  Future<void> deleteCustomExercise({
    required String uId,
    required int index,
})async
  {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('customExercises')
        .doc(customExercises[index].id)
        .delete()
        .then((value)
    {
      log('deleted');
      customExercises.remove(customExercises[index]);
      emit(DeleteCustomExerciseSuccessState());
    }).catchError((error){
      emit(DeleteCustomExerciseErrorState());
    });
  }

  Future<void> setRecordForCustomExercise(context,{
    required SetCustomExerciseRecModel setCustomExerciseRecModel,
})async
  {
    emit(SetRecordForCustomExerciseLoadingState());

    double? reps = double.tryParse(setCustomExerciseRecModel.reps);
    double? weight = double.tryParse(setCustomExerciseRecModel.weight);

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
          'dateTime' : Jiffy.now().yMMM,
        },
    ).then((value)
    {
      emit(SetRecordForCustomExerciseSuccessState());
      MyToast.showToast(context, msg: 'Record added');
    }).catchError((error)
    {
      emit(SetRecordForCustomExerciseErrorState());
    });
  }
}