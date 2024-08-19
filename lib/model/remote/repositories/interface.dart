import 'package:be_fit/model/error_handling.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/data_types/setRecord_model.dart';
import 'package:be_fit/models/widgets/records_model.dart';
import 'package:be_fit/view/statistics/statistics.dart';
import 'package:flutter/cupertino.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class ExercisesMain
{
  Future<Result<List<Exercises>,NewFirebaseError>> getExercises(BuildContext context, String muscleName);

  Future<void> deleteExercise(BuildContext context,{
    required Exercises exercise,
    required String muscleName
  });
}

abstract class MainFunctions
{
  Future<Result<List<MyRecord>,NewFirebaseError>> getRecords(BuildContext context);

  Future<void> setRecords(SetRecModel model);
}
