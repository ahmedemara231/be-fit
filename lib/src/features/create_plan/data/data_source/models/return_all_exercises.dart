
import '../../../../../core/helpers/global_data_types/exercises.dart';

class ReturnAllExercises
{
  Map<String, List<Exercises>> musclesAndItsExercises;
  Map<String, List<bool>> muscleExercisesCheckBox;

  ReturnAllExercises({
    required this.musclesAndItsExercises,
    required this.muscleExercisesCheckBox
  });
}