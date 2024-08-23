import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:be_fit/model/remote/firebase_service/fireStorage/implementation.dart';
import 'package:be_fit/model/remote/firebase_service/fireStorage/interface.dart';
import 'package:be_fit/model/remote/repositories/exercises/implementation.dart';
import 'package:be_fit/model/remote/repositories/interface.dart';
import 'package:be_fit/models/data_types/delete_custom_exercise.dart';
import 'package:be_fit/models/data_types/permission_process_model.dart';
import 'package:be_fit/models/data_types/setRecord_model.dart';
import 'package:be_fit/models/methods/check_permission.dart';
import 'package:be_fit/models/widgets/modules/snackBar.dart';
import 'package:be_fit/view/statistics/statistics.dart';
import 'package:be_fit/view_model/exercises/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/data_types/add_custom_exercise.dart';
import '../../models/data_types/exercises.dart';
import '../../models/widgets/exercise_model.dart';
import '../../models/widgets/modules/toast.dart';
import '../plan_creation/cubit.dart';
import '../plans/cubit.dart';

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
    ExerciseModel(imageUrl: 'back', text: 'Back',numberOfExercises: 7),
    ExerciseModel(imageUrl: 'chest', text: 'chest',numberOfExercises: 9),
    ExerciseModel(imageUrl: 'biceps', text: 'biceps',numberOfExercises: 5),
    ExerciseModel(imageUrl: 'triceps', text: 'triceps',numberOfExercises: 5),
    ExerciseModel(imageUrl: 'Legs', text: 'legs',numberOfExercises: 5),
    ExerciseModel(imageUrl: 'shoulders', text: 'Shoulders',numberOfExercises: 5),
  ];

  List<Exercises> exercises = [];

  Future<void> getExercises(BuildContext context,{
    required ExercisesMain exercisesType,
    required String muscleName
  })async
  {
    exercises = [];
    customExercises = [];

    emit(GetExercisesLoadingState());
    final result = await exercisesType.getExercises(context, muscleName);
    if(result.isSuccess())
      {
        if(exercisesType is DefaultExercisesImpl)
          {
            exercises = result.getOrThrow();
            exercisesList = List.from(exercises);
          }
        else{
          customExercises = result.getOrThrow();
          customExercisesList = List.from(customExercises);
        }
        emit(GetExercisesSuccessState());
      }
    else{
      emit(GetExercisesErrorState());
    }
  }

  late List<Exercises> exercisesList;
  List<Exercises> customExercisesList = [];

  void exerciseSearch({
    required ExercisesMain exercisesType,
    required String pattern
  })
  {
    final List<Exercises> filteredList = exercisesType.search(pattern);
    if(exercisesType is DefaultExercisesImpl)
      {
        exercisesList = filteredList;
      }
    else{
      customExercisesList = filteredList;
    }
    emit(NewSearchState());
  }

  List<Exercises> customExercises = [];

  Future<void> deleteCustomExercise(context,{
    required DeleteCustomExercise inputs,
    required ExercisesMain exerciseType
  })async
  {
    finishDeleting(context, exercise: inputs.exercise);
    emit(DeleteCustomExerciseSuccessState());

    await exerciseType.deleteExercise(
        context,
        exercise: inputs.exercise,
        muscleName: inputs.muscleName
    );
  }

  void finishDeleting(context, {required Exercises exercise})
  {
    customExercises.remove(exercise);
    customExercisesList.remove(exercise);

    PlansCubit.getInstance(context).allPlans.forEach((key, value) {
      (value as Map).forEach((key, value) {
        (value as List<Exercises>).removeWhere((element) => element.id == exercise.id);
      });
    });
  }


  Future<void> setRecord({
    required ExercisesMain exerciseType,
    required SetRecModel model
  })async
  {
    emit(SetNewRecordLoadingState());
    await exerciseType.setRecords(model);
    emit(SetNewRecordSuccessState());
  }

  File? selectedExerciseImage;
  late String exerciseImageName;

  Future<void> pickImageForCustomExercise(BuildContext context,{
    required ImageSource source,
  })async
  {
    checkPermission(
      PermissionProcessModel(
          permissionClient: PermissionClient.camera,
          onPermissionGranted: ()async {
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
          },
          onPermissionDenied: () => AnimatedSnackBar.material(
              'Can\'t access Camera please enable it from settings',
              type: AnimatedSnackBarType.error,
              mobileSnackBarPosition: MobileSnackBarPosition.bottom
          ).show(context)
      ),
    );
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
          await FirebaseFirestore.instance
          .collection('users').doc(addCustomExerciseModel.uId)
              .collection('customExercises')
              .add(addCustomExerciseModel.toJson(imageUrl)).then((value) {
                final exercise = CustomExercises(
                  name: addCustomExerciseModel.name,
                  image: [imageUrl],
                  docs: addCustomExerciseModel.description,
                  id: value.id,
                  isCustom: true,
                  video: '',
                );
            customExercises.add(
              exercise
            );
                customExercisesList = List.from(customExercises);
                PlanCreationCubit.getInstance(context).addCustomExerciseToMuscles(
                    addCustomExerciseModel.muscle,
                    exercise
                );
                newExerciseCreated(context);
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

  void newExerciseCreated(context)
  {
    MyToast.showToast(context, msg: 'Ready Now');
    Navigator.pop(context);
    selectedExerciseImage = null;
  }

  List<MyRecord> records = [];
 Future<void> pickRecordsToMakeChart(context,{required MainFunctions exerciseType})async
 {
   emit(MakeChartForExerciseLoadingState());
   final result = await exerciseType.getRecords(context);
   if(result.isSuccess())
     {
       records = result.getOrThrow();
       emit(MakeChartForExerciseSuccessState());
     }
   else{
     emit(PickCustomExerciseImageErrorState());
   }

 }
  void removeSelectedImage()
  {
    selectedExerciseImage = null;
    emit(RemoveSelectedImage());
  }

  int dot = 0;
  void changeDot(int newDot)
  {
    dot = newDot;
    emit(ChangeDot());
  }
}