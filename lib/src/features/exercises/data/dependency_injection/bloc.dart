import 'dart:async';
import 'package:be_fit/src/core/data_source/remote/firebase_service/fireStorage/implementation.dart';
import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/exercises/implementation.dart';
import 'package:be_fit/src/features/exercises/data/data_source/exercises_data_source.dart';
import 'package:be_fit/src/features/exercises/data/repo/exercises_repo.dart';
import 'package:be_fit/src/features/exercises/presentation/blocs/exercises/cubit.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/data_source/remote/firebase_service/fire_store/interface.dart';

class ExercisesDependencies{
  static final exercisesLocator = GetIt.instance;
  static final _streamController = StreamController<ExercisesInterface>.broadcast();

  static void config(){
    exercisesLocator.allowReassignment = true;
  }

  static void setBloc(){
    exercisesLocator.registerLazySingleton<ExercisesCubit>(() =>
        ExercisesCubit(
            ExercisesRepoImpl(
                ExercisesDataSource(
                    interface: exercisesLocator.get<ExercisesInterface>(),
                    service: FireStorageCall()
                )
            )
        ),
    );
  }

  static void registerExercisesInterface(){
    exercisesLocator.registerLazySingleton<ExercisesInterface>(
          () => ExercisesImplProxy(DefaultExercisesImpl()),
    );
  }

  static Future<void> changeExercisesType(ExercisesInterface instance)async {
    final proxy = exercisesLocator<ExercisesInterface>() as ExercisesImplProxy;

    proxy.switchDataSource(instance);
    // exercisesLocator.registerSingleton<ExercisesInterface>(instance);
    _streamController.add(instance);
    await Future.delayed(const Duration(milliseconds: 2));
  }

  static Stream<ExercisesInterface> get exercisesStream => _streamController.stream;
}