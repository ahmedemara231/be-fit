import 'package:be_fit/models/data_types/exercises.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../models/data_types/muscles_and_checkbox.dart';
import '../../../../../local/cache_helper/shared_prefs.dart';
import '../../interface.dart';

class GetChestExercises extends GetUserExercises
{
  @override
  Future<ExercisesAndCheckBox> getExercise(String muscleName) async{
    List<Exercises> chestExercises = [];
    List<bool> checkBox = [];

    await FirebaseFirestore.instance
        .collection(muscleName)
        .get().then((value)async
    {
      for (var element in value.docs) {
        chestExercises.add(Exercises.fromJson(element));
        checkBox.add(false);

        if(element.data()['name'] == 'Chest press machine')
        {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
              .collection('customExercises')
              .where('muscle', isEqualTo: muscleName)
              .get()
              .then((value)
          {
            for (var element in value.docs) {
              chestExercises.add(CustomExercises.fromJson(element));
              checkBox.add(false);
            }
          });
        }
      }
    });
    ExercisesAndCheckBox result = ExercisesAndCheckBox(
        exercises: chestExercises,
        checkBox: checkBox
    );
    return result;
  }
}

class GetBackExercises extends GetUserExercises
{
  @override
  Future<ExercisesAndCheckBox> getExercise(String muscleName)async {
    List<Exercises> backExercises = [];
    List<bool> checkBox = [];

    await FirebaseFirestore.instance
        .collection(muscleName)
        .get().then((value)async
    {
      for (var element in value.docs) {
        backExercises.add(Exercises.fromJson(element));
        checkBox.add(false);

        if(element.data()['name'] == 'Lat pull down')
        {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
              .collection('customExercises')
              .where('muscle', isEqualTo: muscleName)
              .get()
              .then((value)
          {
            for (var element in value.docs) {
              backExercises.add(CustomExercises.fromJson(element));
              checkBox.add(false);
            }
          });
        }
      }
    });
    ExercisesAndCheckBox result = ExercisesAndCheckBox(
        exercises: backExercises,
        checkBox: checkBox
    );

    return result;
  }

}

class GetApsExercises extends GetUserExercises
{
  @override
  Future<ExercisesAndCheckBox> getExercise(String muscleName) async{
    List<Exercises> apsExercises = [];
    List<bool> checkBox = [];

    await FirebaseFirestore.instance
        .collection(muscleName)
        .get().then((value)async
    {
      for (var element in value.docs) {
        apsExercises.add(Exercises.fromJson(element));
        checkBox.add(false);

        if(element.data()['name'] == 'Crunches')
        {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
              .collection('customExercises')
              .where('muscle', isEqualTo: muscleName)
              .get()
              .then((value)
          {
            for (var element in value.docs) {
              apsExercises.add(CustomExercises.fromJson(element));
              checkBox.add(false);
            }
          });
        }
      }
    });
    ExercisesAndCheckBox result = ExercisesAndCheckBox(
        exercises: apsExercises,
        checkBox: checkBox
    );
    return result;
  }
}

class GetShoulderExercises extends GetUserExercises
{
  @override
  Future<ExercisesAndCheckBox> getExercise(String muscleName) async{
    List<Exercises> shoulderExercises = [];
    List<bool> checkBox = [];
    
    await FirebaseFirestore.instance
        .collection(muscleName)
        .get().then((value)async
    {
      for (var element in value.docs) {
        shoulderExercises.add(Exercises.fromJson(element));
        checkBox.add(false);

        if(element.data()['name'] == 'Dumbbell Lateral Raises')
        {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
              .collection('customExercises')
              .where('muscle', isEqualTo: muscleName)
              .get()
              .then((value)
          {
            for (var element in value.docs) {
              shoulderExercises.add(CustomExercises.fromJson(element));
              checkBox.add(false);
            }
          });
        }
      }
    });
    ExercisesAndCheckBox result = ExercisesAndCheckBox(
        exercises: shoulderExercises,
        checkBox: checkBox
    );
    return result;
  }
}

class GetBicepsExercises extends GetUserExercises
{
  @override
  Future<ExercisesAndCheckBox> getExercise(String muscleName) async{
    List<Exercises> bicepsExercises = [];
    List<bool> checkBox = [];

    await FirebaseFirestore.instance
        .collection(muscleName)
        .get().then((value)async
    {
      for (var element in value.docs) {
        bicepsExercises.add(Exercises.fromJson(element));
        checkBox.add(false);

        if(element.data()['name'] == 'barbell curls')
        {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
              .collection('customExercises')
              .where('muscle', isEqualTo: muscleName)
              .get()
              .then((value)
          {
            for (var element in value.docs) {
              bicepsExercises.add(CustomExercises.fromJson(element));
              checkBox.add(false);
            }
          });
        }
      }
    });
    ExercisesAndCheckBox result = ExercisesAndCheckBox(
        exercises: bicepsExercises,
        checkBox: checkBox
    );
    return result;
  }
}

class GetTricepsExercises extends GetUserExercises
{
  @override
  Future<ExercisesAndCheckBox> getExercise(String muscleName) async{
    List<Exercises> tricepsExercises = [];
    List<bool> checkBox = [];

    await FirebaseFirestore.instance
        .collection(muscleName)
        .get().then((value)async
    {
      for (var element in value.docs) {
        tricepsExercises.add(Exercises.fromJson(element));
        checkBox.add(false);

        if(element.data()['name'] == 'Bumbell kick back')
        {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
              .collection('customExercises')
              .where('muscle', isEqualTo: muscleName)
              .get()
              .then((value)
          {
            for (var element in value.docs) {
              tricepsExercises.add(CustomExercises.fromJson(element));
              checkBox.add(false);
            }
          });
        }
      }
    });
    ExercisesAndCheckBox result = ExercisesAndCheckBox(
        exercises: tricepsExercises,
        checkBox: checkBox
    );
    return result;
  }
}

class GetLegsExercises extends GetUserExercises
{
  @override
  Future<ExercisesAndCheckBox> getExercise(String muscleName) async{
    List<Exercises> legsExercises = [];
    List<bool> checkBox = [];

    await FirebaseFirestore.instance
        .collection(muscleName)
        .get().then((value)async
    {
      for (var element in value.docs) {
        legsExercises.add(Exercises(
          name: element.data()['name'],
          image: element.data()['image'],
          docs: element.data()['docs'],
          id: element.id,
          muscleName: element.data()['muscle'],
          isCustom: element.data()['isCustom'],
          video: element.data()['video'],
          reps: element.data()['reps']??'10',
          sets: element.data()['sets']??'3',
        ));
        checkBox.add(false);

        if(element.data()['name'] == 'Leg press')
        {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
              .collection('customExercises')
              .where('muscle', isEqualTo: muscleName)
              .get()
              .then((value)
          {
            for (var element in value.docs) {
              legsExercises.add(CustomExercises.fromJson(element));
              checkBox.add(false);
            }
          });
        }
      }
    });
    ExercisesAndCheckBox result = ExercisesAndCheckBox(
        exercises: legsExercises,
        checkBox: checkBox
    );
    return result;
  }
}