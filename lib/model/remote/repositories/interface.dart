import 'package:be_fit/model/error_handling.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/data_types/setRecord_model.dart';
import 'package:be_fit/view/statistics/statistics.dart';
import 'package:flutter/cupertino.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class ExercisesMain
{
  Future<Result<List<Exercises>,FirebaseError>> getExercises(BuildContext context, String muscleName);

  Future<void> deleteExercise(BuildContext context,{
    required Exercises exercise,
    required String muscleName
  });

  Future<void> setRecords(SetRecModel model);

  List<Exercises> search(String pattern);
}

abstract class MainFunctions
{
  Future<Result<List<MyRecord>,FirebaseError>> getRecords(BuildContext context);
}
