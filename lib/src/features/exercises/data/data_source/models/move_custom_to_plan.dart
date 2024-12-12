import '../../../../../core/helpers/global_data_types/exercises.dart';

class MoveExerciseToPlan
{
  String planDoc;
  String planExerciseDoc;
  List<String> listsKeys;
  int index;
  Exercises element;

  MoveExerciseToPlan({
    required this.planExerciseDoc,
    required this.planDoc,
    required this.listsKeys,
    required this.index,
    required this.element
  });
}