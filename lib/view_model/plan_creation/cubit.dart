import 'dart:developer';
import 'package:be_fit/model/remote/firebase_service/fireStore_service/implementation.dart';
import 'package:be_fit/model/remote/firebase_service/fireStore_service/interface.dart';
import 'package:be_fit/models/widgets/modules/snackBar.dart';
import 'package:be_fit/view_model/plan_creation/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../constants/constants.dart';
import '../../model/local/cache_helper/shared_prefs.dart';
import '../../models/data_types/exercises.dart';
import '../../models/data_types/make_plan.dart';
import '../../models/widgets/modules/toast.dart';
import '../../view/BottomNavBar/bottom_nav_bar.dart';

class PlanCreationCubit extends Cubit<PlanCreationStates>
{
  PlanCreationCubit(super.initialState);

  static PlanCreationCubit getInstance(context) => BlocProvider.of(context);

  List<String> muscles =
  [
    'Aps',
    'chest',
    'Back',
    'biceps',
    'triceps',
    'Shoulders',
    'legs'
  ];

  Map<String, List<Exercises>> musclesAndItsExercises = {};
  Map<String, List<bool>> muscleExercisesCheckBox = {};

  // for ui
  Future<void> getMuscles(context,{required String uId})async
  {
    musclesAndItsExercises = {};
    muscleExercisesCheckBox = {};

    for(int i = 0; i < muscles.length; i++)
    {
      musclesAndItsExercises[muscles[i]] = [];
      muscleExercisesCheckBox[muscles[i]] = [];
    }

    emit(GetAllMusclesLoadingState());
    FireStoreService service = FireStoreCall();
    final result = await service.callFireStore('Chest');

    if(result.isSuccess())
      {
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
                switch(muscles[i])
                {
                  case 'chest':
                    await getChestExercises(element: element, i: i, uId: uId);
                    break;

                  case 'Back' :
                    await getBackExercises(element: element, i: i, uId: uId);
                    break;

                  case 'biceps':
                    await getBicepsExercises(element: element, i: i, uId: uId);
                    break;

                  case 'triceps' :
                    await getTricepsExercises(element: element, i: i, uId: uId);
                    break;

                  case 'Aps' :
                    await getApsExercises(element: element, i: i, uId: uId);
                    break;

                  case 'legs' :
                    await getLegsExercises(element: element, i: i, uId: uId);
                    break;

                  case 'Shoulders' :
                    await getShouldersExercises(element: element, i: i, uId: uId);
                    break;
                }
              });
            });
          }

          emit(GetAllMusclesSuccessState());

        } on Exception catch(e){
          emit(GetAllMusclesErrorState());
          MyMethods.handleError(context, e);
        }
      }
    else{
      emit(GetAllMusclesErrorState());

      MySnackBar.showSnackBar(
          context: context,
          message: result.tryGetError()!.message!
      );
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
              muscleName: muscles[i],
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
    musclesAndItsExercises['Aps']?.add(
      Exercises(
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
              muscleName: muscles[i],
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
              muscleName: muscles[i],
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

  Future<void> getBicepsExercises({
    required QueryDocumentSnapshot<Map<String, dynamic>> element,
    required int i,
    required uId,
  })async
  {
    musclesAndItsExercises['biceps']?.add(
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

    muscleExercisesCheckBox['biceps']?.add(false);

    if(element.data()['name'] == 'barbell curls')
    {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('customExercises')
          .where('muscle', isEqualTo: 'biceps')
          .get()
          .then((value)
      {
        value.docs.forEach((element) {
          muscleExercisesCheckBox['biceps']?.add(false);
          musclesAndItsExercises['biceps']?.add(
            CustomExercises(
              muscleName: muscles[i],
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

  Future<void> getTricepsExercises({
    required QueryDocumentSnapshot<Map<String, dynamic>> element,
    required int i,
    required uId,
  })async
  {
    musclesAndItsExercises['triceps']?.add(
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

    muscleExercisesCheckBox['triceps']?.add(false);

    if(element.data()['name'] == 'Bumbell kick back')
    {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('customExercises')
          .where('muscle', isEqualTo: 'triceps')
          .get()
          .then((value)
      {
        value.docs.forEach((element) {
          muscleExercisesCheckBox['triceps']?.add(false);
          musclesAndItsExercises['triceps']?.add(
            CustomExercises(
              muscleName: muscles[i],
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
              muscleName: muscles[i],
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
              muscleName: muscles[i],
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

  void addCustomExerciseToMuscles(String muscleName, CustomExercises exercise)
  {
    if(musclesAndItsExercises[muscleName] == null)
      {
        return;
      }
    else{
      musclesAndItsExercises[muscleName]!.add(exercise);
      muscleExercisesCheckBox[muscleName]!.add(false);
      emit(AddCustomExerciseToMuscles());
    }
  }

  void removeCustomExerciseFromMuscles({
    required String muscleName,
    required String exerciseId,
  })
  {
    if(musclesAndItsExercises[muscleName] == null)
    {
      return;
    }
    else{
      musclesAndItsExercises[muscleName]!.removeWhere((element) => element.id == exerciseId);
      muscleExercisesCheckBox[muscleName]!.remove(false);
      emit(RemoveCustomExerciseFromMuscles());
    }
  }

  // day ,    musclesCheckBox
  Map<String,Map<String, List<bool>>> dayCheckBox = {};
  void initializingDaysCheckBox(int day)
  {
    for(int i = 1; i <= day; day--)
    {
      dayCheckBox['day$day'] = muscleExercisesCheckBox
          .map((key, value) => MapEntry(key, List<bool>.from(value)));

      log('test2 ${identical(dayCheckBox['day$day'], muscleExercisesCheckBox)}');

    }
    log('$dayCheckBox');
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
    log('$lists');
  }

  void addToPlanExercises(int day,Exercises exercise)
  {
    lists['list$day']!.add(exercise);
    log('$lists');
    emit(AddToExercisePlanList());
  }

  void removeFromPlanExercises(int day,Exercises exercise)
  {
    lists['list$day']!.remove(exercise);
    log('$lists');
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
        msg: 'Preparing tour plan...',
        color: CacheHelper.getInstance().shared.getBool('appTheme') == false?
        Colors.grey[200]:
        HexColor('#333333'),
    );
    emit(CreateNewPlanLoadingState());

    FireStoreService service = FireStoreCall();
    final result = await service.callFireStore('chest');
    if(result.isSuccess())
      {
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
                  await FirebaseFirestore.instance
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

                      await planExercise.set({
                        'name' : element.name,
                        'docs' : element.docs,
                        'image' : element.image,
                        'muscle' : element.muscleName,
                        'video' : element.video,
                        'sets' : element.sets,
                        'reps' : element.reps,
                        'isCustom' : true,
                      });

                      value.docs.forEach((element)async {
                        await planExercise.collection('records')
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
                      checkCollection.docs.forEach((element)async {
                        await exerciseDoc.collection('records')
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
            MyToast.showToast(
              context,
              msg: 'Plan is Ready',
              color: Colors.green,
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavBar(),
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
    else{
      emit(CreateNewPlanErrorState());
      MySnackBar.showSnackBar(
          context: context,
          message: result.tryGetError()!.message!
      );
    }
  }
}