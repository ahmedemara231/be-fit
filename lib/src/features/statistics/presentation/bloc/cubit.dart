import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/interface.dart';
import 'package:be_fit/src/features/statistics/data/repo/repo.dart';
import 'package:be_fit/src/features/statistics/presentation/bloc/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit(this.repo) : super(StatisticsState.initial());

  StatisticsRepo repo;

  Future<void> pickRecordsToMakeChart(ExercisesInterface exerciseType)async {
    emit(state.copyWith(state: StatisticsInternalState.getRecordsLoading));
    final result = await repo.getRecords();
    result.when(
            (success) => emit(state.copyWith(
                state: StatisticsInternalState.getRecordsSuccess,
                records: result.getOrThrow()
            )),
            (error) => emit(state.copyWith(state: StatisticsInternalState.getRecordsError))
    );
  }
}