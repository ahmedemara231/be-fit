class GetRecordToPlan
{
  double weight;
  double reps;
  String dateTime;

  GetRecordToPlan({
    required this.weight,
    required this.reps,
    required this.dateTime,
  });

  Map<String,dynamic> toJson()
  {
    return {
      'weight' : weight,
      'reps' : reps,
      'dateTime' : dateTime,
    };
  }
}