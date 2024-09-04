import 'dart:async';
import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/model/local/cache_helper/shared_prefs.dart';
import 'package:be_fit/models/data_types/dialog_inputs.dart';
import 'package:be_fit/models/widgets/app_dialog.dart';
import 'package:be_fit/view/plans/create_plan/continue_planning.dart';
import 'package:be_fit/view_model/plan_creation/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  void addCustomExerciseToMuscles(CustomExercises exercise)
  {
    if(musclesAndItsExercises[exercise.muscleName] == null)
      {
        return;
      }
    else{
      musclesAndItsExercises[exercise.muscleName]!.add(exercise);
      muscleExercisesCheckBox[exercise.muscleName]!.add(false);
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
    makeListForEachDay(day);
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
  void makeListForEachDay(int numberOfDays)
  {
    lists = {};

    for(int i = 1; i <= numberOfDays; i++)
    {
      lists['list$i'] = [];
    }
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


  Future<void> askUserIfHeIsBeginner(BuildContext context)async
  {
    await AppDialog.showAppDialog(
        context,
        inputs: DialogInputs(
          title: 'If you are beginner click yes and Receive your plan',
          confirmButtonText: 'Make Plan',
          cancelButtonText: 'not Beginner',
          onTapConfirm: () async=> handleBeginnerClick(context),
          onTapCancel: ()async => handleCancelClick(context),
        )
    );
  }

  Future<void> handleBeginnerClick(BuildContext context)async
  {
    context.normalNewRoute(
        const ContinuePlanning(
            name: 'Beginner Plan',
            daysNumber: 3
        )
    );
    await createBeginnerPlan(context);
    await CacheHelper.getInstance().setData(
        key: 'isBeginner',
        value: false
    );
  }

  Future<void> handleCancelClick(BuildContext context)async
  {
    Navigator.pop(context);
    await CacheHelper.getInstance().setData(
        key: 'isBeginner',
        value: false
    );
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

  Future<void> createBeginnerPlan(BuildContext context)async
  {
    EasyLoading.show(status: 'loading...');
    await finishGettingMuscles(context, day: 3);
    for(String muscle in Constants.muscles)
      {
        musclesAndItsExercises[muscle]!.shuffle();
      }

    for(int i = 1; i <= 3; i++)
      {
        switch(i)
        {
          case 1:
            addToListOne(i);

          case 2 :
            addToListTwo(i);

          case 3:
            addToListThree(i);
        }
      }
    EasyLoading.dismiss();
    emit(PreparPlanState());
  }


  void addToListsToBeginners({
    required int i, // 1
    required String muscle,
    required int numberOfExercises
})
  {
    for(int index = 1; index <= numberOfExercises; index++)
      {
        lists['list$i']?.add(
          musclesAndItsExercises[muscle]![index],
        );
      }
  }

  void addToListOne(int i)
  {
    for (var muscle in Constants.muscles) {
      switch(muscle)
      {
        case 'chest':
          addToListsToBeginners(i: i, muscle: muscle, numberOfExercises: 3);

        case 'Shoulders':
        case 'triceps':
          addToListsToBeginners(i: i, muscle: muscle, numberOfExercises: 2);
      }
    }
  }

  void addToListTwo(int i)
  {
    for(var muscle in Constants.muscles)
    {
      switch(muscle)
      {
        case 'Back':
          addToListsToBeginners(i: i, muscle: muscle, numberOfExercises: 4);
        case 'biceps':
          addToListsToBeginners(i: i, muscle: muscle, numberOfExercises: 2);
      }
    }
  }

  void addToListThree(int i)
  {
    for(var muscle in Constants.muscles)
    {
      switch(muscle)
      {
        case 'legs':
          addToListsToBeginners(i: i, muscle: muscle, numberOfExercises: 5);
      }
    }
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