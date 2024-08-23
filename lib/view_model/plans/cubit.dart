import 'dart:async';
import 'package:be_fit/model/remote/repositories/plans/implementation.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/data_types/delete_exercise_from_plan.dart';

class PlansCubit extends Cubit<PlansStates>
{
  PlansCubit(super.initialState);
  static PlansCubit getInstance(context) => BlocProvider.of(context);

  Map<String,dynamic> allPlans = {};
  List<String> allPlansIds = [];

  PlansRepo repo = PlansRepo();

  Future<void> getAllPlans(context)async
  {
    emit(GetAllPlansLoadingState());
    final result = await repo.getAllPlans(context);
    if(result.isSuccess())
    {
      allPlans = result.getOrThrow().allPlans;
      allPlansIds = result.getOrThrow().plansIds;
      emit(GetAllPlansSuccessState());
    }
    else{
      emit(GetAllPlansErrorState());
    }
  }

  Future<void> getPlans(BuildContext context)async
  {
    if(allPlans.isEmpty)
    {
      await getAllPlans(context);
    }
  }

  Future<void> deletePlan(context,{
    required int index,
    required String planName,
  })async
  {
    final result = await repo.deletePlan(context, planId: allPlansIds[index]);
    if(result.isSuccess())
      {
        allPlans.remove(planName);
        allPlansIds.remove(allPlansIds[index]);
        emit(DeletePlanState());
      }
    else{
      emit(DeletePlanErrorState());
    }
  }

  Future<void> deleteExerciseFromPlan(BuildContext context,{
    required DeleteFromPlanModel inputs,
  })async
  {
    final exercisesList = allPlans[inputs.planName]['list${inputs.listIndex}'] as List;

    final result = await repo.deleteExerciseFromPlan(context, inputs: inputs);
    if(result.isSuccess())
      {
        exercisesList.removeAt(inputs.exerciseIndex);

        if(exercisesList.isEmpty)
        {
          // (allPlans[inputs.planName] as Map<String, List<Exercises>>).removeWhere((key, value) => value.isEmpty);
          Navigator.pop(context);
        }
        emit(DeleteExerciseFromPlanSuccessState());
      }
    else{
      emit(DeleteExerciseFromPlanErrorState());
    }
  }

  Map<String,dynamic> roadToPlanExercise = {};
}