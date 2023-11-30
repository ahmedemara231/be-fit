import 'dart:io';
import 'package:be_fit/modules/snackBar.dart';
import 'package:be_fit/view_model/exercises/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';

import '../../model/exercises.dart';

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
      emit(GetExercisesErrorState());
    });
  }

  List<Map<String,dynamic>> records = [];
  Future<void> getAllRecordsForSpecificEx({
    required String muscleName,
    required String exerciseId,
})async
  {
    records = [];
    emit(GetRecordsLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc('gBWhBoVwrGNldxxAKbKk')
        .collection('exercises')
        .doc(muscleName)
        .collection(exerciseId)
        .get()
        .then((value)
    {
      value.docs.forEach((element) {
        records.add(element.data());
      });
      print(records);
      emit(GetRecordsSuccessState());
    }).catchError((error)
    {
      emit(GetRecordsErrorState());
    });

  }
  
 Future<void> setRecord({
   required String muscleName,
   required String exerciseId,
   required String weight,
   required String reps,
   required String uId,
   required context,
})async
 {
   emit(SetNewRecordLoadingState());
   FirebaseFirestore.instance
       .collection(muscleName)
       .doc(exerciseId)
       .collection('records')
       .add(
       {
         'weight' : weight,
         'reps' : reps,
         'dateTime' : Jiffy.now().yMMMd,
         'uId' : uId,
       },
   ).then((value)
   {
     MySnackBar.showSnackBar(
         context: context,
         message: 'Saved to records',
         color: Colors.green
     );
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
   required String uId,
   required String muscle,
   required String name,
   required String description,
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
     print('done');
     value.ref.getDownloadURL().then((value)
     {
       FirebaseFirestore.instance
           .collection('users')
           .doc('gBWhBoVwrGNldxxAKbKk')
           .collection('customExercises')
           .add(
           {
             'muscle' : muscle,
             'name' : name,
             'image' : value,
             'description' : description,
             'isCustom' : true,
           }).then((value)
       {
         MySnackBar.showSnackBar(
           context: context,
           message: 'Created Successfully',
           color: Colors.green,
         );
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
        .doc('gBWhBoVwrGNldxxAKbKk')
        .collection('customExercises')
        .where('muscle',isEqualTo: muscle)
        .get()
        .then((value)
    {
      value.docs.forEach((element) {
        customExercises.add(
          CustomExercises(
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

  Future<void> setRecordForCustomExercise({
    required int index,
    required String reps,
    required String weight,
})async
  {
    emit(SetRecordForCustomExerciseLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc('gBWhBoVwrGNldxxAKbKk')
        .collection('customExercises')
        .doc(customExercises[index].id)
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
      print('added');
    }).catchError((error)
    {
      emit(SetRecordForCustomExerciseErrorState());
    });
  }
}