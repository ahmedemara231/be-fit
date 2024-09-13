import 'package:be_fit/models/data_types/exercises.dart';
import '../../../models/data_types/pick_precord.dart';
import '../../model/remote/firebase_service/fire_store/cardio/implementation.dart';
import '../../model/remote/firebase_service/fire_store/exercises/implementation.dart';
import '../../model/remote/firebase_service/fire_store/interface.dart';

class GetRecordsExecuter
{
  ExercisesMain factory(Exercises exercise)
  {
    late ExercisesMain exerciseType;
    switch(exercise.muscleName)
    {
      case 'cardio' :
        exerciseType = CardioRepo(
            exerciseId: exercise.id
        );
      default:
        switch(exercise.isCustom)
        {
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
    }

    return exerciseType;
  }
}