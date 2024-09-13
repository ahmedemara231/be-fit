import 'package:be_fit/model/remote/firebase_service/fire_store/interface.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import '../../../../model/remote/firebase_service/fire_store/exercises/implementation.dart';
import '../../../data_types/setRecord_model.dart';

class SetRecExecuter
{
  ExercisesMain factory({required Exercises exercise, required SetRecModel model})
  {
    late ExercisesMain exercisesType;
    switch(exercise.isCustom)
    {
      case true:
        exercisesType = CustomExercisesImpl(model: model);
      default:
        exercisesType = DefaultExercisesImpl(model: model);
    }

    return exercisesType;
  }
}