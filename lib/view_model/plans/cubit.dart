import 'package:be_fit/constants.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/data_types/make_plan.dart';
import 'package:be_fit/models/data_types/setRecord_model.dart';
import '../../models/widgets/modules/toast.dart';
import 'package:be_fit/view/statistics/statistics.dart';
import 'package:be_fit/view_model/internet_connection_check/internet_connection_check.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import '../../models/data_types/delete_exercise_from_plan.dart';
import '../../view/BottomNavBar/bottomNavBar.dart';

class PlansCubit extends Cubit<PlansStates>
{
  PlansCubit(super.initialState);
  static PlansCubit getInstance(context) => BlocProvider.of(context);

  List<String> muscles =
  [
    'Aps',
    'chest',
    'Back',
    'Shoulders',
    'legs'
  ];

  Map<String, List<Exercises>> musclesAndItsExercises = {};
  Map<String, List<bool>> muscleExercisesCheckBox = {};

  // for ui
  Future<void> getMuscles(context,{
    required String uId,
})async
  {
    bool isFetched = false;

    List<bool> customMusclesFetched = [];
    musclesAndItsExercises = {};
    muscleExercisesCheckBox = {};

    for(int i = 0; i <= (muscles.length - 1); i++)
      {
        customMusclesFetched.add(false);
        musclesAndItsExercises[muscles[i]] = [];
        muscleExercisesCheckBox[muscles[i]] = [];
      }

    emit(GetAllMusclesLoadingState());


      for(int i = 0; i < muscles.length; i++) // 1
        {
          try
          {
            await FirebaseFirestore.instance
                .collection(muscles[i])
                .get()
                .then((value)
            {
              value.docs.forEach((element)async{ // 2

                // 5 times
                if(muscles[i] == 'chest')
                {
                  musclesAndItsExercises['chest']?.add(
                    Exercises(
                      name: element.data()['name'],
                      image: element.data()['image'],
                      docs: element.data()['docs'],
                      id: element.id,
                      isCustom: element.data()['isCustom'],
                      video: element.data()['video'],
                      muscleName: muscles[i],
                    ),
                  );
                  muscleExercisesCheckBox['chest']?.add(false);




                  // 5 times
                  // if(isFetched == false)
                  // {
                  //   await FirebaseFirestore.instance
                  //       .collection('users')
                  //       .doc(uId)
                  //       .collection('customExercises')
                  //       .where('muscle', isEqualTo: 'chest')
                  //       .get()
                  //       .then((value)
                  //   {
                  //     value.docs.forEach((element) {
                  //       muscleExercisesCheckBox['chest']?.add(false);
                  //       musclesAndItsExercises['chest']?.add(
                  //         CustomExercises(
                  //           name: element.data()['name'],
                  //           image: element.data()['image'],
                  //           docs: element.data()['description'],
                  //           id: element.id,
                  //           isCustom: true,
                  //           video: 'video',
                  //         ),
                  //       );
                  //     });
                  //   });
                  //
                  //   isFetched = true;
                  //   // customMusclesFetched[i] = !customMusclesFetched[i];
                  //   // print(customMusclesFetched[i]);
                  // }

                }

                else if(muscles[i] == 'Back')
                {
                  muscleExercisesCheckBox['Back']?.add(false);
                  musclesAndItsExercises['Back']?.add( Exercises(
                    name: element.data()['name'],
                    image: element.data()['image'],
                    docs: element.data()['docs'],
                    id: element.id,
                    isCustom: element.data()['isCustom'],
                    video: element.data()['video'],
                    muscleName: muscles[i],
                  ),);
                }
                else if(muscles[i] == 'Aps')
                {
                  muscleExercisesCheckBox['Aps']?.add(false);
                  musclesAndItsExercises['Aps']?.add( Exercises(
                    name: element.data()['name'],
                    image: element.data()['image'],
                    docs: element.data()['docs'],
                    id: element.id,
                    isCustom: element.data()['isCustom'],
                    video: element.data()['video'],
                    muscleName: muscles[i],
                  ),);
                }
                else if(muscles[i] == 'legs')
                {
                  muscleExercisesCheckBox['legs']?.add(false);
                  musclesAndItsExercises['legs']?.add( Exercises(
                    name: element.data()['name'],
                    image: element.data()['image'],
                    docs: element.data()['docs'],
                    id: element.id,
                    isCustom: element.data()['isCustom'],
                    video: element.data()['video'],
                    muscleName: muscles[i],
                  ),);
                }
                else{
                  muscleExercisesCheckBox['Shoulders']?.add(false);
                  musclesAndItsExercises['Shoulders']?.add( Exercises(
                    name: element.data()['name'],
                    image: element.data()['image'],
                    docs: element.data()['docs'],
                    id: element.id,
                    isCustom: element.data()['isCustom'],
                    video: element.data()['video'],
                    muscleName: muscles[i],
                  ),);
                }
              });
              emit(GetAllMusclesSuccessState());
            });
          } on Exception catch(e){
            emit(GetAllMusclesErrorState());
            MyMethods.handleError(context, e);
          }
      }

    print(musclesAndItsExercises);
    print(muscleExercisesCheckBox);
    print(musclesAndItsExercises['chest']?.length);
  }

       // day ,    musclesCheckBox
  Map<String,Map<String, List<bool>>> dayCheckBox = {};
  void initializingDaysCheckBox(int day)
  {
    for(int i = 1; i <= day; day--)
      {
        dayCheckBox['day$day'] = Map.from(muscleExercisesCheckBox);
      }
    print(dayCheckBox);
  }

