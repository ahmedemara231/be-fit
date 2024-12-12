import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../../features/create_plan/data/data_source/models/muscles_and_checkbox.dart';
import '../../../../../../helpers/global_data_types/exercises.dart';
import '../../../../../local/cache_helper/shared_prefs.dart';
import '../../interface.dart';

class GetChestExercises implements GetExercisesForEachMuscleToMakePlanInterface
{
  @override
  Future<ExercisesAndCheckBox> getExercise(String muscleName) async{
    List<Exercises> chestExercises = [];
    List<bool> checkBox = [];

    final response = await FirebaseFirestore.instance
        .collection(muscleName)
        .get();
    for (var element in response.docs) {
      chestExercises.add(Exercises.fromJson(element));
      checkBox.add(false);

      if(element.data()['name'] == 'Chest press machine')
      {
        final getCustomChestExercisesResponse = await FirebaseFirestore.instance
            .collection('users')
            .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
            .collection('customExercises')
            .where('muscle', isEqualTo: muscleName)
            .get();

        for (var element in getCustomChestExercisesResponse.docs) {
          chestExercises.add(CustomExercises.fromJson(element));
          checkBox.add(false);
        }
      }
    }

    ExercisesAndCheckBox result = ExercisesAndCheckBox(
        exercises: chestExercises,
        checkBox: checkBox
    );
    return result;
  }
}

class GetBackExercises implements GetExercisesForEachMuscleToMakePlanInterface
{
  @override
  Future<ExercisesAndCheckBox> getExercise(String muscleName)async {
    List<Exercises> backExercises = [];
    List<bool> checkBox = [];

    final response = await FirebaseFirestore.instance
        .collection(muscleName)
        .get();

    for (var element in response.docs) {
      backExercises.add(Exercises.fromJson(element));
      checkBox.add(false);

      if(element.data()['name'] == 'Lat pull down')
      {
        final getCustomBackExercisesResponse = await FirebaseFirestore.instance
            .collection('users')
            .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
            .collection('customExercises')
            .where('muscle', isEqualTo: muscleName)
            .get();
        for (var element in getCustomBackExercisesResponse.docs) {
          backExercises.add(CustomExercises.fromJson(element));
          checkBox.add(false);
        }
      }
    }

    ExercisesAndCheckBox result = ExercisesAndCheckBox(
        exercises: backExercises,
        checkBox: checkBox
    );

    return result;
  }

}

class GetApsExercises implements GetExercisesForEachMuscleToMakePlanInterface
{
  @override
  Future<ExercisesAndCheckBox> getExercise(String muscleName) async{
    List<Exercises> apsExercises = [];
    List<bool> checkBox = [];

    final response = await FirebaseFirestore.instance
        .collection(muscleName)
        .get();
    for (var element in response.docs) {
      apsExercises.add(Exercises.fromJson(element));
      checkBox.add(false);

      if(element.data()['name'] == 'Crunches')
      {
        final getCustomApsExercisesResponse = await FirebaseFirestore.instance
            .collection('users')
            .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
            .collection('customExercises')
            .where('muscle', isEqualTo: muscleName)
            .get();
        for (var element in getCustomApsExercisesResponse.docs) {
          apsExercises.add(CustomExercises.fromJson(element));
          checkBox.add(false);
        }
      }
    }

    ExercisesAndCheckBox result = ExercisesAndCheckBox(
        exercises: apsExercises,
        checkBox: checkBox
    );
    return result;
  }
}

