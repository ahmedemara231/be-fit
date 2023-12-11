import 'package:be_fit/models/exercises.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlansCubit extends Cubit<PlansStates>
{
  PlansCubit(super.initialState);
  static PlansCubit getInstance(context) => BlocProvider.of(context);

  // List<Map<String,dynamic>> plans = [];
  // Future<void> getAllPlans()async
  // {
  //   plans = [];
  //   emit(GetAllPlansLoadingState());
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc('gBWhBoVwrGNldxxAKbKk')
  //       .collection('plans')
  //       .get()
  //       .then((value)
  //   {
  //     value.docs.forEach((element) {
  //       plans.add(element.data());
  //     });
  //     print(plans);
  //     emit(GetAllPlansSuccessState());
  //   }).catchError((error)
  //   {
  //     emit(GetAllPlansErrorState());
  //   });
  // }


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

  Future<void> getMuscles()async // for ui
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
                // await FirebaseFirestore.instance
                //     .collection('users')
                //     .doc('gBWhBoVwrGNldxxAKbKk')
                //     .collection('customExercises')
                //     .where('muscle',isEqualTo: muscles[i])
                //     .get()
                //     .then((value)
                // {
                //   value.docs.forEach((element) {
                //     chestExercisesForPlan.add(
                //       Exercises(
                //         name: element.data()['name'],
                //         image: element.data()['image'],
                //         docs: element.data()['description'],
                //         id: element.id,
                //         isCustom: element.data()['isCustom'],
                //         video: element.data()['video']?? '',
                //       ),
                //     );
                //
                //     chestCheckBoxes.add(false);
                //   });
                // });

                chestExercisesForPlan.add(
                    Exercises(
                        name: element.data()['name'],
                        image: element.data()['image'],
                        docs: element.data()['docs'],
                        id: element.id,
                        isCustom: element.data()['isCustom'],
                        video: element.data()['video']?? '',
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

        // FirebaseFirestore.instance
        // .collection('users')
        // .doc('gBWhBoVwrGNldxxAKbKk')
        // .collection('customExercises')
        // .get()
        // .then((value)
        // {
        //   value.docs.forEach((element) {
        //     if(element.data()['muscle'] == 'Aps')
        //       {
        //         apsExercisesForPlan.add(
        //           Exercises(
        //             name: element.data()['name'],
        //             image: element.data()['image'],
        //             docs: element.data()['docs'],
        //             id: element.id,
        //             isCustom: element.data()['isCustom'],
        //             video: element.data()['video']?? '',
        //           ),
        //         );
        //         apsCheckBoxes.add(false);
        //       }
        //     else if(element.data()['muscle'] == 'chest')
        //     {
        //       chestExercisesForPlan.add(
        //         Exercises(
        //           name: element.data()['name'],
        //           image: element.data()['image'],
        //           docs: element.data()['docs'],
        //           id: element.id,
        //           isCustom: element.data()['isCustom'],
        //           video: element.data()['video']?? '',
        //         ),
        //       );
        //       chestCheckBoxes.add(false);
        //     }
        //     else if(element.data()['muscle'] == 'Back')
        //     {
        //       backExercisesForPlan.add(
        //         Exercises(
        //           name: element.data()['name']?? '',
        //           image: element.data()['image']?? '',
        //           docs: element.data()['docs']?? '',
        //           id: element.id?? '',
        //           isCustom: element.data()['isCustom']?? false,
        //           video: element.data()['video']?? '',
        //         ),
        //       );
        //       backCheckBoxes.add(false);
        //     }
        //     else if(element.data()['muscle'] == 'legs')
        //     {
        //       legsExercisesForPlan.add(
        //         Exercises(
        //           name: element.data()['name'],
        //           image: element.data()['image'],
        //           docs: element.data()['docs'],
        //           id: element.id,
        //           isCustom: element.data()['isCustom'],
        //           video: element.data()['video']?? '',
        //         ),
        //       );
        //       legsCheckBoxes.add(false);
        //     }
        //     else {
        //       shouldersExercisesForPlan.add(
        //         Exercises(
        //           name: element.data()['name']?? '',
        //           image: element.data()['image']?? '',
        //           docs: element.data()['docs']?? '',
        //           id: element.id?? '',
        //           isCustom: element.data()['isCustom']?? false,
        //           video: element.data()['video']?? '',
        //         ),
        //       );
        //       shoulderCheckBoxes.add(false);
        //     }
        //   });
        // });
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

    print(musclesCheckBoxes);
    print(musclesForPlan);
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
  void addToPlanExercises(Exercises exercise)
  {
    planExercises.add(exercise);
    print(planExercises);
    emit(AddToExercisePlanList());
  }
  void removeFromPlanExercises(Exercises exercise)
  {
    planExercises.remove(exercise);
    print(planExercises);
    emit(RemoveFromExercisePlanList());
  }

  void changeCheckBoxValue(bool? newValue, int index, int i)
  {
    musclesCheckBoxes[index][i] = newValue;
    print(musclesCheckBoxes);
    emit(ChangeCheckBoxValue());
  }

  void putExerciseList({
    required int index,
    required List<Exercises> exercises,
})
  {
    lists['list$index'] = exercises;
    planExercises = [];
    print(lists);
    emit(PutExercisesInList());
  }

  Future<void> createNewPlan({
    required int? daysNumber,
    required String name,
})async
  {
    emit(CreateNewPlanLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc('gBWhBoVwrGNldxxAKbKk')
        .collection('plans')
        .add(
        {
          'daysNumber' : daysNumber,
          'name' : name,
        },
    ).then((value)
    {
      List<String> listsKeys = lists.keys.toList();
      print('half made');

      for(int index = 0; index <= ( daysNumber! - 1 ); index++)
        {
          print(index);

          FirebaseFirestore.instance
              .collection('users')
              .doc('gBWhBoVwrGNldxxAKbKk')
              .collection('plans')
              .doc(value.id)    // list1
              .collection(listsKeys[index]);// على حسب عدد الايام هيتفتح collections

          lists[listsKeys[index]]!.forEach((element) {
            FirebaseFirestore.instance
                .collection('users')
                .doc('gBWhBoVwrGNldxxAKbKk')
                .collection('plans')
                .doc(value.id)
                .collection(listsKeys[index])
                .add(
                {
                  'name' : element.name,
                  'image' : element.image,
                  'docs' : element.docs,
                },
            );
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
  List<int> days = [1,2,3,4,5,6];
  Future<void> getAllPlans()async
  {
    plan = {};
    allPlans = {};

    emit(GetAllPlans2LoadingState());
    CollectionReference plansCollection = FirebaseFirestore.instance
        .collection('users')
        .doc('gBWhBoVwrGNldxxAKbKk')
        .collection('plans');

    await plansCollection
        .get()
        .then((value)async
    {
      for(int index = 0; index <= (value.docs.length - 1); index++)
        {
          plan = {};
          print(value.docs[index].id);
          for(int i = 1; i <= days.length; i++)
          {       // plan1
            await value.docs[index].reference.collection('list$i').get()
                .then((value)
            {
              plan['list$i'] = [];
              value.docs.forEach((element) {
                plan['list$i']?.add(Exercises(name: element.data()['name'], image: element.data()['image'], docs: element.data()['docs'], id: element.id, isCustom: false, video: ''));
              });
            });
          } // plan is ready to join allPlans
         finishPlansForCurrentUser(index);
        }

      emit(GetAllPlans2SuccessState());
    }).catchError((error)
    {
      emit(GetAllPlans2ErrorState());
    });
  }
  void finishPlansForCurrentUser(int index)
  {
    allPlans['plan$index'] = plan;
    print(allPlans);
  }

  List<String> allKeys()
  {
    List<String> allKeys = allPlans.keys.toList();
    print('alllll : $allKeys');
    return allKeys;
  }
}