class SetRecordModel
{
  double weight;
  double reps;
  String dateTime;
  String uId;

  SetRecordModel({
    required this.weight,
    required this.reps,
    required this.dateTime,
    required this.uId
  });

  Map<String,dynamic> toJson()
  {
    return {
      'weight' : weight,
      'reps' : reps,
      'dateTime' : dateTime,
      'uId' : uId,
    };
  }
}