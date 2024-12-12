import 'dart:io';

import 'package:be_fit/src/core/helpers/global_data_types/exercises.dart';
import 'package:equatable/equatable.dart';

enum ExercisesInternalStates {
  initialState,
  getExercisesLoading,
  getExercisesSuccess,
  getExercisesError,
  newSearchState,
  addNewRecordLoading,
  addNewRecordSuccess,
  addNewRecordError,
  deleteRecordLoading,
  deleteRecordSuccess,
  deleteRecordError,
  deleteCustomExerciseSuccess,
  deleteCustomExerciseError,
  selectImage,
  addNewCustomExerciseLoading,
  addNewCustomExerciseSuccess,
  addNewCustomExerciseError,
  changeBody,
  changeDot
}
class ExercisesState extends Equatable {
  final ExercisesInternalStates? currentState;
  final int? currentIndex;
  final File? selectedImage;
  final List<Exercises>? defaultExercises;
  final List<Exercises>? defaultExercisesList;
  final List<Exercises>? customExercises;
  final List<Exercises>? customExercisesList;
  final int? dot;

  final String? errorMsg;

  const ExercisesState({
    this.currentState,
    this.currentIndex,
    this.selectedImage,
    this.defaultExercises,
    this.customExercises,
    this.defaultExercisesList,
    this.customExercisesList,
    this.dot,
    this.errorMsg,
  });

  factory ExercisesState.initial(){
    return const ExercisesState(
        currentState : ExercisesInternalStates.initialState,
        currentIndex : 1,
        selectedImage : null,
        defaultExercises : null,
        customExercises : null,
        defaultExercisesList : null,
        customExercisesList : null,
        dot : 0,
        errorMsg : ''
    );
  }

  ExercisesState copyWith({
    required ExercisesInternalStates state,
    List<Exercises>? defaultExercises,
    File? selectedImage,
    List<Exercises>? customExercises,
    List<Exercises>? defaultExercisesList,
    List<Exercises>? customExercisesList,
    int? index,
    int? dot,
    String? errorMessage
  }) {
    return ExercisesState(
      currentState: state,
      currentIndex: index?? currentIndex,
      selectedImage: selectedImage?? this.selectedImage,
      defaultExercises: defaultExercises?? this.defaultExercises,
      customExercises: customExercises?? this.customExercises,
      defaultExercisesList: defaultExercisesList?? this.defaultExercisesList,
      customExercisesList: customExercisesList?? this.customExercisesList,
      dot: dot?? this.dot,
      errorMsg: errorMessage?? errorMsg,
    );
  }

  @override
  List<Object?> get props => [
    currentState,
    currentIndex,
    selectedImage,
    defaultExercises,
    customExercises,
    defaultExercisesList,
    customExercisesList,
    errorMsg
  ];
}