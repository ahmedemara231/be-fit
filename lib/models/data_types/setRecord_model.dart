import 'package:be_fit/models/data_types/exercises.dart';

import 'controllers.dart';

class SetRecModel
{
  String muscleName;
  String exerciseId;
  Controllers controllers;

  SetRecModel({
    required this.muscleName,
    required this.exerciseId,
    required this.controllers,
  });
}

class SetCustomExerciseRecModel extends SetRecModel
{

  SetCustomExerciseRecModel({
    required super.exerciseId,
    required super.muscleName,
    required super.controllers,
});
}

class SetRecordForPlanExercise
{
  String planDoc;
  int listIndex;
  Exercises exercise;
  String reps;
  String weight;
  String uId;

  SetRecordForPlanExercise({
    required this.planDoc,
    required this.listIndex,
    required this.exercise,
    required this.reps,
    required this.weight,
    required this.uId,
  });
}