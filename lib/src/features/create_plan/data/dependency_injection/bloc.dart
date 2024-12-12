import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/plan_creation/create_plan/implementation.dart';
import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/plan_creation/get_exercises/get_exercises_to_make_plan.dart';
import 'package:be_fit/src/features/create_plan/data/data_source/data_source.dart';
import 'package:be_fit/src/features/create_plan/data/repo/create_plan_repo.dart';
import 'package:be_fit/src/features/create_plan/presentation/bloc/cubit.dart';
import 'package:get_it/get_it.dart';

class CreatePlanDependencies{

  static final exercisesLocator = GetIt.instance;
  static void setBloc(){
    exercisesLocator.registerLazySingleton<PlanCreationCubit>(() => PlanCreationCubit(
        CreatePlanRepo(
            CreatePlanDataSource(
                planCreationInterface: PlanCreationImpl(),
                getExercisesToMakePlanImpl: GetExercisesToMakePlanImpl()
            )
        )
    ));
  }
}