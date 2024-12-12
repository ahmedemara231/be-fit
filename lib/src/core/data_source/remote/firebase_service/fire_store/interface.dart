import '../../../../../features/cardio/data/data_source/models/cardio_records.dart';
import '../../../../../features/cardio/data/data_source/models/set_cardio_rec_model.dart';
import '../../../../../features/create_plan/data/data_source/models/make_plan.dart';
import '../../../../../features/create_plan/data/data_source/models/muscles_and_checkbox.dart';
import '../../../../../features/create_plan/data/data_source/models/return_all_exercises.dart';
import '../../../../../features/plans/data/data_source/models/add_to_existing_plan.dart';
import '../../../../../features/plans/data/data_source/models/delete_exercise_from_plan.dart';
import '../../../../../features/plans/data/data_source/models/get_plans_results.dart';
import '../../../../../features/statistics/data/data_source/models/record.dart';
import '../../../../helpers/global_data_types/delete_record.dart';
import '../../../../helpers/global_data_types/exercises.dart';

// exercises interfaces
abstract interface class ExercisesInterface {
  Future<List<Exercises>> getExercises(String muscleName);

  Future<String> deleteExercise(Exercises exercise);

  Future<String> setRecords();

  Future<List<MyRecord>> getRecords();

  Future<String> deleteRecord();
}


abstract interface class CardioExercisesInterface {
  Future<List<Exercises>> getExercises();

  Future<String> deleteExercise(Exercises exercise);

  Future<String> setRecords(SetCardioRecModel? model);

  Future<List<CardioRecords>> getRecords(String exerciseId);

  Future<String> deleteRecord(DeleteRecForExercise? deleteRecModel);
}

// make plan interfaces
abstract interface class GetMusclesExercisesToMakePlanInterface{
  Future<ReturnAllExercises> getMuscles();
}

abstract interface class GetExercisesForEachMuscleToMakePlanInterface {
  Future<ExercisesAndCheckBox> getExercise(String muscleName);
}

abstract interface class PlanCreationInterface {
  Future<String> createNewPlan(MakePlanModel makePlanModel);
}


//plan interface
abstract interface class PlansInterface{
  Future<GetPlansResults> getAllPlans();
  Future<String> deletePlan(String planId);
  Future<String> deleteExerciseFromPlan(DeleteFromPlanModel inputs);
  Future<String> addExerciseToExistingPlan(AddExerciseToExistingPlanModel model);
  }