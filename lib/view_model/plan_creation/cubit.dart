import 'dart:async';
import 'dart:developer';
import 'package:be_fit/view_model/plan_creation/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/remote/repositories/plan_creation/create_plan/implementation.dart';
import '../../model/remote/repositories/plan_creation/get_exercises/get_exercises_to_make_plan.dart';
import '../../models/data_types/exercises.dart';
import '../../models/data_types/make_plan.dart';

class PlanCreationCubit extends Cubit<PlanCreationStates>
{
  PlanCreationCubit(super.initialState);

  static PlanCreationCubit getInstance(context) => BlocProvider.of(context);

  Map<String, List<Exercises>> musclesAndItsExercises = {};
  Map<String, List<bool>> muscleExercisesCheckBox = {};

  void addCustomExerciseToMuscles(String muscleName, CustomExercises exercise)
  {
    if(musclesAndItsExercises[muscleName] == null)
      {
        return;
      }
    else{
      musclesAndItsExercises[muscleName]!.add(exercise);
      muscleExercisesCheckBox[muscleName]!.add(false);
      emit(AddCustomExerciseToMuscles());
    }
  }

  void removeCustomExerciseFromMuscles({
    required String muscleName,
    required String exerciseId,
  })
  {
    if(musclesAndItsExercises[muscleName] == null)
    {
      return;
    }
    else{
      musclesAndItsExercises[muscleName]!.removeWhere((element) => element.id == exerciseId);
      muscleExercisesCheckBox[muscleName]!.remove(false);
      emit(RemoveCustomExerciseFromMuscles());
    }
  }

  // day ,    musclesCheckBox
  Map<String,Map<String, List<bool>>> dayCheckBox = {};
  void initializingDaysCheckBox(int day)
  {
    for(int i = 1; i <= day; day--)
    {
      dayCheckBox['day$day'] = muscleExercisesCheckBox
          .map((key, value) => MapEntry(key, List<bool>.from(value)));
    }
  }

  Future<void> finishGettingMuscles(BuildContext context, {required int day})async
  {
    if(musclesAndItsExercises.isEmpty || musclesAndItsExercises.isEmpty)
    {
      await getAllExercises(context);
    }
    initializingDaysCheckBox(day);
  }

  void newChangeCheckBoxValue({
    required int dayIndex,
    required String muscle,
    required int exerciseIndex,
    required bool value,
  })
  {
    dayCheckBox['day$dayIndex']?[muscle]?[exerciseIndex] = value;
    emit(ChangeCheckBoxValue());
  }

  Map<String,List<Exercises>> lists = {};
  void makeListForEachDay(int? numberOfDays)
  {
    lists = {};

    for(int i = 1; i <= numberOfDays!; i++)
    {
      lists['list$i'] = [];
    }
    log('$lists');
  }

  void addToPlanExercises(int day,Exercises exercise)
  {
    lists['list$day']!.add(exercise);
    emit(AddToExercisePlanList());
  }

  void removeFromPlanExercises(int day,Exercises exercise)
  {
    lists['list$day']!.remove(exercise);
    emit(RemoveFromExercisePlanList());
  }

  Future<void> createPlan(BuildContext context, MakePlanModel model)async
  {
    emit(CreateNewPlanLoadingState());
    await PlanCreationRepo().createNewPlan(context, makePlanModel: model)
        .then((result) async{
      if(result.isSuccess())
      {
        emit(CreateNewPlanSuccessState());
      }
      else{
        emit(CreateNewPlanErrorState());
      }
    });

  }

  int currentIndex = 1;
  void changeDaysNumber(int newValue)
  {
    currentIndex = newValue;
    emit(ChangeDaysNumber());
  }

  Future<void> getAllExercises(context)async
  {
    emit(GetAllMusclesLoadingState());
    final result = await GetExercisesToMakePlan().getMuscles(context);
    if(result.isSuccess())
      {
        musclesAndItsExercises = result.getOrThrow().musclesAndItsExercises;
        muscleExercisesCheckBox = result.getOrThrow().muscleExercisesCheckBox;

        emit(GetAllMusclesSuccessState());
      }
    else{
      emit(GetAllMusclesErrorState());
    }
  }
}