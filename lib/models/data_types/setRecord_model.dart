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

  SetCustomExerciseRecModel({
    required this.index,
    required this.reps,
    required this.weight,
    required this.uId,
});
}

class SetRecordForPlanExercise
{
  String planDoc;
  int listIndex;
  String exerciseDoc;
  String reps;
  String weight;
  String uId;

  SetRecordForPlanExercise({
    required this.planDoc,
    required this.listIndex,
    required this.exerciseDoc,
    required this.reps,
    required this.weight,
    required this.uId,
  });
}