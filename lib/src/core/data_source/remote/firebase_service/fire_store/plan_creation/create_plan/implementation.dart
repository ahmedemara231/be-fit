import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/error_handling/handling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../../features/create_plan/data/data_source/models/make_plan.dart';
import '../../../../../../../features/exercises/data/data_source/models/move_custom_to_plan.dart';
import '../../../../../local/cache_helper/shared_prefs.dart';
import '../../interface.dart';

class PlanCreationImpl implements PlanCreationInterface
{
  @override
  Future<String> createNewPlan(MakePlanModel makePlanModel)async
  {
    try {
      final response = await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
          .collection('plans')
          .add(
        {
          'name' : makePlanModel.name,
          'daysNumber' : makePlanModel.daysNumber,
        },
      );

      List<String> listsKeys = makePlanModel.lists.keys.toList();

      for(int index = 0; index <= ( makePlanModel.daysNumber! - 1 ); index++)
      {
        for(var element in makePlanModel.lists[listsKeys[index]]!)
        {
          DocumentReference planExerciseDoc = FirebaseFirestore.instance
              .collection('users')
              .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
              .collection('plans')
              .doc(response.id)
              .collection(listsKeys[index])
              .doc(element.id); // 1st exercise in list1 in the plan

          MoveExerciseToPlan model = MoveExerciseToPlan(
              planExerciseDoc: planExerciseDoc.id,
              planDoc: response.id,
              listsKeys: listsKeys, index: index,
              element: element
          );
          moveExerciseToPlan(model);
        }
      }

      return 'your plan is ready!';
    } on FirebaseException catch(e)
    {
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }
  }

  Future<void> moveExerciseToPlan(MoveExerciseToPlan model) async{
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
