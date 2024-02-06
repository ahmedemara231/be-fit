import 'dart:developer';
import 'package:be_fit/view_model/plan_creation/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants.dart';
import '../../models/data_types/exercises.dart';
import '../../models/data_types/make_plan.dart';
import '../../models/widgets/modules/toast.dart';
import '../../view/BottomNavBar/bottomNavBar.dart';

class PlanCreationCubit extends Cubit<PlanCreationStates>
{
  PlanCreationCubit(super.initialState);

  static PlanCreationCubit getInstance(context) => BlocProvider.of(context);

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
  Future<void> getMuscles(context,{required String uId})async
  {

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
    try
    {
      for(int i = 0; i < muscles.length; i++) // 1
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
              await getChestExercises(element: element, i: i, uId: uId);
            }

            else if(muscles[i] == 'Back')
            {
              await getBackExercises(element: element, i: i, uId: uId);
            }

            else if(muscles[i] == 'Aps')
            {
              await getApsExercises(element: element, i: i, uId: uId);
            }

            else if(muscles[i] == 'legs')
            {
              await getLegsExercises(element: element, i: i, uId: uId);
            }

            else{
              await getShouldersExercises(element: element, i: i, uId: uId);
            }
          });
          emit(GetAllMusclesSuccessState());
        });

      }

      print(musclesAndItsExercises);
      print(muscleExercisesCheckBox);

    } on Exception catch(e){
      emit(GetAllMusclesErrorState());
      MyMethods.handleError(context, e);
    }
  }

  Future<void> getChestExercises({
    required QueryDocumentSnapshot<Map<String, dynamic>> element,
    required int i,
    required uId,
  })async
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

    if(element.data()['name'] == 'Chest press machine')
    {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('customExercises')
          .where('muscle', isEqualTo: 'chest')
          .get()
          .then((value)
      {
        value.docs.forEach((element) {
          muscleExercisesCheckBox['chest']?.add(false);
          musclesAndItsExercises['chest']?.add(
            CustomExercises(
              name: element.data()['name'],
              image: element.data()['image'],
              docs: element.data()['description'],
              id: element.id,
              isCustom: true,
              video: 'video',
            ),
          );
        });
      });
    }
  }

  Future<void> getApsExercises({
    required QueryDocumentSnapshot<Map<String, dynamic>> element,
    required int i,
    required uId,
  })async{
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

    if(element.data()['name'] == 'Crunches')
    {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('customExercises')
          .where('muscle', isEqualTo: 'Aps')
          .get()
          .then((value)
      {
        value.docs.forEach((element) {
          muscleExercisesCheckBox['Aps']?.add(false);
          musclesAndItsExercises['Aps']?.add(
            CustomExercises(
              name: element.data()['name'],
              image: element.data()['image'],
              docs: element.data()['description'],
              id: element.id,
              isCustom: true,
              video: 'video',
            ),
          );
        });
      });
    }
  }

  Future<void> getBackExercises({
    required QueryDocumentSnapshot<Map<String, dynamic>> element,
    required int i,
    required uId,
  })async
  {
    muscleExercisesCheckBox['Back']?.add(false);
    musclesAndItsExercises['Back']?.add(
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

    if(element.data()['name'] == 'Lat pull down')
    {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('customExercises')
          .where('muscle', isEqualTo: 'Back')
          .get()
          .then((value)
      {
        value.docs.forEach((element) {
          muscleExercisesCheckBox['Back']?.add(false);
          musclesAndItsExercises['Back']?.add(
            CustomExercises(
              name: element.data()['name'],
              image: element.data()['image'],
              docs: element.data()['description'],
              id: element.id,
              isCustom: true,
              video: 'video',
            ),
          );
        });
      });
    }
  }

  Future<void> getLegsExercises({
    required QueryDocumentSnapshot<Map<String, dynamic>> element,
    required int i,
    required uId,
  })async{
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

    if(element.data()['name'] == 'Leg press')
    {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('customExercises')
          .where('muscle', isEqualTo: 'Legs')
          .get()
          .then((value)
      {
        value.docs.forEach((element) {
          muscleExercisesCheckBox['legs']?.add(false);
          musclesAndItsExercises['legs']?.add(
            CustomExercises(
              name: element.data()['name'],
              image: element.data()['image'],
              docs: element.data()['description'],
              id: element.id,
              isCustom: true,
              video: 'video',
            ),
          );
        });
      });
    }
  }

  Future<void> getShouldersExercises({
    required QueryDocumentSnapshot<Map<String, dynamic>> element,
    required int i,
    required uId,
  })async{
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

    if(element.data()['name'] == 'Dumbbell Lateral Raises')
    {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('customExercises')
          .where('muscle', isEqualTo: 'Shoulders')
          .get()
          .then((value)
      {
        value.docs.forEach((element) {
          muscleExercisesCheckBox['Shoulders']?.add(false);
          musclesAndItsExercises['Shoulders']?.add(
            CustomExercises(
              name: element.data()['name'],
              image: element.data()['image'],
              docs: element.data()['description'],
              id: element.id,
              isCustom: true,
              video: 'video',
            ),
          );
        });
      });
    }
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
    required String uId,
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
      ).then((planDoc)
      {
        List<String> listsKeys = lists.keys.toList();
        log('half made');

        for(int index = 0; index <= ( makePlanModel.daysNumber! - 1 ); index++)
        {
          FirebaseFirestore.instance
              .collection('users')
              .doc(makePlanModel.uId)
              .collection('plans')
              .doc(planDoc.id)   // البلان اللي انت لسة عاملها
              .collection(listsKeys[index]); // على حسب عدد الايام هيتفتح collections

          ///////////////////////////////////////////////////////

          // list1
          lists[listsKeys[index]]!.forEach((element)async {

            DocumentReference planExerciseDoc = FirebaseFirestore.instance
                .collection('users')
                .doc(makePlanModel.uId)
                .collection('plans')
                .doc(planDoc.id)
                .collection(listsKeys[index])
                .doc(element.id); // 1st exercise in list1 in the plan

            // check if this exercise has a records or not for this user

            if(element.isCustom == true)
            {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(uId)
                  .collection('customExercises')
                  .doc(planExerciseDoc.id)
                  .collection('records')
                  .get()
                  .then((value)async
              {
                if(value.docs.isNotEmpty)
                {
                  DocumentReference<Map<String, dynamic>> planExercise = FirebaseFirestore.instance
                      .collection('users')
                      .doc(uId)
                      .collection('plans')
                      .doc(planDoc.id)
                      .collection(listsKeys[index])
                      .doc(planExerciseDoc.id);

                  planExercise.set({
                    'name' : element.name,
                    'docs' : element.docs,
                    'image' : element.image,
                    'muscle' : element.muscleName,
                    'video' : element.video,
                    'sets' : element.sets,
                    'reps' : element.reps,
                    'isCustom' : true,
                  });

                  value.docs.forEach((element) {
                    planExercise.collection('records')
                        .doc(element.id)
                        .set({
                      'dateTime': element.data()['dateTime'],
                      'reps': element.data()['reps'],
                      'weight': element.data()['weight'],
                    });
                  });

                }
                else {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uId)
                      .collection('plans')
                      .doc(planDoc.id)
                      .collection(listsKeys[index])
                      .doc(planExerciseDoc.id)
                      .set({
                    'name' : element.name,
                    'docs' : element.docs,
                    'image' : element.image,
                    'muscle' : element.muscleName,
                    'video' : element.video,
                    'sets' : element.sets,
                    'reps' : element.reps,
                    'isCustom' : true,
                  });
                }
              });
            }
            else{
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
                      .doc(planDoc.id)
                      .collection(listsKeys[index])
                      .doc(planExerciseDoc.id);

                  await exerciseDoc.set(
                    {
                      'name' : element.name,
                      'docs' : element.docs,
                      'image' : element.image,
                      'muscle' : element.muscleName,
                      'video' : element.video,
                      'sets' : element.sets,
                      'reps' : element.reps,
                      'isCustom' : false,
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
                      .doc(planDoc.id)
                      .collection(listsKeys[index])
                      .doc(planExerciseDoc.id)
                      .set(
                    {
                      'name' : element.name,
                      'docs' : element.docs,
                      'image' : element.image,
                      'muscle' : element.muscleName,
                      'video' : element.video,
                      'sets' : element.sets,
                      'reps' : element.reps,
                      'isCustom' : false,
                    },
                  );
                }
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

}