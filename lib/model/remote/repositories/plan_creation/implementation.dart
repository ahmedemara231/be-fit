import 'package:be_fit/model/error_handling.dart';
import 'package:be_fit/model/remote/repositories/plan_creation/get_exercises/implementation.dart';
import 'package:be_fit/model/remote/repositories/plan_creation/get_exercises/interface.dart';
import 'package:be_fit/models/data_types/move_custom_to_plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../models/data_types/exercises.dart';
import '../../../../models/data_types/make_plan.dart';
import '../../../../models/widgets/modules/toast.dart';
import '../../../local/cache_helper/shared_prefs.dart';

class PlanCreationRepo
{
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

              GetExercises getExercises;
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


















  // Future<Result<void, NewFirebaseError>> createNewPlan(BuildContext context,{
  //   required MakePlanModel makePlanModel,
  // })async
  // {
  //   MyToast.showToast(
  //     context,
  //     msg: 'Preparing tour plan...',
  //     color: CacheHelper.getInstance().shared.getBool('appTheme') == false?
  //     Colors.grey[200]:
  //     HexColor('#333333'),
  //   );
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
  //         .collection('plans')
  //         .add(
  //       {
  //         'name' : makePlanModel.name,
  //         'daysNumber' : makePlanModel.daysNumber,
  //       },
  //     ).then((planDoc)
  //     {
  //       List<String> listsKeys = makePlanModel.lists.keys.toList();
  //
  //       for(int index = 0; index <= ( makePlanModel.daysNumber! - 1 ); index++)
  //       {
  //         // list1
  //         makePlanModel.lists[listsKeys[index]]!.forEach((element)async {
  //
  //           DocumentReference planExerciseDoc = FirebaseFirestore.instance
  //               .collection('users')
  //               .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
  //               .collection('plans')
  //               .doc(planDoc.id)
  //               .collection(listsKeys[index])
  //               .doc(element.id); // 1st exercise in list1 in the plan
  //
  //           // check if this exercise has a records or not for this user
  //
  //           if(element.isCustom == true)
  //           {
  //             await FirebaseFirestore.instance
  //                 .collection('users')
  //                 .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
  //                 .collection('customExercises')
  //                 .doc(planExerciseDoc.id)
  //                 .collection('records')
  //                 .get()
  //                 .then((value)async
  //             {
  //               if(value.docs.isNotEmpty)
  //               {
  //                 DocumentReference<Map<String, dynamic>> planExercise = FirebaseFirestore.instance
  //                     .collection('users')
  //                     .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
  //                     .collection('plans')
  //                     .doc(planDoc.id)
  //                     .collection(listsKeys[index])
  //                     .doc(planExerciseDoc.id);
  //
  //                 await planExercise.set(element.toJson());
  //
  //                 for (var element in value.docs)
  //                   {
  //                     GetRecordToPlan model = GetRecordToPlan(
  //                         weight: element.data()['weight'],
  //                         reps: element.data()['reps'],
  //                         dateTime: element.data()['dateTime']
  //                     );
  //
  //                     await planExercise.collection('records')
  //                         .doc(element.id)
  //                         .set(model.toJson());
  //                   }
  //               }
  //               else {
  //                 await FirebaseFirestore.instance
  //                     .collection('users')
  //                     .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
  //                     .collection('plans')
  //                     .doc(planDoc.id)
  //                     .collection(listsKeys[index])
  //                     .doc(planExerciseDoc.id)
  //                     .set(element.toJson());
  //               }
  //             });
  //           }
  //           else{
  //             for(int i = 0; i <= (Constants.muscles.length - 1); i++)
  //             {
  //               var checkCollection = await FirebaseFirestore.instance
  //                   .collection(Constants.muscles[i])
  //                   .doc(element.id)
  //                   .collection('records')
  //                   .where('uId',isEqualTo: CacheHelper.getInstance().shared.getStringList('userData')?[0])
  //                   .get();
  //
  //               if(checkCollection.docs.isNotEmpty)
  //               {
  //                 DocumentReference exerciseDoc = FirebaseFirestore.instance
  //                     .collection('users')
  //                     .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
  //                     .collection('plans')
  //                     .doc(planDoc.id)
  //                     .collection(listsKeys[index])
  //                     .doc(planExerciseDoc.id);
  //
  //                 await exerciseDoc.set(element.toJson());
  //
  //                 for (var element in checkCollection.docs)
  //                 {
  //                   GetRecordToPlan model = GetRecordToPlan(
  //                       weight: element.data()['weight'],
  //                       reps: element.data()['reps'],
  //                       dateTime: element.data()['dateTime']
  //                   );
  //
  //                   await exerciseDoc.collection('records')
  //                       .doc(element.id)
  //                       .set(model.toJson());
  //                 }
  //               }
  //               else{
  //                 await FirebaseFirestore.instance
  //                     .collection('users')
  //                     .doc(CacheHelper.getInstance().shared.getStringList('userData')?[0])
  //                     .collection('plans')
  //                     .doc(planDoc.id)
  //                     .collection(listsKeys[index])
  //                     .doc(planExerciseDoc.id)
  //                     .set(element.toJson());
  //               }
  //             }
  //           }
  //         });
  //       }
  //       MyToast.showToast(
  //         context,
  //         msg: 'Plan is Ready',
  //         color: Colors.green,
  //       );
  //       context.removeOldRoute(BottomNavBar());
  //
  //     });
  //
  //     return const Result.success(null);
  //   } on FirebaseException catch(e)
  //   {
  //     final error = ErrorHandler.getInstance().handleFireStoreError(context, e);
  //     return Result.error(error);
  //   }
  // }















  Map<String, List<Exercises>> musclesAndItsExercises = {};
  Map<String, List<bool>> muscleExercisesCheckBox = {};

  // /*
  // * static final List<String> muscles =
  // [
  //   'Aps',
  //   'chest',
  //   'Back',
  //   'biceps',
  //   'triceps',
  //   'Shoulders',
  //   'legs'
  // ];*/

  // List<GetMuscles> muscles = [GetChest()];

  // void open()
  // {
  //   for(int i = 0; i < muscles.length; i++)
  //   {
  //     musclesAndItsExercises[Constants.muscles[i]] = [];
  //     muscleExercisesCheckBox[Constants.muscles[i]] = [];
  //   }
  // }

  // Future<void> getMuscles()async
  // {
  //   open();
  //
  //   late GetMuscles muscle;
  //   for(int i = 0; i < muscles.length; i++)
  //   {
  //     await FirebaseFirestore.instance
  //         .collection(Constants.muscles[i]) // chest
  //         .get().then((value) async{
  //           muscle = muscles[i];
  //           for (var element in value.docs) {
  //             GetMuscleExercise model = GetMuscleExercise(element: element, i: i);
  //
  //             final GetMuscleResult result = await muscle.getMuscle(model);
  //             musclesAndItsExercises[Constants.muscles[i]] = result.muscleExercises;
  //             muscleExercisesCheckBox[Constants.muscles[i]] = result.muscleCheckBox;
  //
  //           }
  //     });
  //   }
  // }

}