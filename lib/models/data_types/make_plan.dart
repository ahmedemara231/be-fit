import 'exercises.dart';

class MakePlanModel
{
  int? daysNumber;
  String name;
  Map<String,List<Exercises>> lists = {};

  MakePlanModel({
    required this.daysNumber,
    required this.name,
    required this.lists,
});
}