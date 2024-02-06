import 'package:be_fit/models/data_types/exercises.dart';

class SetRecModel
{
  String muscleName;
  String exerciseId;
  String weight;
  String reps;
  String uId;

  SetRecModel({
    required this.muscleName,
    required this.exerciseId,
    required this.weight,
    required this.reps,
    required this.uId,
});
}

class SetCustomExerciseRecModel
{
  int index;
  String reps;
  String weight;
  String uId;
  String exerciseDoc;

  SetCustomExerciseRecModel({
    required this.index,
    required this.reps,
    required this.weight,
    required this.uId,
    required this.exerciseDoc,
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