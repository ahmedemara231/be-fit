import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/error_handling/handling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../../features/create_plan/data/data_source/models/muscles_and_checkbox.dart';
import '../../../../../../../features/create_plan/data/data_source/models/return_all_exercises.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../helpers/global_data_types/exercises.dart';
import '../../interface.dart';
import 'factory_method.dart';

class GetExercisesToMakePlanImpl implements GetMusclesExercisesToMakePlanInterface {
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

  late GetExercisesForEachMuscleToMakePlanInterface getUserExercises;

  @override
  Future<ReturnAllExercises> getMuscles()async
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

      return result;
    } on FirebaseException catch(e)
    {
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }
  }

  Future<void> finishGetExercises(String muscleName)async
  {
    ExercisesAndCheckBox result = await getUserExercises.getExercise(muscleName);
    musclesAndItsExercises[muscleName] = result.exercises;
    muscleExercisesCheckBox[muscleName] = result.checkBox;
  }

}