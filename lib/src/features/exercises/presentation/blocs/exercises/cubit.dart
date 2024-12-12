import 'dart:developer';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:be_fit/src/core/helpers/app_widgets/animated_snack_bar.dart';
import 'package:be_fit/src/core/helpers/methods/image_selector.dart';
import 'package:be_fit/src/features/exercises/data/data_source/exercises_data_source.dart';
import 'package:be_fit/src/features/exercises/data/dependency_injection/bloc.dart';
import 'package:be_fit/src/features/exercises/presentation/blocs/exercises/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/data_source/remote/firebase_service/fire_store/exercises/implementation.dart';
import '../../../../../core/data_source/remote/firebase_service/fire_store/interface.dart';
import '../../../../../core/helpers/global_data_types/exercises.dart';
import '../../../../../core/helpers/global_data_types/permission_process_model.dart';
import '../../../../../core/helpers/methods/check_permission.dart';
import '../../../data/data_source/models/add_custom_exercise.dart';
import '../../../data/data_source/models/delete_custom_exercise.dart';
import '../../../data/repo/exercises_repo.dart';

class ExercisesCubit extends Cubit<ExercisesState> {
  ExercisesCubit(this.repo) : super(ExercisesState.initial());
  // {
  //   ExercisesDependencies.exercisesStream.listen((newInterface) {
  //     repo.dataSource.interface = newInterface;
  //     log('from stream ${newInterface.runtimeType.toString()}');
  //   });
  // }
  ExercisesRepo repo;

  void changeBody(int newIndex) {
    emit(state.copyWith(
        state: ExercisesInternalStates.changeBody,
        index: newIndex
    ));
  }

  // should be called default and custom exercises by future.wait
  Future<void> getExercises(String muscleName)async {
    List<Exercises> exercises = [];
    List<Exercises> customExercises = [];
    List<Exercises> exercisesList = [];
    List<Exercises> customExercisesList = [];

    final List<ExercisesInterface> instances = GetIt.instance.getAll<ExercisesInterface>().toList();
    for(ExercisesInterface instance in instances) {
      emit(state.copyWith(state: ExercisesInternalStates.getExercisesLoading));

      final result = await repo.getExercises(muscleName);
      if(result.isSuccess()){
        if(instance is DefaultExercisesImpl){
          exercises = result.getOrThrow();
          exercisesList = result.getOrThrow();
          emit(state.copyWith(
              state: ExercisesInternalStates.getExercisesSuccess,
              defaultExercises: exercises,
              defaultExercisesList: exercisesList
          ));
        }else{
          customExercises = result.getOrThrow();
          customExercisesList = result.getOrThrow();
          emit(state.copyWith(
            state: ExercisesInternalStates.getExercisesSuccess,
            customExercisesList: customExercises,
            customExercises: customExercisesList,
          ));
        }
      }else{
        emit(state.copyWith(state: ExercisesInternalStates.getExercisesError));
      }
    }

    state.customExercisesList!.forEach((element) {
      log(element.name);
    });
    state.defaultExercisesList!.forEach((element) {
      log(element.name);
    });
  }















  void search(String pattern){
    final newExercisesList = [...?state.defaultExercisesList];
    List<Exercises> filteredList = [];
    if(pattern.isEmpty) {
      filteredList = [...newExercisesList];
    }
    else{
      filteredList = newExercisesList
          .where((element) => element.name.contains(pattern))
          .toList();
    }
    emit(state.copyWith(
      state: ExercisesInternalStates.newSearchState,
      defaultExercisesList: filteredList
    ));
  }

  void customExercisesSearch(String pattern) {
    final newExercisesList = [...?state.customExercisesList];
    List<Exercises> filteredList = [];
    if(pattern.isEmpty) {
      filteredList = [...newExercisesList];
    }
    else{
      filteredList = newExercisesList.where((element) => element.name.contains(pattern)).toList();
    }
    emit(state.copyWith(
        state: ExercisesInternalStates.newSearchState,
        customExercisesList: filteredList
    ));
  }

