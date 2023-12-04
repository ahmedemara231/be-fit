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
    'chest',
    'Back',
    'Shoulders',
  ];

  List<Exercises> chestExercisesForPlan = [];
  List<bool?> chestCheckBoxes = [];

  List<Exercises> backExercisesForPlan = [];
  List<bool?> backCheckBoxes = [];

  List<Exercises> shouldersExercisesForPlan = [];
  List<bool?> shoulderCheckBoxes = [];


  List<List<Exercises>> musclesForPlan = [];
  List<List<bool?>> musclesCheckBoxes = [];

  Future<void> getMuscles()async // for ui
  {
    chestExercisesForPlan = [];
    chestCheckBoxes= [];

    backExercisesForPlan = [];
    backCheckBoxes = [];

    shouldersExercisesForPlan = [];
    shoulderCheckBoxes = [];

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
          value.docs.forEach((element) {
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
      }

    musclesForPlan.add(chestExercisesForPlan);
    musclesForPlan.add(backExercisesForPlan);
    musclesForPlan.add(shouldersExercisesForPlan);

    musclesCheckBoxes.add(chestCheckBoxes);
    musclesCheckBoxes.add(backCheckBoxes);
    musclesCheckBoxes.add(shoulderCheckBoxes);

    print(musclesForPlan.length);
    print(musclesCheckBoxes.length);
    print(musclesCheckBoxes);

  }










  // كريت عدد من الlist على حسب عدد الايام
  // بتجيب planExercises list تملاها وبعدين تحطها ف الday list بتاعتها
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
  }
  
  Future<void> createNewPlan({
    required double daysNumber,
    required String name,
})async
  {
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
      print('half made');

      for(int i = 1; i < daysNumber; i++)
        {
          FirebaseFirestore.instance
              .collection('user')
              .doc('gBWhBoVwrGNldxxAKbKk')
              .collection('plans')
              .doc(value.id)
              .collection('day$i')
              .add(
              {
                'docs' : lists['list$i']?[0].docs,
                'image' : lists['list$i']?[0].image,
                'name' :  lists['list$i']?[0].name,
                'video' : lists['list$i']?[0].video,
              },
          ).then((value)
          {
            print('added');
          });
        }
    });
  }

}