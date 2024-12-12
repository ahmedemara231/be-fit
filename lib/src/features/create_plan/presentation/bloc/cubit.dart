import 'dart:async';
import 'package:be_fit/src/core/extensions/routes.dart';
import 'package:be_fit/src/features/create_plan/data/data_source/models/change_ckeckbox_val.dart';
import 'package:be_fit/src/features/create_plan/presentation/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/data_source/local/cache_helper/shared_prefs.dart';
import '../../../../core/helpers/app_widgets/app_dialog.dart';
import '../../../../core/helpers/global_data_types/dialog_inputs.dart';
import '../../../../core/helpers/global_data_types/exercises.dart';
import '../../data/data_source/models/add_to_lists_for_beginners.dart';
import '../../data/data_source/models/make_plan.dart';
import '../../data/repo/create_plan_repo.dart';
import '../screens/continue_planning.dart';


class PlanCreationCubit extends Cubit<CreatePlanState> {
  PlanCreationCubit(this.repo) : super(CreatePlanState.initial());
  CreatePlanRepo repo;

  void addCustomExerciseToMuscles(CustomExercises exercise) {
    final newMusclesAndItsExercises = {...?state.musclesAndItsExercises};
    final newMusclesCheckBox = {...?state.muscleExercisesCheckBox};

    newMusclesAndItsExercises[exercise.muscleName]!.add(exercise);
    newMusclesCheckBox[exercise.muscleName]!.add(false);
    emit(state.copyWith(
        state: CreatePlanInternalStates.addCustomExerciseToMuscles,
        musclesAndItsExercises: newMusclesAndItsExercises,
        muscleExercisesCheckBox: newMusclesCheckBox
    ));
  }

  void removeCustomExerciseFromMuscles({
    required String muscleName,
    required String exerciseId,
  }) {
    final newMusclesAndItsExercises = {...?state.musclesAndItsExercises};
    final newMusclesCheckBox = {...?state.muscleExercisesCheckBox};

    newMusclesAndItsExercises[muscleName]!.removeWhere((element) => element.id == exerciseId);
    newMusclesCheckBox[muscleName]!.remove(false);
    emit(state.copyWith(
        state: CreatePlanInternalStates.removeCustomExerciseFromMuscles,
        musclesAndItsExercises: newMusclesAndItsExercises,
        muscleExercisesCheckBox: newMusclesCheckBox
    ));
  }

  void makeListForEachDay(int numberOfDays) {
    Map<String,List<Exercises>> lists = {};
    for(int i = 1; i <= numberOfDays; i++) {
      lists['list$i'] = [];
    }
    emit(state.copyWith(
        state: CreatePlanInternalStates.initLists,
        lists: lists
    ));
  }

  Future<void> getAllExercises()async{
    emit(state.copyWith(state: CreatePlanInternalStates.getAllMusclesLoading));
    final result = await repo.getMusclesExercisesToMakePlan();
    result.when(
            (success) => emit(state.copyWith(
              state: CreatePlanInternalStates.getAllMusclesSuccess,
              musclesAndItsExercises: result.getOrThrow().musclesAndItsExercises,
              muscleExercisesCheckBox: result.getOrThrow().muscleExercisesCheckBox,
            )),
            (error) => emit(state.copyWith(
                state: CreatePlanInternalStates.getAllMusclesError,
                errorMessage: result.tryGetError()?.message
            ))
    );
  }

  void initializingDaysCheckBox(int day) {
    Map<String,Map<String, List<bool>>> dayCheckBox = {};

    for(int i = 1; i <= day; day--) {
      dayCheckBox['day$day'] = state.muscleExercisesCheckBox!
          .map((key, value) =>
          MapEntry(key, List<bool>.from(value))
      );
    }
    emit(state.copyWith(
        state: CreatePlanInternalStates.initDayCheckbox,
        dayCheckBox: dayCheckBox
    ));
  }

  Future<void> prepareExercisesAndDaysToMakePlan(int day)async {
    makeListForEachDay(day);
    if(state.musclesAndItsExercises!.isEmpty || state.muscleExercisesCheckBox!.isEmpty) {
      await getAllExercises();
    }
    initializingDaysCheckBox(day);
  }

  void newChangeCheckBoxValue(ChangeCheckBoxVal inputs) {
    final newDayCheckbox = {...?state.dayCheckBox};
    newDayCheckbox['day${inputs.dayIndex}']?[inputs.muscle]?[inputs.exerciseIndex] = inputs.value;
    emit(state.copyWith(
      state: CreatePlanInternalStates.changeDayCheckbox,
      dayCheckBox: newDayCheckbox
    ));
  }

  void addToPlanExercises({required int day, required Exercises exercise}) {
    final newLists = {...?state.lists};
    newLists['list$day']!.add(exercise);
    emit(state.copyWith(
      state: CreatePlanInternalStates.addExerciseToLists,
      lists: newLists
    ));
  }

  void removeFromPlanExercises({required int day, required Exercises exercise}) {
    final newLists = {...?state.lists};
    newLists['list$day']!.remove(exercise);
    emit(state.copyWith(
        state: CreatePlanInternalStates.addExerciseToLists,
        lists: newLists
    ));
  }

