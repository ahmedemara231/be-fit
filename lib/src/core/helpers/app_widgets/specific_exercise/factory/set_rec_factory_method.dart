import '../../../../../features/exercises/data/data_source/models/set_record_model.dart';
import '../../../../data_source/remote/firebase_service/fire_store/exercises/implementation.dart';
import '../../../../data_source/remote/firebase_service/fire_store/interface.dart';
import '../../../global_data_types/exercises.dart';

class SetRec {
  static ExercisesInterface factory({
    required Exercises exercise,
    required SetRecModel model
  }) {
    late ExercisesInterface exercisesType;
    switch(exercise.isCustom) {
      case true:
        exercisesType = CustomExercisesImpl(model: model);
      default:
        exercisesType = DefaultExercisesImpl(model: model);
    }

    return exercisesType;
  }
}