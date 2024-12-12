import 'package:be_fit/src/features/auth/data/dependency_injection/bloc.dart';
import 'package:be_fit/src/features/cardio/data/dependency_injection/bloc.dart';
import 'package:be_fit/src/features/exercises/data/dependency_injection/bloc.dart';
import 'package:be_fit/src/features/plans/data/dependency_injection/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../features/create_plan/data/dependency_injection/bloc.dart';
import '../../../features/statistics/data/dependency_injection/bloc.dart';


class ServiceLocator{
  final _getIt = GetIt.instance;

  void prepareAllDependencies(){
    setGeneralDependencies();
    AuthDependencies.setBloc();
    CardioDependencies.setBloc();
    PlansDependencies.setBloc();
    CreatePlanDependencies.setBloc();
    StatisticsDependencies.setBloc();

    ExercisesDependencies.config();
    ExercisesDependencies.registerExercisesInterface();
    ExercisesDependencies.setBloc();
  }

  void setGeneralDependencies(){}
}