  // Should be handled by UI
  ////////////////////////////////////////////////////////////////
  // Future<void> handleAsking(BuildContext context)async {
  //   if (CacheHelper.getInstance().getData('isBeginner') as bool) {
  //     Timer(const Duration(milliseconds: 250), ()async {
  //       await askUserIfHeIsBeginner(context);
  //     });
  //   }
  // }
  //
  // Future<void> askUserIfHeIsBeginner(BuildContext context)async {
  //   await AppDialog.showAppDialog(
  //       context,
  //       inputs: DialogInputs(
  //         title: 'If you are beginner click yes and Receive your plan',
  //         confirmButtonText: 'Make Plan',
  //         cancelButtonText: 'not Beginner',
  //         onTapConfirm: () async=> handleBeginnerClick(context),
  //         onTapCancel: ()async => handleCancelClick(context),
  //       )
  //   );
  // }
  //
  // Future<void> handleBeginnerClick(BuildContext context)async {
  //   emit(state.copyWith(state: CreatePlanInternalStates.createPlanForBeginnersLoading));
  //   context.normalNewRoute(
  //       const ContinuePlanning(
  //           name: 'Beginner Plan',
  //           daysNumber: 3
  //       )
  //   );
  //   await createBeginnerPlan();
  //   await cacheIsBeginnerData();
  //   emit(state.copyWith(state: CreatePlanInternalStates.createPlanForBeginnersSuccess));
  // }
  //
  // Future<void> handleCancelClick(BuildContext context)async {
  //   Navigator.pop(context);
  //   await CacheHelper.getInstance().setData(
  //       key: 'isBeginner',
  //       value: false
  //   );
  // }
  ////////////////////////////////////////////////////////////////


  Future<void> createPlan(MakePlanModel model)async {
    emit(state.copyWith(state: CreatePlanInternalStates.createPlanLoading));

    final result = await repo.createPlan(model);
    result.when(
            (success) => emit(state.copyWith(state: CreatePlanInternalStates.createPlanSuccess)),
            (error) => emit(state.copyWith(state: CreatePlanInternalStates.createPlanError))
    );
  }

  Future<void> cacheIsBeginnerData()async{
    await CacheHelper.getInstance().setData(
        key: 'isBeginner',
        value: false
    );
  }

  void makeDaysExercises(){
    final newMusclesAndItsExercises = {...?state.musclesAndItsExercises};
    for(String muscle in Constants.muscles) {
      newMusclesAndItsExercises[muscle]!.shuffle();
    }

    for(int i = 1; i <= 3; i++) {
      switch(i) {
        case 1:
          addToListOne(i);

        case 2 :
          addToListTwo(i);

        case 3:
          addToListThree(i);
      }
    }
  }

  Future<void> createBeginnerPlan()async {
    emit(state.copyWith(state: CreatePlanInternalStates.createPlanForBeginnersLoading));
    await prepareExercisesAndDaysToMakePlan(3);
    makeDaysExercises();
    emit(state.copyWith(state: CreatePlanInternalStates.createPlanForBeginnersSuccess));
    cacheIsBeginnerData();
  }

  void addToListsToBeginners(AddToListsForBeginnersModel model) {
    final newMusclesAndItsExercises = {...?state.musclesAndItsExercises};
    final newLists = {...?state.lists};
    for(int index = 1; index <= model.numberOfExercises; index++) {
      newLists['list${model.i}']?.add(
          newMusclesAndItsExercises[model.muscle]![index],
        );
      }
    emit(state.copyWith(
        state: CreatePlanInternalStates.addExerciseToLists,
        lists: newLists
    ));
  }

  void addToListOne(int i) {
    for (var muscle in Constants.muscles) {
      final model = AddToListsForBeginnersModel(
        i: i, // 1
        muscle: muscle,
        numberOfExercises: 3,
      );
      switch(muscle) {
        case 'chest':
          addToListsToBeginners(model);

        case 'Shoulders':
        case 'triceps':
          addToListsToBeginners(model);
      }
    }
  }

  void addToListTwo(int i) {
    for(var muscle in Constants.muscles) {
      switch(muscle) {
        case 'Back':
          addToListsToBeginners(AddToListsForBeginnersModel(
            i: i,
            muscle: muscle,
            numberOfExercises: 4,
          ));
        case 'biceps':
          addToListsToBeginners(AddToListsForBeginnersModel(
            i: i,
            muscle: muscle,
            numberOfExercises: 2,
          ));
      }
    }
  }

  void addToListThree(int i) {
    for(var muscle in Constants.muscles) {
      final model = AddToListsForBeginnersModel(
        i: i,
        muscle: muscle,
        numberOfExercises: 5,
      );
      switch(muscle) {
        case 'legs':
          addToListsToBeginners(model);
      }
    }
  }

  void changeDaysNumber(int newValue) {
    emit(state.copyWith(
      state: CreatePlanInternalStates.changeCounterVal,
      currentIndex: newValue
    ));
  }
}