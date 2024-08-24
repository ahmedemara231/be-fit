import 'package:be_fit/model/remote/repositories/interface.dart';
import 'package:be_fit/models/data_types/move_custom_to_plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../constants/constants.dart';
import '../../../../../../models/data_types/get_records_to_plan.dart';
import '../../../../../local/cache_helper/shared_prefs.dart';

class GetDefaultExercise extends GetUserPlanExercises
{
  @override
  Future<void> getExercise(MoveExerciseToPlan model) async{
    for(int i = 0; i <= (Constants.muscles.length - 1); i++)
    {
      final checkCollection = await FirebaseFirestore.instance
          .collection(Constants.muscles[i])
          .doc(model.element.id)
          .collection('records')
          .where('uId',isEqualTo: CacheHelper.getInstance().shared.getStringList('userData')?[0])
          .get();

      if(checkCollection.docs.isNotEmpty)
      {
        DocumentReference exerciseDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
            .collection('plans')
            .doc(model.planDoc)
            .collection(model.listsKeys[model.index])
            .doc(model.planExerciseDoc);

        await exerciseDoc.set(model.element.toJson());

        for (var element in checkCollection.docs)
        {
          GetRecordToPlan model = GetRecordToPlan(
              weight: element.data()['weight'],
              reps: element.data()['reps'],
              dateTime: element.data()['dateTime']
          );

          await exerciseDoc.collection('records')
              .doc(element.id)
              .set(model.toJson());
        }
      }
      else{
        await FirebaseFirestore.instance
            .collection('users')
            .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
            .collection('plans')
            .doc(model.planDoc)
            .collection(model.listsKeys[model.index])
            .doc(model.planExerciseDoc)
            .set(model.element.toJson());
      }
    }
  }
}

class GetCustomExercise extends GetUserPlanExercises
{
  @override
  Future<void> getExercise(MoveExerciseToPlan model) async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
        .collection('customExercises')
        .doc(model.planExerciseDoc)
        .collection('records')
        .get()
        .then((value)async
    {
      if(value.docs.isNotEmpty)
      {
        DocumentReference<Map<String, dynamic>> planExercise = FirebaseFirestore.instance
            .collection('users')
            .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
            .collection('plans')
            .doc(model.planDoc)
            .collection(model.listsKeys[model.index])
            .doc(model.planExerciseDoc);

        await planExercise.set(model.element.toJson());

        for (var element in value.docs)
        {
          GetRecordToPlan model = GetRecordToPlan(
              weight: element.data()['weight'],
              reps: element.data()['reps'],
              dateTime: element.data()['dateTime']
          );

          await planExercise.collection('records')
              .doc(element.id)
              .set(model.toJson());
        }
      }
      else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
            .collection('plans')
            .doc(model.planDoc)
            .collection(model.listsKeys[model.index])
            .doc(model.planExerciseDoc)
            .set(model.element.toJson());
      }
    });
  }
}
