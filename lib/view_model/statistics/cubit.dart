import 'package:be_fit/models/data_types/cardio_records.dart';
import 'package:be_fit/view_model/statistics/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/remote/firebase_service/fire_store/cardio/implementation.dart';
import '../../model/remote/firebase_service/fire_store/interface.dart';
import '../../view/statistics/statistics.dart';

class StatisticsCubit extends Cubit<StatisticsStates>
{
  StatisticsCubit() : super(StatisticsInitial());
  factory StatisticsCubit.getInstance(context) => BlocProvider.of(context);

  List<MyRecord> records = [];
  List<CardioRecords> cardioRecords = [];

  Future<void> pickRecordsToMakeChart(context,{required ExercisesMain exerciseType})async
  {
    emit(CalcStatisticsLoading());
    final result = await exerciseType.getRecords(context);
    if(result.isSuccess())
    {
      switch(exerciseType)
      {
        case CardioRepo():
          cardioRecords = result.getOrThrow();

        default:
          records = result.getOrThrow();
      }
      emit(CalcStatisticsSuccess());
    }
    else{
      emit(CalcStatisticsError());
    }

  }
}