class GetShoulderExercises implements GetExercisesForEachMuscleToMakePlanInterface
{
  @override
  Future<ExercisesAndCheckBox> getExercise(String muscleName) async{
    List<Exercises> shoulderExercises = [];
    List<bool> checkBox = [];

    final response = await FirebaseFirestore.instance
        .collection(muscleName)
        .get();
    for (var element in response.docs) {
      shoulderExercises.add(Exercises.fromJson(element));
      checkBox.add(false);

      if(element.data()['name'] == 'Dumbbell Lateral Raises')
      {
        final customShoulderExercisesResponse = await FirebaseFirestore.instance
            .collection('users')
            .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
            .collection('customExercises')
            .where('muscle', isEqualTo: muscleName)
            .get();
        for (var element in customShoulderExercisesResponse.docs) {
          shoulderExercises.add(CustomExercises.fromJson(element));
          checkBox.add(false);
        }

      }
    }

    ExercisesAndCheckBox result = ExercisesAndCheckBox(
        exercises: shoulderExercises,
        checkBox: checkBox
    );
    return result;
  }
}

class GetBicepsExercises implements GetExercisesForEachMuscleToMakePlanInterface
{
  @override
  Future<ExercisesAndCheckBox> getExercise(String muscleName) async{
    List<Exercises> bicepsExercises = [];
    List<bool> checkBox = [];

    final response = await FirebaseFirestore.instance
        .collection(muscleName)
        .get();
    for (var element in response.docs) {
      bicepsExercises.add(Exercises.fromJson(element));
      checkBox.add(false);

      if(element.data()['name'] == 'barbell curls')
      {
        final customBicepsExercisesResponse = await FirebaseFirestore.instance
            .collection('users')
            .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
            .collection('customExercises')
            .where('muscle', isEqualTo: muscleName)
            .get();
        for (var element in customBicepsExercisesResponse.docs) {
          bicepsExercises.add(CustomExercises.fromJson(element));
          checkBox.add(false);
        }

      }
    }

    ExercisesAndCheckBox result = ExercisesAndCheckBox(
        exercises: bicepsExercises,
        checkBox: checkBox
    );
    return result;
  }
}

class GetTricepsExercises implements GetExercisesForEachMuscleToMakePlanInterface
{
  @override
  Future<ExercisesAndCheckBox> getExercise(String muscleName) async{
    List<Exercises> tricepsExercises = [];
    List<bool> checkBox = [];

    final response = await FirebaseFirestore.instance
        .collection(muscleName)
        .get();
    for (var element in response.docs) {
      tricepsExercises.add(Exercises.fromJson(element));
      checkBox.add(false);

      if(element.data()['name'] == 'Bumbell kick back')
      {
        final customTricepsExercisesResponse = await FirebaseFirestore.instance
            .collection('users')
            .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
            .collection('customExercises')
            .where('muscle', isEqualTo: muscleName)
            .get();
        for (var element in customTricepsExercisesResponse.docs) {
          tricepsExercises.add(CustomExercises.fromJson(element));
          checkBox.add(false);
        }

      }
    }

    ExercisesAndCheckBox result = ExercisesAndCheckBox(
        exercises: tricepsExercises,
        checkBox: checkBox
    );
    return result;
  }
}

class GetLegsExercises implements GetExercisesForEachMuscleToMakePlanInterface
{
  @override
  Future<ExercisesAndCheckBox> getExercise(String muscleName) async{
    List<Exercises> legsExercises = [];
    List<bool> checkBox = [];

    final response = await FirebaseFirestore.instance
        .collection(muscleName)
        .get();
    for (var element in response.docs) {

      legsExercises.add(Exercises.fromJson(element));
      checkBox.add(false);

      if(element.data()['name'] == 'Leg press')
      {
        final customLegsExercisesResponse = await FirebaseFirestore.instance
            .collection('users')
            .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
            .collection('customExercises')
            .where('muscle', isEqualTo: muscleName)
            .get();
        for (var element in customLegsExercisesResponse.docs) {
          legsExercises.add(CustomExercises.fromJson(element));
          checkBox.add(false);
        }

      }
    }

    ExercisesAndCheckBox result = ExercisesAndCheckBox(
        exercises: legsExercises,
        checkBox: checkBox
    );
    return result;
  }
}