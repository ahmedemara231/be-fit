import 'dart:async';
import 'dart:developer';
import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/model/remote/firebase_service/fireStore_service/implementation.dart';
import 'package:be_fit/model/remote/firebase_service/fireStore_service/interface.dart';
import 'package:be_fit/model/remote/repositories/interface.dart';
import 'package:be_fit/model/remote/repositories/plans/implementation.dart';
import 'package:be_fit/models/data_types/pick_records_plan.dart';
import 'package:be_fit/models/data_types/setRecord_model.dart';
import 'package:be_fit/models/widgets/modules/snackBar.dart';
import '../../models/widgets/modules/toast.dart';
import 'package:be_fit/view/statistics/statistics.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/data_types/delete_exercise_from_plan.dart';

class PlansCubit extends Cubit<PlansStates>
{
  PlansCubit(super.initialState);
  static PlansCubit getInstance(context) => BlocProvider.of(context);

  final FireStoreService service = FireStoreCall();

  Map<String,dynamic> allPlans = {};
  List<String> allPlansIds = [];

  PlansRepo repo = PlansRepo();

  Future<void> getAllPlans(context, String uId)async
  {
    emit(GetAllPlansLoadingState());

    final result = await repo.getAllPlans(context, uId);
    if(result.isSuccess())
      {
        allPlans = result.getOrThrow().allPlans;
        allPlansIds = result.getOrThrow().plansIds;
        emit(GetAllPlansSuccessState());
      }
    else{
      emit(GetAllPlansErrorState());
    }
  }

  Future<void> deletePlan(context,{
    required int index,
    required String planName,
  })async
  {
    final result = await repo.deletePlan(context, planId: allPlansIds[index]);
    if(result.isSuccess())
      {
        allPlans.remove(planName);
        allPlansIds.remove(allPlansIds[index]);
        emit(DeletePlanSuccessState());
      }
    else{
      emit(DeletePlanErrorState());
    }
  }

  Future<void> deleteExerciseFromPlan(context,{
    required DeleteFromPlanModel inputs,
  })async
  {
    final result = await repo.deleteExerciseFromPlan(context, inputs: inputs);
    if(result.isSuccess())
      {
        (allPlans[inputs.planName]['list${inputs.listIndex}'] as List).removeAt(inputs.exerciseIndex);
        emit(DeleteExerciseFromPlanSuccessState());
      }
    else{
      emit(DeleteExerciseFromPlanErrorState());
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

    final result = await service.callFireStore('chest');
    if(result.isSuccess())
      {
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
              'dateTime' : Constants.dataTime,
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
                          'dateTime' : Constants.dataTime,
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
                'dateTime' : Constants.dataTime,
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
                              'dateTime' : Constants.dataTime,
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
    else{
      MySnackBar.showSnackBar(
        context: context,
        message: result.tryGetError()!.message!,
        color: Constants.appColor,
      );
    }

  }

  Map<String,dynamic> roadToPlanExercise = {};
  List<MyRecord> records = [];
  Future<void> pickRecordsToMakeChart(context,{
    required MainFunctions plansRepo
  })async
  {
    records = [];
    emit(MakeChartForExerciseInPlanLoadingState());
    final result = await plansRepo.getRecords(context);
    if(result.isSuccess())
      {
        records = result.getOrThrow();
        emit(MakeChartForExerciseInPlanSuccessState());
      }
    else{
      emit(MakeChartForExerciseInPlanErrorState());
    }
  }

  int dot = 0;
  void changeDot(int newDot)
  {
    dot = newDot;
    emit(ChangeDotSuccessState());
  }
}

