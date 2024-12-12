import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/plans/implementation.dart';
import 'package:be_fit/src/features/plans/data/data_source/data_source.dart';
import 'package:be_fit/src/features/plans/data/repo/plans_repo.dart';
import 'package:be_fit/src/features/plans/presentation/bloc/cubit.dart';
import 'package:get_it/get_it.dart';

class PlansDependencies{

  static final plansLocator = GetIt.instance;
  static void setBloc(){
    plansLocator.registerLazySingleton(() => PlansCubit(
        PlansRepo(
            PlansDataSource(
                PlansImpl()
            )
        )
    ));
  }
}