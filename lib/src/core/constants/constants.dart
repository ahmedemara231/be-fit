import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiffy/jiffy.dart';

import '../helpers/app_widgets/exercise_model.dart';

class Constants
{
  static var appColor = HexColor('#D84D4D');

  static final List<String> muscles =
  [
    'Aps',
    'chest',
    'Back',
    'biceps',
    'triceps',
    'Shoulders',
    'legs'
  ];


  static void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false
      ..maskType = EasyLoadingMaskType.black;
  }

  static List<ExerciseModel> musclesList = [
    ExerciseModel(imageUrl: 'aps', text: 'Aps',numberOfExercises: 2),
    ExerciseModel(imageUrl: 'back', text: 'Back',numberOfExercises: 7),
    ExerciseModel(imageUrl: 'chest', text: 'chest',numberOfExercises: 9),
    ExerciseModel(imageUrl: 'biceps', text: 'biceps',numberOfExercises: 5),
    ExerciseModel(imageUrl: 'triceps', text: 'triceps',numberOfExercises: 5),
    ExerciseModel(imageUrl: 'Legs', text: 'legs',numberOfExercises: 5),
    ExerciseModel(imageUrl: 'shoulders', text: 'Shoulders',numberOfExercises: 5),
  ];

  //date time
  static String dataTime = Jiffy().yMMMd;
  static String defaultExercisesImpl = 'defaultExercises';
  static String customExercisesImpl = 'customExercises';
}