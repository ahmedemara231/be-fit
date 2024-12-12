import 'package:be_fit/src/core/data_source/remote/firebase_service/error_handling/base_error.dart';
import 'package:be_fit/src/core/data_source/remote/firebase_service/extensions/future.dart';
import 'package:be_fit/src/features/create_plan/data/data_source/data_source.dart';
import 'package:be_fit/src/features/create_plan/data/data_source/models/return_all_exercises.dart';
import 'package:multiple_result/multiple_result.dart';
import '../data_source/models/make_plan.dart';

class CreatePlanRepo{
  CreatePlanDataSource instance;

  CreatePlanRepo(this.instance);

  Future<Result<String, FirebaseError>> createPlan(MakePlanModel model)async{
    return await instance
        .createPlan(model)
        .handleFirebaseCalls();
  }

  Future<Result<ReturnAllExercises, FirebaseError>> getMusclesExercisesToMakePlan()async{
    return await instance
        .getExercisesToMakePlan()
        .handleFirebaseCalls();
  }
}