  Future<void> deleteCustomExercise(DeleteCustomExercise inputs)async {
    finishDeleting(inputs.exercise);
    final result = await repo.deleteExercise(inputs.exercise);
    result.when(
            (success) => null,
            (error) => emit(state.copyWith(
                state: ExercisesInternalStates.deleteCustomExerciseError,
                errorMessage: result.tryGetError()?.message
            ))
    );
  }


  void finishDeleting(Exercises exercise) {
    final newExercisesList = [...?state.customExercises];
    newExercisesList.remove(exercise);
    // customExercises.remove(exercise);
    // customExercisesList.remove(exercise);

    // implementation.by view
    // PlanCreationCubit.getInstance(context).removeCustomExerciseFromMuscles(
    //     muscleName: exercise.muscleName!,
    //     exerciseId: exercise.id
    // );
    // PlansCubit.getInstance(context).allPlans.forEach((key, value) {
    //   (value as Map).forEach((key, value) {
    //     (value as List<Exercises>).removeWhere((element) => element.id == exercise.id);
    //   });
    // });

    emit(state.copyWith(
      state: ExercisesInternalStates.deleteCustomExerciseSuccess,
      customExercises: newExercisesList,
      customExercisesList: newExercisesList
    ));
  }


  Future<void> setRecord({
    required ExercisesInterface instance,
})async {
    await ExercisesDependencies.changeExercisesType(instance);

    emit(state.copyWith(state: ExercisesInternalStates.addNewRecordLoading));
    log(GetIt.instance.get<ExercisesInterface>().runtimeType.toString());
    emit(state.copyWith(state: ExercisesInternalStates.addNewRecordSuccess));

    final result = await repo.setRec();
    result.when(
            (success) => emit(state.copyWith(state: ExercisesInternalStates.addNewRecordSuccess)),
            (error) => emit(state.copyWith(state: ExercisesInternalStates.addNewRecordError))
    );
  }

  Future<void> deleteRecord(ExercisesInterface instance)async{
    await ExercisesDependencies.changeExercisesType(instance);
    emit(state.copyWith(state: ExercisesInternalStates.deleteRecordLoading));
    final result = await repo.deleteRec();
    result.when(
            (success) => emit(state.copyWith(state: ExercisesInternalStates.deleteRecordSuccess)),
            (error) => emit(state.copyWith(state: ExercisesInternalStates.deleteRecordError))
    );
  }

  // wrong position
  Future<void> pickImageForCustomExercise(BuildContext context, {
    required ImageSource source,
  })async {
    checkPermission(
      PermissionProcessModel(
          permissionClient: PermissionClient.camera,
          onPermissionGranted: ()async {
            final imgFile = await ImageSelector.selectImage(source);
            emit(state.copyWith(
                state: ExercisesInternalStates.selectImage,
                selectedImage: imgFile
            ));
          },
          onPermissionDenied: () => AppSnackBar.show(
              context,
              msg: 'Can\'t access Camera please enable it from settings',
              type: AnimatedSnackBarType.error
          )
      ),
    );
  }


  Future<void> uploadPickedImageAndAddCustomExercise({
    required AddCustomExerciseModel addCustomExerciseModel,
    required FireStorageInputs inputs
  })async {
    emit(state.copyWith(state: ExercisesInternalStates.addNewCustomExerciseLoading));
    final result = await repo.addNewCustomExercise(
        addCustomExerciseModel: addCustomExerciseModel,
        inputs: inputs
    );
    
    result.when(
            (success) => newExerciseCreated(success),
            (error) => emit(state.copyWith(state: ExercisesInternalStates.addNewCustomExerciseError)),
    );
  }

  void newExerciseCreated(CustomExercises exercise) {
    final newCustomExercises = [...?state.customExercises];
    newCustomExercises.add(exercise);
    emit(state.copyWith(
      state: ExercisesInternalStates.addNewCustomExerciseSuccess,
      customExercises: newCustomExercises,
      customExercisesList: newCustomExercises,
      selectedImage: null
    ));

    // implementation.by view
    // PlanCreationCubit.getInstance(context).addCustomExerciseToMuscles(
    //     exercise
    // );
    // MyToast.showToast(context, msg: 'Ready Now');
    // Navigator.pop(context);
  }

  void removeSelectedImage() {
    emit(state.copyWith(
        state: ExercisesInternalStates.selectImage,
        selectedImage: null
    ));
  }
}