import 'package:be_fit/models/data_types/exercises.dart';

class DeleteCustomExercise
{
  Exercises exercise;
  String muscleName;

  DeleteCustomExercise({required this.muscleName, required this.exercise});
}