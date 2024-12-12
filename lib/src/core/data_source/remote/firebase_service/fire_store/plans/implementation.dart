import 'package:be_fit/src/core/data_source/remote/firebase_service/fire_store/error_handling/handling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../features/plans/data/data_source/models/add_to_existing_plan.dart';
import '../../../../../../features/plans/data/data_source/models/delete_exercise_from_plan.dart';
import '../../../../../../features/plans/data/data_source/models/finish_plan.dart';
import '../../../../../../features/plans/data/data_source/models/get_plans_results.dart';
import '../../../../../helpers/global_data_types/exercises.dart';
import '../../../../local/cache_helper/shared_prefs.dart';
import '../interface.dart';

class PlansImpl implements PlansInterface
{
  Map<String,dynamic> allPlans = {};
  List<String> allPlansIds = [];
  Map<String,List<Exercises>> plan = {};

  @override
  Future<GetPlansResults> getAllPlans()async
  {
    try{
      allPlans = {};
      allPlansIds = [];

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
      return GetPlansResults(
          allPlans: allPlans,
          plansIds: allPlansIds
      );
    }on FirebaseException catch (e)
    {
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }
  }

  void finishPlansForCurrentUser({
    required FinishPlanInputs inputs,
  })
  {
    inputs.plan.removeWhere((key, value) => value.isEmpty);
    inputs.allPlans[inputs.planName] = inputs.plan;
  }

  @override
  Future<String> deletePlan(String planId)async
  {
    try{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
          .collection('plans')
          .doc(planId)
          .delete();

      return '';
    }on FirebaseException catch(e)
    {
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }
  }

  @override
  Future<String> deleteExerciseFromPlan(DeleteFromPlanModel inputs)async
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

      return '';
    }on FirebaseException catch(e)
    {
      final error = StoreErrorHandler().handle(e);
      throw error;
    }
  }

  @override
  Future<String> addExerciseToExistingPlan(AddExerciseToExistingPlanModel model)async
  {
    try{
      for(var exercise in model.exercises)
        {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
              .collection('plans')
              .doc(model.planId)
              .collection(model.list)
              .doc(exercise.id)
              .set(exercise.toJson());
        }
      return '';
    }on FirebaseException catch(e)
    {
      final error = StoreErrorHandler.getInstance().handle(e);
      throw error;
    }
  }
}