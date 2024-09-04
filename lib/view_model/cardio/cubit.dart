import 'package:be_fit/model/remote/repositories/cardio/implementation.dart';
import 'package:be_fit/model/remote/repositories/interface.dart';
import 'package:be_fit/models/data_types/cardio_records.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/view_model/cardio/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardioCubit extends Cubit<CardioStates> {
  CardioCubit(super.initialState);
  static CardioCubit getInstance(context) => BlocProvider.of(context);

  List<Exercises> cardioExercises = [];
  List<Exercises> cardioExercisesList = [];
  ExercisesMain repo = CardioRepo();
  Future<void> getCardioExercises(BuildContext context)async
  {
    if(cardioExercises.isEmpty)
      {
        emit(GetCardioExercisesLoading());
        final result = await repo.getExercises(context, 'cardio');
        if(result.isSuccess())
        {
          cardioExercises = result.getOrThrow();
          cardioExercisesList = List.from(cardioExercises);

          emit(GetCardioExercisesSuccess());
        }
        else{
          emit(GetCardioExercisesError());
        }
      }
  }

  void search(String pattern)
  {
    if(pattern.isEmpty)
    {
      cardioExercisesList = List.from(cardioExercises);
    }
    else{
      cardioExercisesList = cardioExercises.where((element) => element.name.contains(pattern)).toList();
    }
    emit(NewSearchState());
  }

  Future<void> setRecord({dynamic time, required ExercisesMain repo})async
  {
    await repo.setRecords();
    emit(SetRecordSuccessState());
  }

  late List<CardioRecords> records;
  Future<void> getRecords(BuildContext context, {required ExercisesMain repo})async
  {
    records = [];
    emit(GetCardioRecordsLoading());
    final result = await repo.getRecords(context);
    if(result.isSuccess())
      {
        records = result.getOrThrow();
        print(records);
        emit(GetCardioRecordsSuccess());
      }
    else{
      emit(GetCardioRecordsError());
    }
  }
}