  void newChangeCheckBoxValue({
    required int dayIndex,
    required String muscle,
    required int exerciseIndex,
    required bool value,
})
  {
    dayCheckBox['day$dayIndex']?[muscle]?[exerciseIndex] = value;
    emit(ChangeCheckBoxValue());
  }

  Map<String,List<Exercises>> lists = {};
  void makeListForEachDay(int? numberOfDays)
  {
    lists = {};

    for(int i = 1; i <= numberOfDays!; i++)
      {
        lists['list$i'] = [];
      }
    print(lists);
  }

  void addToPlanExercises(int day,Exercises exercise)
  {
    lists['list$day']!.add(exercise);
    print(lists);
    emit(AddToExercisePlanList());
  }

  void removeFromPlanExercises(int day,Exercises exercise)
  {
    lists['list$day']!.remove(exercise);
    print(lists);
    emit(RemoveFromExercisePlanList());
  }

  int currentIndex = 1;

  void changeDaysNumber(int newValue)
  {
    currentIndex = newValue;
    emit(ChangeDaysNumber());
  }

  Future<void> createNewPlan(context,{
    required MakePlanModel makePlanModel,
    required InternetCheck internetCheck,
  })async
  {
    MyToast.showToast(
        context,
        msg: 'Preparing tour plan',
        color: Colors.grey[400]
    );
    emit(CreateNewPlanLoadingState());

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(makePlanModel.uId)
          .collection('plans')
          .add(
        {
          'name' : makePlanModel.name,
          'daysNumber' : makePlanModel.daysNumber,
        },
      ).then((value)
      {
        List<String> listsKeys = lists.keys.toList();
        print('half made');

        for(int index = 0; index <= ( makePlanModel.daysNumber! - 1 ); index++)
        {
          FirebaseFirestore.instance
              .collection('users')
              .doc(makePlanModel.uId)
              .collection('plans')
              .doc(value.id)   // البلان اللي انت لسة عاملها
              .collection(listsKeys[index]); // على حسب عدد الايام هيتفتح collections

          ///////////////////////////////////////////////////////

          // list1
          lists[listsKeys[index]]!.forEach((element)async {

            DocumentReference planExerciseId = FirebaseFirestore.instance
                .collection('users')
                .doc(makePlanModel.uId)
                .collection('plans')
                .doc(value.id)
                .collection(listsKeys[index])
                .doc(element.id); // 1st exercise in list1 in the plan

            // check if this exercise has a records or not for this user

            for(int i = 0; i <= (muscles.length - 1); i++)
            {
              var checkCollection = await FirebaseFirestore.instance
                  .collection(muscles[i])
                  .doc(element.id)
                  .collection('records')
                  .where('uId',isEqualTo: makePlanModel.uId)
                  .get();

              if(checkCollection.docs.isNotEmpty)
              {
                DocumentReference exerciseDoc = FirebaseFirestore.instance
                    .collection('users')
                    .doc(makePlanModel.uId)
                    .collection('plans')
                    .doc(value.id)
                    .collection(listsKeys[index])
                    .doc(planExerciseId.id);

                await exerciseDoc.set(
                  {
                    'name' : element.name,
                    'docs' : element.docs,
                    'image' : element.image,
                    'muscle' : element.muscleName,
                    'video' : element.video,
                    'sets' : element.sets,
                    'reps' : element.reps,
                  },
                );
                checkCollection.docs.forEach((element) {
                  exerciseDoc.collection('records')
                      .doc(element.id)
                      .set(
                    {
                      'dateTime': element.data()['dateTime'],
                      'reps': element.data()['reps'],
                      'weight': element.data()['weight'],
                    },
                  );
                });
              }
              else{
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(makePlanModel.uId)
                    .collection('plans')
                    .doc(value.id)
                    .collection(listsKeys[index])
                    .doc(planExerciseId.id)
                    .set(
                  {
                    'name' : element.name,
                    'docs' : element.docs,
                    'image' : element.image,
                    'muscle' : element.muscleName,
                    'video' : element.video,
                    'sets' : element.sets,
                    'reps' : element.reps,
                  },
                );
              }
            }
          });
        }
        MyToast.showToast(context, msg: 'Plan is Ready');

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ), (route) => false,
        );
        emit(CreateNewPlanSuccessState());
      });
  } on Exception catch(e)
    {
      emit(CreateNewPlanErrorState());
      MyMethods.handleError(context, e);
    }
  }

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
          print('all plans ids : $allPlansIds');

          plan = {};
          print(value.docs[index].id);
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
                    isCustom: false,
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

    print(allPlans);
  }

  List<String> getAllKeys()
  {
    List<String> allKeys = allPlans.keys.toList();

    print('all Keys : $allKeys');
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
        print('deleted');
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
    required String muscleName,
    required InternetCheck internetCheck,
})async
  {
    double? reps = double.tryParse(planExerciseRecord.reps);
    double? weight = double.tryParse(planExerciseRecord.weight);

    try {
      await FirebaseFirestore.instance
          .collection(muscleName)
          .doc(planExerciseRecord.exerciseDoc)
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
          List<int> days = [1,2,3,4,5,6];
          value.docs.forEach((element) async {
            for(int i = 1; i <= days.length; i++)
            {                               // plan 1
              QuerySnapshot planList = await element.reference
                  .collection('list$i')
                  .get();
              if(planList.docs.isNotEmpty)
              {
                await element.reference
                    .collection('list$i').doc(planExerciseRecord.exerciseDoc)
                    .get().then((value)
                {
                  if(value.exists)
                  {
                    print(1);
                    element.reference
                        .collection('list$i')
                        .doc(planExerciseRecord.exerciseDoc)
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
                    print(0);
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