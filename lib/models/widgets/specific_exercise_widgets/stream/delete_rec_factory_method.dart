import 'package:be_fit/model/remote/firebase_service/fire_store/cardio/implementation.dart';
import 'package:be_fit/models/data_types/delete_record.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import '../../../../model/remote/firebase_service/fire_store/exercises/implementation.dart';
import '../../../../model/remote/firebase_service/fire_store/interface.dart';

class DeleteExecuter {
  ExercisesMain factory({required Exercises exercise, required recId}) {
    late ExercisesMain exerciseType;

    switch (exercise.muscleName) {
      case 'cardio':
        exerciseType = CardioRepo(
          deleteRecModel: DeleteRecForExercise(
              muscleName: exercise.muscleName!,
              exerciseId: exercise.id,
              recId: recId
          ),
        );
      default:
        switch (exercise.isCustom) {
          case true:
            exerciseType = CustomExercisesImpl(
                deleteRecModel: DeleteRecForCustomExercise(
                    exerciseId: exercise.id, recId: recId
                )
            );
          default:
            exerciseType = DefaultExercisesImpl(
              deleteRecModel: DeleteRecForExercise(
                  muscleName: exercise.muscleName!,
                  exerciseId: exercise.id,
                  recId: recId
              ),
            );
        }
    }

    return exerciseType;
  }
}
