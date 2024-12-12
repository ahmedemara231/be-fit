import 'package:be_fit/src/features/cardio/presentation/bloc/cardio_cubit.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/data_source/remote/firebase_service/fire_store/cardio/implementation.dart';
import '../../../../core/data_source/remote/firebase_service/fire_store/interface.dart';
import '../data_source/cardio_data_source.dart';
import '../repo/cario_repo.dart';

class CardioDependencies{

  static final cardioLocator = GetIt.instance;

  static void changeDependencies(CardioExercisesInterface newInstance){
    cardioLocator.unregister<CardioExercisesInterface>();
    cardioLocator.registerFactory<CardioExercisesInterface>(() => newInstance);
  }

  static void setBloc(){
    cardioLocator.registerFactory<NewCardioCubit>(() => NewCardioCubit(
        CardioRepo(
            CardioDataSource(
                cardioLocator.get<CardioExercisesInterface>()
            )
        )
    ),);
    cardioLocator.registerFactory<CardioExercisesInterface>(() => CardioImpl());
  }
}