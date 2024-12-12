import 'dart:async';
import 'package:be_fit/src/features/plans/presentation/bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/global_data_types/exercises.dart';
import '../../data/data_source/models/add_to_existing_plan.dart';
import '../../data/data_source/models/delete_exercise_from_plan.dart';
import '../../data/repo/plans_repo.dart';

class PlansCubit extends Cubit<PlansState> {
  PlansCubit(this.repo) : super(PlansState.initial());
  PlansRepo repo;

  Future<void> getAllPlans()async {
    emit(state.copyWith(state: PlansInternalStates.getPlansLoading));

    final result = await repo.getAllPlans();
    result.when(
            (success) => emit(state.copyWith(
              state: PlansInternalStates.getPlansSuccess,
              allPlans: result.getOrThrow().allPlans,
              allPlansIds: result.getOrThrow().plansIds,
            )),
            (error) =>    emit(state.copyWith(
                state: PlansInternalStates.getPlansError,
                errorMessage: result.tryGetError()?.message
            ))
    );
  }

  Future<void> getPlans()async {
    if(state.allPlans!.isEmpty) {
      await getAllPlans();
    }
  }

  Future<void> deletePlan({
    required int index,
    required String planName,
  })async {
    final result = await repo.deletePlan(state.allPlansIds!.elementAt(index));
    if(result.isSuccess()) {
        final newPlans = {...?state.allPlans};
        newPlans.remove(planName);
        final newPlansIds = [...?state.allPlansIds];
        newPlansIds.remove(index);

        emit(state.copyWith(
            state: PlansInternalStates.deletePlanSuccess,
            allPlans: newPlans,
            allPlansIds: newPlansIds
        ));
      }
    else{
      emit(state.copyWith(
          state: PlansInternalStates.deletePlanError,
          errorMessage: result.tryGetError()?.message,
      ));
    }
  }

  Future<void> deleteExerciseFromPlan({
    required DeleteFromPlanModel inputs,
  })async {
    final result = await repo.deleteExerciseFromPlan(inputs);

    if(result.isSuccess()) {
      final List<Exercises> exercisesList = [...state.allPlans?[inputs.planName]['list${inputs.listIndex}']];
      exercisesList.removeAt(inputs.exerciseIndex);
      final newPlans = {...?state.allPlans};
      newPlans[inputs.planName]['list${inputs.listIndex}'] = exercisesList;

      emit(state.copyWith(
          state: PlansInternalStates.deleteExerciseFromPlanSuccess,
          allPlans: newPlans
      ));
        // if(exercisesList.isEmpty)
        // {
          // Navigator.pop(context);
        // }
      }
    else{
      emit(state.copyWith(
        state: PlansInternalStates.deleteExerciseFromPlanError,
        errorMessage: result.tryGetError()?.message
      ));
    }
  }

  Map<String,dynamic> roadToPlanExercise = {};

  Future<void> addExercisesToExistingPlanInDatabase({
    required List<Exercises> exercises
  })async {
    final model = AddExerciseToExistingPlanModel(
        planId: roadToPlanExercise['planDoc'],
        list: 'list${roadToPlanExercise['listIndex']}',
        exercises: exercises
    );

    final result = await repo.addExerciseToPlan(model);
    result.when(
            (success) =>   emit(state.copyWith(
                state: PlansInternalStates.addExercisesToExistingPlanSuccess,
                allPlans: addExercisesToExistingPlan(exercises)
            )),
            (error) => emit(state.copyWith(
                state: PlansInternalStates.addExercisesToExistingPlanError,
                errorMessage: result.tryGetError()?.message
            ))
    );
  }

  Map<String, dynamic> addExercisesToExistingPlan(List<Exercises> addedExercises) {
    final newPlans = {...?state.allPlans};
    for(Exercises exercise in addedExercises) {
        (newPlans[roadToPlanExercise['planName']]
        ['list${roadToPlanExercise['listIndex']}'] as List).add(exercise);
      }

    return newPlans;
  }
}