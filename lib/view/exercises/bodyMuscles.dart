
import 'package:be_fit/view/exercises/exercises.dart';
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
      // ExerciseModel(imageUrl: 'aps', text: 'Aps',numberOfExercises: 20),
      ExerciseModel(imageUrl: 'back', text: 'Back',numberOfExercises: 20),
      ExerciseModel(imageUrl: 'chest', text: 'chest',numberOfExercises: 20),
      // ExerciseModel(imageUrl: 'biceps', text: 'Biceps',numberOfExercises: 20),
      // ExerciseModel(imageUrl: 'foreArm', text: 'Fore Arm',numberOfExercises: 20),
      // ExerciseModel(imageUrl: 'Legs', text: 'Legs',numberOfExercises: 20),
      ExerciseModel(imageUrl: 'shoulders', text: 'Shoulders',numberOfExercises: 20),
      // ExerciseModel(imageUrl: 'triceps', text: 'Triceps',numberOfExercises: 20),
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
