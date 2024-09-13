import 'dart:async';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/remote/firebase_service/fire_store/plans/implementation.dart';
import '../../models/data_types/delete_exercise_from_plan.dart';

class PlansCubit extends Cubit<PlansStates>
{
  PlansCubit() : super(PlansInitialState());
  factory PlansCubit.getInstance(context) => BlocProvider.of(context);

  PlansRepo repo = PlansRepo();


  Map<String,dynamic> allPlans = {};
  List<String> allPlansIds = [];
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