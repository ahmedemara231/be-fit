import 'exercises.dart';

class AddExerciseToExistingPlanModel
{
   String planId;
   String list;
   List<Exercises> exercises;

   AddExerciseToExistingPlanModel({
     required this.planId,
     required this.list,
     required this.exercises
});
}