
import 'package:be_fit/view/exercises/exercises.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/setting/cubit.dart';
import 'package:flutter/material.dart';
import '../../modules/myText.dart';
import '../../widgets_models/exercise_model.dart';

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
      ExerciseModel(imageUrl: 'back', text: 'Back',numberOfExercises: 2),
      ExerciseModel(imageUrl: 'chest', text: 'chest',numberOfExercises: 2),
      ExerciseModel(imageUrl: 'Legs', text: 'legs',numberOfExercises: 2),
      ExerciseModel(imageUrl: 'shoulders', text: 'Shoulders',numberOfExercises: 2),
    ];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: 'Exercises',fontSize: 25,fontWeight: FontWeight.bold,),
      ),
      body: ListView.separated(
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
    );
  }
}
