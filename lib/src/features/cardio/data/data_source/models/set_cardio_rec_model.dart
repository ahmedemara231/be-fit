import '../../../../../core/data_source/local/cache_helper/shared_prefs.dart';
import 'cardio_records.dart';

class SetCardioRecModel
{
  String exerciseId;
  CardioRecords inputs;

  SetCardioRecModel({
    required this.exerciseId,
    required this.inputs,
});

  Map<String,dynamic> toJson()
  {
    return
      {
        'dateTime' : inputs.dateTime,
        'time' : inputs.time,
        'uId' : CacheHelper.getInstance().shared.getStringList('userData')?[0]
      };
  }
}