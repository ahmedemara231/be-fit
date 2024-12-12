import 'package:equatable/equatable.dart';

import '../../../../core/helpers/global_data_types/exercises.dart';

enum CreatePlanInternalStates {
  createPlanInitial,
  addCustomExerciseToMuscles,
  removeCustomExerciseFromMuscles,
  initDayCheckbox,
  changeDayCheckbox,
  initLists,
  addExerciseToLists,
  removeExerciseFromLists,
  createPlanLoading,
  createPlanSuccess,
  createPlanError,
  createPlanForBeginnersLoading,
  createPlanForBeginnersSuccess,
  prepareBeginnersPlan,
  getAllMusclesLoading,
  getAllMusclesSuccess,
  getAllMusclesError,
  changeCounterVal,
  changeCheckboxVal
}

class CreatePlanState extends Equatable {
  final CreatePlanInternalStates? currentState;
  final Map<String, List<Exercises>>? musclesAndItsExercises;
  final Map<String, List<bool>>? muscleExercisesCheckBox;
  final Map<String,Map<String, List<bool>>>? dayCheckBox;
  final Map<String,List<Exercises>>? lists;
  final int? currentIndex;
  final String? errorMsg;

  const CreatePlanState({
    this.currentState,
    this.musclesAndItsExercises,
    this.muscleExercisesCheckBox,
    this.dayCheckBox,
    this.lists,
    this.currentIndex,
    this.errorMsg
  });

  factory CreatePlanState.initial(){
    return const CreatePlanState(
        currentState : CreatePlanInternalStates.createPlanInitial,
        musclesAndItsExercises : {},
        muscleExercisesCheckBox : {},
        dayCheckBox : {},
        lists : {},
        currentIndex : 0,
        errorMsg : ''
    );
  }

  CreatePlanState copyWith({
    required CreatePlanInternalStates state,
    Map<String, List<Exercises>>? musclesAndItsExercises,
    Map<String, List<bool>>? muscleExercisesCheckBox,
    Map<String, Map<String, List<bool>>>? dayCheckBox,
    Map<String, List<Exercises>>? lists,
    int? currentIndex,
    String? errorMessage
  })
  {
    return CreatePlanState(
      currentState: state,
      musclesAndItsExercises: musclesAndItsExercises?? this.musclesAndItsExercises,
      muscleExercisesCheckBox: muscleExercisesCheckBox?? this.muscleExercisesCheckBox,
      dayCheckBox: dayCheckBox?? this.dayCheckBox,
      lists: lists?? this.lists,
      currentIndex: currentIndex?? this.currentIndex,
      errorMsg: errorMessage?? errorMsg,
    );
  }

  @override
  List<Object?> get props => [
    currentState,
    musclesAndItsExercises,
    muscleExercisesCheckBox,
    dayCheckBox,
    lists,
    currentIndex,
    errorMsg
  ];
}