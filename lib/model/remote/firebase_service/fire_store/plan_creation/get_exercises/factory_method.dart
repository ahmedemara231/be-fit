import '../../interface.dart';
import 'impl.dart';

class Executer
{
  GetUserExercises factory(String muscle)
  {
    switch(muscle)
    {
      case 'chest':
        return GetChestExercises();

      case 'Back' :
        return GetBackExercises();

      case 'Aps' :
        return GetApsExercises();

      case 'Shoulders' :
        return GetShoulderExercises();

      case 'biceps' :
        return GetBicepsExercises();

      case 'triceps' :
        return GetTricepsExercises();

      default:
        return GetLegsExercises();

    }
  }
}