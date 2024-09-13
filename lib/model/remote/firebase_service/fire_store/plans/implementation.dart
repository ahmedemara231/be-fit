import 'package:be_fit/model/remote/firebase_service/error_handling.dart';
import 'package:be_fit/models/data_types/finish_plan.dart';
import 'package:be_fit/models/data_types/get_plans_results.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../../models/data_types/delete_exercise_from_plan.dart';
import '../../../../../models/data_types/exercises.dart';
import '../../../../local/cache_helper/shared_prefs.dart';

class PlansRepo
{
  Map<String,dynamic> allPlans = {};
  List<String> allPlansIds = [];
  Map<String,List<Exercises>> plan = {};

  Future<Result<GetPlansResults,FirebaseError>> getAllPlans(BuildContext context)async
  {
    try{
      CollectionReference plansCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getInstance().getData('userData')[0])
          .collection('plans');

      await plansCollection
          .get()
          .then((value)async
      {
        for(int index = 0; index <= (value.docs.length - 1); index++)
        {
          allPlansIds.add(value.docs[index].id);
          plan = {};

          for(int i = 1; i <= 6; i++)
          {
            await value.docs[index].reference.collection('list$i').get()
                .then((value)
            {
              plan['list$i'] = [];
              for (var element in value.docs) {
                plan['list$i']?.add(
                  Exercises.fromJson(element),
                );
              }
            });
          }
          finishPlansForCurrentUser(
            inputs: FinishPlanInputs(
              allPlans: allPlans,
              plan: plan,
              planName: (value.docs[index].data() as Map<String,dynamic>)['name']?? 'error',
            ),
          );
        }
      });
      return Result.success(
          GetPlansResults(
              allPlans: allPlans,
              plansIds: allPlansIds
          )
      );
    }on FirebaseException catch (e)
    {
      final error = ErrorHandler.getInstance().handleFireStoreError(context, e);
      return Result.error(error);
    }
  }

  void finishPlansForCurrentUser({
    required FinishPlanInputs inputs,
  })
  {
    inputs.plan.removeWhere((key, value) => value.isEmpty);
    inputs.allPlans[inputs.planName] = inputs.plan;
  }

  Future<Result<void, FirebaseError>> deletePlan(BuildContext context,{
    required String planId,
})async
  {
    try{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
          .collection('plans')
          .doc(planId)
          .delete();
      return const Result.success(null);
    }on FirebaseException catch(e)
    {
      final error = ErrorHandler.getInstance().handleFireStoreError(context, e);
      return Result.error(error);
    }
  }

  Future<Result<void, FirebaseError>> deleteExerciseFromPlan(BuildContext context, {required DeleteFromPlanModel inputs})async
  {
    try{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getInstance().getData('userData')[0])
          .collection('plans')
          .doc(inputs.planDoc)
          .collection('list${inputs.listIndex}')
          .doc(inputs.exerciseDoc)
          .delete();

      return const Result.success(null);
    }on FirebaseException catch(e)
    {
      final error = ErrorHandler().handleFireStoreError(context, e);
      return Result.error(error);
    }
  }
}