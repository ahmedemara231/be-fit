import 'package:be_fit/src/core/data_source/remote/firebase_service/fireStorage/implementation.dart';
import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/exercises/implementation.dart';
import 'package:be_fit/src/features/cardio/presentation/bloc/cardio_cubit.dart';
import 'package:be_fit/src/features/exercises/data/data_source/exercises_data_source.dart';
import 'package:be_fit/src/features/exercises/data/repo/exercises_repo.dart';
import 'package:be_fit/src/features/exercises/presentation/blocs/exercises/cubit.dart';
import 'package:be_fit/src/features/statistics/data/data_source/data_source.dart';
import 'package:be_fit/src/features/statistics/data/repo/repo.dart';
import 'package:be_fit/src/features/statistics/presentation/bloc/cubit.dart';
import 'package:be_fit/src/features/statistics/presentation/screens/statistics.dart';
import 'package:get_it/get_it.dart';

class StatisticsDependencies{

  static final exercisesLocator = GetIt.instance;

  // static void changeDependencies(CardioExercisesInterface newInstance){
  //   exercisesLocator.unregister<CardioExercisesInterface>();
  //   exercisesLocator.registerFactory<CardioExercisesInterface>(() => newInstance);
  // }

  static void setBloc(){
    exercisesLocator.registerFactory<StatisticsCubit>(() => StatisticsCubit(
      StatisticsRepo(StatisticsDataSource(DefaultExercisesImpl()))
    ),);
  }
}