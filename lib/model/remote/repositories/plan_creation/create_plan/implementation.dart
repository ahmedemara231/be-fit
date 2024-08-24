import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/model/error_handling.dart';
import 'package:be_fit/model/remote/repositories/interface.dart';
import 'package:be_fit/models/data_types/move_custom_to_plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../../models/data_types/exercises.dart';
import '../../../../../models/data_types/make_plan.dart';
import '../../../../../models/widgets/modules/toast.dart';
import '../../../../local/cache_helper/shared_prefs.dart';
import 'get_exercises/implementation.dart';

class PlanCreationRepo extends PlanCreationRepositories
{
  @override
  Future<Result<void, FirebaseError>> createNewPlan(BuildContext context,{
    required MakePlanModel makePlanModel,
  })async
  {
    MyToast.showToast(
      context,
      duration: const Duration(seconds: 2),
      msg: 'Preparing tour plan...',
      color: CacheHelper.getInstance().shared.getBool('appTheme') == false?
      Colors.grey[200]:
      HexColor('#333333'),
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
          .collection('plans')
          .add(
        {
          'name' : makePlanModel.name,
          'daysNumber' : makePlanModel.daysNumber,
        },
      ).then((planDoc)async
      {
        List<String> listsKeys = makePlanModel.lists.keys.toList();

        for(int index = 0; index <= ( makePlanModel.daysNumber! - 1 ); index++)
        {
          for(var element in makePlanModel.lists[listsKeys[index]]!)
            {
              DocumentReference planExerciseDoc = FirebaseFirestore.instance
                  .collection('users')
                  .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
                  .collection('plans')
                  .doc(planDoc.id)
                  .collection(listsKeys[index])
                  .doc(element.id); // 1st exercise in list1 in the plan

              // check if this exercise has a records or not for this user

              GetUserPlanExercises getExercises;
              if(element.isCustom == true)
              {
                getExercises = GetCustomExercise();
              }
              else{
                getExercises = GetDefaultExercise();
              }

              MoveExerciseToPlan model = MoveExerciseToPlan(
                  planExerciseDoc: planExerciseDoc.id,
                  planDoc: planDoc.id,
                  listsKeys: listsKeys, index: index,
                  element: element
              );
              await getExercises.getExercise(model);
            }
        }
      });

      return const Result.success(null);
    } on FirebaseException catch(e)
    {
      final error = ErrorHandler.getInstance().handleFireStoreError(context, e);
      return Result.error(error);
    }
  }
}
