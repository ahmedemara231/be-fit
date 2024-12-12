import '../../../../data_source/remote/firebase_service/fire_store/exercises/implementation.dart';
import '../../../../data_source/remote/firebase_service/fire_store/interface.dart';
import '../../../global_data_types/delete_record.dart';
import '../../../global_data_types/exercises.dart';

class DeleteRec {
  static ExercisesInterface factory({required Exercises exercise, required String recId}) {
    late ExercisesInterface exerciseType;

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
    return exerciseType;
  }
}
