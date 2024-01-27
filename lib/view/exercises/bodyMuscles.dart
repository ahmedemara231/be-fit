import 'package:be_fit/constants.dart';
import 'package:be_fit/view/exercises/exercises.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:flutter/material.dart';
import '../../../models/widgets/modules/myText.dart';
import '../../models/widgets/exercise_model.dart';

class BodyMuscles extends StatefulWidget {
   const BodyMuscles({super.key});

  @override
  State<BodyMuscles> createState() => _BodyMusclesState();
}

class _BodyMusclesState extends State<BodyMuscles> {
  late List<ExerciseModel> exerciseModel;

  @override
  void initState() {
    exerciseModel =
    [
      ExerciseModel(imageUrl: 'aps', text: 'Aps',numberOfExercises: 2),
      ExerciseModel(imageUrl: 'back', text: 'Back',numberOfExercises: 4),
      ExerciseModel(imageUrl: 'chest', text: 'chest',numberOfExercises: 5),
      ExerciseModel(imageUrl: 'Legs', text: 'legs',numberOfExercises: 5),
      ExerciseModel(imageUrl: 'shoulders', text: 'Shoulders',numberOfExercises: 5),
    ];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: MyText(
                  text: 'Good morning, ${CacheHelper.getInstance().userName}',
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12,bottom: 30),
                  child: Row(
                    children: [
                      MyText(
                        text: 'Select',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(width: 10,),
                      MyText(
                        text: 'Muscle',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Constants.appColor,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) => InkWell(
                      onTap: ()
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExercisesForMuscle(
                                muscleName: exerciseModel[index].text,
                                numberOfExercises: exerciseModel[index].numberOfExercises,
                              ),
                            ),
                        );
                      },
                        child: exerciseModel[index],
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                    itemCount: exerciseModel.length
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
