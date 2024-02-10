import 'dart:developer';
import 'package:be_fit/constants.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/data_types/setRecord_model.dart';
import '../../models/widgets/modules/toast.dart';
import 'package:be_fit/view/statistics/statistics.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import '../../models/data_types/delete_exercise_from_plan.dart';

class PlansCubit extends Cubit<PlansStates>
{
  PlansCubit(super.initialState);
  static PlansCubit getInstance(context) => BlocProvider.of(context);

  Map<String,List<Exercises>> plan = {};
  Map<String,dynamic> allPlans = {};
  List<String> allPlansIds = [];
  List<int> days = [1,2,3,4,5,6];

  List<String> plansNames = [];
  Future<void> getAllPlans(context, String uId)async
  {
    plan = {};
    allPlans = {};
    allPlansIds = [];

    emit(GetAllPlans2LoadingState());

    try{
      CollectionReference plansCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('plans');

      await plansCollection
          .get()
          .then((value)async
      {
        for(int index = 0; index <= (value.docs.length - 1); index++)
        {
          allPlansIds.add(value.docs[index].id);
          log('all plans ids : $allPlansIds');

          plan = {};
          log(value.docs[index].id);
          for(int i = 1; i <= days.length; i++)
          {       // plan1
            await value.docs[index].reference.collection('list$i').get()
                .then((value)
            {
              plan['list$i'] = [];
              value.docs.forEach((element) {
                plan['list$i']?.add(
                  Exercises(
                    name: element.data()['name'],
                    image: element.data()['image'],
                    docs: element.data()['docs'],
                    id: element.id,
                    muscleName: element.data()['muscle'],
                    isCustom: element.data()['isCustom'],
                    video: element.data()['video'],
                    reps: element.data()['reps'],
                    sets: element.data()['sets'],
                  ),
                );
              });
            });
          } // plan is ready to join allPlans
          finishPlansForCurrentUser(
            index,
            (value.docs[index].data() as Map<String,dynamic>)['name'],
          );
        }
        plansNames = getAllKeys();
        emit(GetAllPlans2SuccessState());
      });
    }on Exception catch (e)
    {
      emit(GetAllPlans2ErrorState());
      MyMethods.handleError(context, e);
    }
  }

  void finishPlansForCurrentUser(int index,String planName)
  {
    plan.removeWhere((key, value) => value.isEmpty);

    allPlans[planName] = plan;
  }

  List<String> getAllKeys()
  {
    List<String> allKeys = allPlans.keys.toList();

    log('all Keys : $allKeys');
    return allKeys;
  }

  Future<void> deletePlan(context,{
    required int index,
    required String uId,
    required String planName,
  })async
  {
    try{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('plans')
          .doc(allPlansIds[index])
          .delete()
          .then((value)
      {
        allPlans.remove(planName);
        allPlansIds.remove(allPlansIds[index]);
        emit(DeletePlanSuccessState());
      });
    }on Exception catch(e)
    {
      emit(DeletePlanErrorState());
      MyMethods.handleError(context, e);
    }
  }

  Future<void> deleteExerciseFromPlan(context,{
    required DeleteFromPlanModel deleteFromPlanModel,
  })async
  {
    try{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(deleteFromPlanModel.uId)
          .collection('plans')
          .doc(deleteFromPlanModel.planDoc)
          .collection('list${deleteFromPlanModel.listIndex}')
          .doc(deleteFromPlanModel.exerciseDoc)
          .delete()
          .then((value)
      {
        (allPlans[deleteFromPlanModel.planName]['list${deleteFromPlanModel.listIndex}'] as List).removeAt(deleteFromPlanModel.exerciseIndex);
        emit(DeleteExerciseFromPlanSuccessState());
      });
    }on Exception catch(e)
    {
      emit(DeleteExerciseFromPlanErrorState());
      MyMethods.handleError(context, e);
    }
  }

