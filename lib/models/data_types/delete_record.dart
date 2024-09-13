class DeleteRecForExercise
{
  String muscleName;
  String exerciseId;
  String recId;

  DeleteRecForExercise({
    required this.muscleName,
    required this.exerciseId,
    required this.recId
  });
}

class DeleteRecForCustomExercise
{
  String exerciseId;
  String recId;

  DeleteRecForCustomExercise({
    required this.exerciseId,
    required this.recId
  });
}