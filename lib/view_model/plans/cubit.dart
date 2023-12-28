import 'package:be_fit/models/exercises.dart';
import 'package:be_fit/models/setRecord_model.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import '../../modules/snackBar.dart';

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

  List<Exercises> backExercisesForPlan = [];
  List<bool?> backCheckBoxes = [];

  List<Exercises> chestExercisesForPlan = [];
  List<bool?> chestCheckBoxes = [];

  List<Exercises> apsExercisesForPlan = [];
  List<bool?> apsCheckBoxes = [];

  List<Exercises> shouldersExercisesForPlan = [];
  List<bool?> shoulderCheckBoxes = [];

  List<Exercises> legsExercisesForPlan = [];
  List<bool?> legsCheckBoxes = [];


  List<List<Exercises>> musclesForPlan = [];
  List<List<bool?>> musclesCheckBoxes = [];

  Future<void> getMuscles({
    required int day
})async // for ui
  {
    apsExercisesForPlan = [];
    apsCheckBoxes = [];

    chestExercisesForPlan = [];
    chestCheckBoxes= [];

    backExercisesForPlan = [];
    backCheckBoxes = [];

    shouldersExercisesForPlan = [];
    shoulderCheckBoxes = [];

    legsExercisesForPlan = [];
    legsCheckBoxes = [];

    musclesForPlan = [];
    musclesCheckBoxes = [];

    emit(GetAllMusclesLoadingState());
    for(int i = 0; i < muscles.length; i++)
      {
        await FirebaseFirestore.instance
            .collection(muscles[i])
            .get()
            .then((value)
        {
          value.docs.forEach((element)async{
            if(muscles[i] == 'chest')
              {
                chestExercisesForPlan.add(
                    Exercises(
                        name: element.data()['name'],
                        image: element.data()['image'],
                        docs: element.data()['docs'],
                        id: element.id,
                        isCustom: element.data()['isCustom'],
                        video: element.data()['video']?? '',
                        muscleName: muscles[i],
                    ),
                );

                chestCheckBoxes.add(false);
              }
            else if(muscles[i] == 'Back')
              {
                backExercisesForPlan.add(
                  Exercises(
                  name: element.data()['name']?? '',
                  image: element.data()['image']?? '',
                  docs: element.data()['docs']?? '',
                  id: element.id?? '',
                  isCustom: element.data()['isCustom']?? false,
                  video: element.data()['video']?? '',
                    muscleName: muscles[i],
                ),
                );
                backCheckBoxes.add(false);
              }
            else if(muscles[i] == 'Aps')
              {
                apsExercisesForPlan.add(
                  Exercises(
                    name: element.data()['name']?? '',
                    image: element.data()['image']?? '',
                    docs: element.data()['docs']?? '',
                    id: element.id?? '',
                    isCustom: element.data()['isCustom']?? false,
                    video: element.data()['video']?? '',
                    muscleName: muscles[i],
                  ),
                );
                apsCheckBoxes.add(false);
              }
            else if(muscles[i] == 'legs')
              {
                legsExercisesForPlan.add(
                  Exercises(
                  name: element.data()['name']?? '',
                  image: element.data()['image']?? '',
                  docs: element.data()['docs']?? '',
                  id: element.id?? '',
                  isCustom: element.data()['isCustom']?? false,
                  video: element.data()['video']?? '',
                    muscleName: muscles[i],
                ),
                );
                legsCheckBoxes.add(false);
              }
            else{
              shouldersExercisesForPlan.add(
                Exercises(
                name: element.data()['name']?? '',
                image: element.data()['image']?? '',
                docs: element.data()['docs']?? '',
                id: element.id?? '',
                isCustom: element.data()['isCustom']?? false,
                video: element.data()['video']?? '',
                  muscleName: muscles[i],
              ),
              );
              shoulderCheckBoxes.add(false);
            }
          });
          emit(GetAllMusclesSuccessState());
        }).catchError((error)
        {
          emit(GetAllMusclesErrorState());
        });
      }


    musclesForPlan.add(apsExercisesForPlan);
    musclesForPlan.add(chestExercisesForPlan);
    musclesForPlan.add(backExercisesForPlan);
    musclesForPlan.add(shouldersExercisesForPlan);
    musclesForPlan.add(legsExercisesForPlan);

    musclesCheckBoxes.add(apsCheckBoxes);
    musclesCheckBoxes.add(chestCheckBoxes);
    musclesCheckBoxes.add(backCheckBoxes);
    musclesCheckBoxes.add(shoulderCheckBoxes);
    musclesCheckBoxes.add(legsCheckBoxes);

    daysCheckBox['day$day'] = List.from(musclesCheckBoxes);
    print(daysCheckBox);

    // print(musclesCheckBoxes);
    // print(musclesForPlan);
  }

  Map<String,dynamic> daysCheckBox = {};
  void newChangeCheckBoxValue({
    required int dayIndex,
    required int muscle,
    required int exerciseIndex,
    required bool value,
})
  {
    daysCheckBox['day$dayIndex'][muscle][exerciseIndex] = value;
    emit(ChangeCheckBoxValue());
    print(daysCheckBox);
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

  List<Exercises> planExercises = [];
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

  Future<void> createNewPlan({
    required int? daysNumber,
    required String name,
    required String uId,
  })async
  {
    emit(CreateNewPlanLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('plans')
        .add(
      {
        'name' : name,
        'daysNumber' : daysNumber,
      },
    ).then((value)
    {
      List<String> listsKeys = lists.keys.toList();
      print('half made');

      for(int index = 0; index <= ( daysNumber! - 1 ); index++)
      {
        FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .collection('plans')
            .doc(value.id)   // البلان اللي انت لسة عاملها
            .collection(listsKeys[index]); // على حسب عدد الايام هيتفتح collections

        ///////////////////////////////////////////////////////

                // list1
        lists[listsKeys[index]]!.forEach((element)async {

         DocumentReference planExerciseId = FirebaseFirestore.instance
              .collection('users')
              .doc(uId)
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
                 .where('uId',isEqualTo: uId)
                 .get();

             if(checkCollection.docs.isNotEmpty)
             {
               DocumentReference exerciseDoc = FirebaseFirestore.instance
                   .collection('users')
                   .doc(uId)
                   .collection('plans')
                   .doc(value.id)
                   .collection(listsKeys[index])
                   .doc(planExerciseId.id);

               exerciseDoc.set(
                 {
                   'name' : element.name,
                   'docs' : element.docs,
                   'image' : element.image,
                   'muscle' : element.muscleName,
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
               FirebaseFirestore.instance
                   .collection('users')
                   .doc(uId)
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
                 },
               );
             }
           }
        });
      }
      emit(CreateNewPlanSuccessState());
    }).catchError((error)
    {
      emit(CreateNewPlanErrorState());
    });
  }

  Map<String,List<Exercises>> plan = {};
  Map<String,dynamic> allPlans = {};
  List<String> allPlansIds = [];
  List<int> days = [1,2,3,4,5,6];

  List<String> plansNames = [];
  Future<void> getAllPlans(String uId)async
  {
    plan = {};
    allPlans = {};
    allPlansIds = [];

    emit(GetAllPlans2LoadingState());
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
                        video: '',
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
    }).catchError((error)
    {
      emit(GetAllPlans2ErrorState());
    });
  }

  void finishPlansForCurrentUser(int index,String planName)
  {
    allPlans[planName] = plan;
    print(allPlans);
  }

  List<String> getAllKeys()
  {
    List<String> allKeys = allPlans.keys.toList();

    print('all Keys : $allKeys');
    return allKeys;
  }

  Future<void> deletePlan({
    required int index,
    required String uId,
    required String planName,
  })async
  {
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
    }).catchError((error)
    {
      emit(DeletePlanErrorState());
    });
  }

  Future<void> deleteExerciseFromPlan({
    required String planDoc,
    required int listIndex,
    required String exerciseDoc,
    required String uId,
})async
  {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('plans')
        .doc(planDoc)
        .collection('list${listIndex + 1}')
        .doc(exerciseDoc)
        .delete()
        .then((value)
    {
      print('deleted');
      // المفروض امسحها من ال all plans عشان تتمسح قدام اليوزر
    }).catchError((error){});
  }

  Future<void> setARecordFromPlan({
    required SetRecordForPlanExercise planExerciseRecord,
    required context,
    required String muscleName,
})async
  {
    double? reps = double.tryParse(planExerciseRecord.reps);
    double? weight = double.tryParse(planExerciseRecord.weight);

    await FirebaseFirestore.instance
        .collection(muscleName)
        .doc(planExerciseRecord.exerciseDoc)
        .collection('records')
        .add(
      {
        'weight' : weight,
        'reps' : reps,
        'dateTime' : Jiffy.now().yMMMd,
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
                      'dateTime' : Jiffy.now().yMMMd,
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
      MySnackBar.showSnackBar(
          context: context,
          message: 'Saved to records',
          color: Colors.green
      );
    });
  }
}