  Future<void> setARecordFromPlan({
    required SetRecordForPlanExercise planExerciseRecord,
    required context,
    String? muscleName,
  })async
  {
    double? reps = double.tryParse(planExerciseRecord.reps);
    double? weight = double.tryParse(planExerciseRecord.weight);

    List<int> days = [1,2,3,4,5,6];

    try {
      if(planExerciseRecord.exercise.isCustom == true)
        {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(planExerciseRecord.uId)
              .collection('customExercises')
              .doc(planExerciseRecord.exercise.id)
              .collection('records')
              .add({
            'weight' : weight,
            'reps' : reps,
            'dateTime' : Jiffy().yMMM,
          }).then((firstPublish)
          {
            FirebaseFirestore.instance
                .collection('users')
                .doc(planExerciseRecord.uId)
                .collection('plans')
                .get()
                .then((value)
            {                  // each plans
              value.docs.forEach((element) async{
                for(int i = 1; i <= days.length; i++)
                {
                  var myExercise = await element.reference
                      .collection('list$i')
                      .doc(planExerciseRecord.exercise.id)
                      .get();
                  if(myExercise.exists)
                    {
                      element.reference.collection('list$i')
                          .doc(planExerciseRecord.exercise.id)
                          .collection('records')
                          .doc(firstPublish.id)
                          .set(
                          {
                            'weight' : weight,
                            'reps' : reps,
                            'dateTime' : Jiffy().yMMM,
                            'uId' : planExerciseRecord.uId,
                          },
                      );
                    }
                  else{
                    log(' not exists');
                    return;
                  }
                }
              });
            });
          });
        }
      else{
        await FirebaseFirestore.instance
            .collection(muscleName!)
            .doc(planExerciseRecord.exercise.id)
            .collection('records')
            .add(
          {
            'weight' : weight,
            'reps' : reps,
            'dateTime' : Jiffy().yMMM,
            'uId' : planExerciseRecord.uId,
          },
        ).then((firstPublish)async
        {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(planExerciseRecord.uId)
              .collection('plans')
              .get()
              .then((value)
          {

            value.docs.forEach((element) async {
              for(int i = 1; i <= days.length; i++)
              {                               // plan 1
                QuerySnapshot planList = await element.reference
                    .collection('list$i')
                    .get();
                if(planList.docs.isNotEmpty)
                {
                  await element.reference
                      .collection('list$i')
                      .doc(planExerciseRecord.exercise.id)
                      .get().then((value)
                  {
                    if(value.exists)
                    {
                      element.reference
                          .collection('list$i')
                          .doc(planExerciseRecord.exercise.id)
                          .collection('records')
                          .doc(firstPublish.id)
                          .set(
                        {
                          'weight' : weight,
                          'reps' : reps,
                          'dateTime' : Jiffy().yMMM,
                          'uId' : planExerciseRecord.uId,
                        },
                      );
                    }
                    else{
                      return;
                    }
                  });

                }
                else{
                  return;
                }
              }
            });
          });
          MyToast.showToast(context, msg: 'Record added');
        });
      }

    }on Exception catch(e)
    {
      MyMethods.handleError(context, e);
    }
  }

  List<MyRecord> records = [];
  Future<void> pickRecordsToMakeChart(context,{
    required String uId,
    required String planDoc,
    required int listIndex,
    required String exerciseId,
  })async
  {
    records = [];
    emit(MakeChartForExerciseInPlanLoadingState());
    try{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('plans')
          .doc(planDoc)
          .collection('list$listIndex')
          .doc(exerciseId)
          .collection('records')
          .get()
          .then((value)
      {
        value.docs.forEach((element) {
          records.add(
              MyRecord(
                reps: element.data()['reps'],
                weight: element.data()['weight'],
              )
          );
        });
        emit(MakeChartForExerciseInPlanSuccessState());
      });
    }on Exception catch(e)
    {
      MyMethods.handleError(context, e);
    }
  }
}