import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/interface.dart';
import 'package:be_fit/src/features/create_plan/data/data_source/models/return_all_exercises.dart';
import 'models/make_plan.dart';

class CreatePlanDataSource{
  PlanCreationInterface planCreationInterface;
  GetMusclesExercisesToMakePlanInterface getExercisesToMakePlanImpl;

  CreatePlanDataSource({
    required this.planCreationInterface,
    required this.getExercisesToMakePlanImpl,
});

  Future<String> createPlan(MakePlanModel model)async{
    return await planCreationInterface.createNewPlan(model);
  }

  Future<ReturnAllExercises> getExercisesToMakePlan()async{
    return await getExercisesToMakePlanImpl.getMuscles();
  }
}