import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/interface.dart';
import '../../../../core/data_source/remote/firebase_service/fire_store/exercises/implementation.dart';
import '../../../../core/helpers/global_data_types/exercises.dart';
import '../../../exercises/data/data_source/models/pick_precord.dart';

class GetRecordsExecuter {
  static ExercisesInterface factory(Exercises exercise) {
    late ExercisesInterface exerciseType;
    switch(exercise.isCustom) {
      case true :
        exerciseType = CustomExercisesImpl(
            getRecordForCustom: GetRecordForCustom(
              exerciseDoc: exercise.id,
            )
        );
      default:
        exerciseType = DefaultExercisesImpl(
          getRecord: GetRecord(
            muscleName: exercise.muscleName!,
            exerciseDoc: exercise.id,
          ),
        );
    }

    return exerciseType;
  }
}