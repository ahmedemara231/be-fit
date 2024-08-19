import 'package:be_fit/models/data_types/exercises.dart';

class FinishPlanInputs
{
  Map<String,dynamic> allPlans;
  Map<String, List<Exercises>> plan;
  String planName;

  FinishPlanInputs({
    required this.allPlans,
    required this.plan,
    required this.planName
  });
}