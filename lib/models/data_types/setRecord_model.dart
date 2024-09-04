import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import '../../model/local/cache_helper/shared_prefs.dart';
import 'controllers.dart';

class SetRecModel
{
  String muscleName;
  String exerciseId;
  Controllers controllers;
  String dateTime = Constants.dataTime;

  SetRecModel({
    required this.muscleName,
    required this.exerciseId,
    required this.controllers,
  });

  Map<String,dynamic> toJson()
  {
    return {
      'weight' : controllers.weight,
      'reps' : controllers.reps,
      'dateTime' : dateTime,
      'uId' : CacheHelper.getInstance().shared.getStringList('userData')![0],
    };
  }
}