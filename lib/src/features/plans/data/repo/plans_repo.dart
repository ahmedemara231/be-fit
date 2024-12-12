import 'package:be_fit/src/core/data_source/remote/firebase_service/error_handling/base_error.dart';
import 'package:be_fit/src/core/data_source/remote/firebase_service/extensions/future.dart';
import 'package:multiple_result/multiple_result.dart';

import '../data_source/data_source.dart';
import '../data_source/models/add_to_existing_plan.dart';
import '../data_source/models/delete_exercise_from_plan.dart';
import '../data_source/models/get_plans_results.dart';

class PlansRepo{

  PlansDataSource dataSource;
  PlansRepo(this.dataSource);

  Future<Result<GetPlansResults, FirebaseError>> getAllPlans()async{
    return await dataSource
        .getAllPlans()
        .handleFirebaseCalls();
  }

  Future<Result<String, FirebaseError>> deletePlan(String planId)async{
    return await dataSource
        .deletePlan(planId)
        .handleFirebaseCalls();
  }

  Future<Result<String, FirebaseError>> deleteExerciseFromPlan(DeleteFromPlanModel inputs) async{
    return await dataSource
        .deleteExerciseFromPlan(inputs)
        .handleFirebaseCalls();
  }

  Future<Result<String, FirebaseError>> addExerciseToPlan(AddExerciseToExistingPlanModel model) async{
    return await dataSource
        .addExerciseToPlan(model)
        .handleFirebaseCalls();
  }
}