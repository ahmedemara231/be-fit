import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/interface.dart';

import 'models/add_to_existing_plan.dart';
import 'models/delete_exercise_from_plan.dart';
import 'models/get_plans_results.dart';

class PlansDataSource{

  PlansInterface instance;
  PlansDataSource(this.instance);

  Future<GetPlansResults> getAllPlans()async{
    return await instance.getAllPlans();
  }

  Future<String> deletePlan(String planId)async{
    return await instance.deletePlan(planId);
  }

  Future<String> deleteExerciseFromPlan(DeleteFromPlanModel inputs)async{
    return await instance.deleteExerciseFromPlan(inputs);
  }

  Future<String> addExerciseToPlan(AddExerciseToExistingPlanModel model)async{
    return await instance.addExerciseToExistingPlan(model);
  }
}