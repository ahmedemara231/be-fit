import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/data_source/local/cache_helper/shared_prefs.dart';

class GetMuscleExercise
{
  QueryDocumentSnapshot<Map<String, dynamic>> element;
  int i;
  String uId = CacheHelper.getInstance().shared.getStringList('userData')![0];

  GetMuscleExercise({
    required this.element,
    required this.i,
});
}