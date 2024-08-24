import 'package:be_fit/model/error_handling.dart';
import 'package:be_fit/model/remote/repositories/interface.dart';
import 'package:be_fit/model/remote/repositories/plan_creation/get_exercises/factory_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../../constants/constants.dart';
import '../../../../../models/data_types/exercises.dart';
import '../../../../../models/data_types/muscles_and_checkbox.dart';
import '../../../../../models/data_types/return_all_exercises.dart';

class GetExercisesToMakePlan
{
  Map<String, List<Exercises>> musclesAndItsExercises = {};
  Map<String, List<bool>> muscleExercisesCheckBox = {};

  void open()
  {
    musclesAndItsExercises = {};
    muscleExercisesCheckBox = {};

    for(int i = 0; i < Constants.muscles.length; i++)
    {
      musclesAndItsExercises[Constants.muscles[i]] = [];
      muscleExercisesCheckBox[Constants.muscles[i]] = [];
    }
  }

  late GetUserExercises getUserExercises;
  Future<Result<ReturnAllExercises, FirebaseError>> getMuscles(context)async
  {
    open();

    try
    {
      for(var muscle in Constants.muscles)
        {
          getUserExercises = Executer().factory(muscle);
          await finishGetExercises(muscle);
        }

      final ReturnAllExercises result = ReturnAllExercises(
          musclesAndItsExercises: musclesAndItsExercises,
          muscleExercisesCheckBox: muscleExercisesCheckBox
      );

      return Result.success(result);
    } on FirebaseException catch(e)
    {
      final error = ErrorHandler.getInstance().handleFireStoreError(context, e);
      return Result.error(error);
    }
  }

  Future<void> finishGetExercises(String muscleName)async
  {
    ExercisesAndCheckBox result = await getUserExercises.getExercise(muscleName);

    musclesAndItsExercises[muscleName] = result.exercises;
    muscleExercisesCheckBox[muscleName] = result.checkBox;
  }
}