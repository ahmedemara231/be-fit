import 'package:be_fit/src/core/extensions/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/app_widgets/exercises_card.dart';
import '../../../../core/helpers/app_widgets/specific_exercise/specific_exercise.dart';
import '../../../../core/helpers/global_data_types/exercises.dart';

class DefaultExercises extends StatelessWidget {
  final String muscleName;
  final List<Exercises> exerciseList;
  const DefaultExercises({super.key,
    required this.muscleName,
    required this.exerciseList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => InkWell(
              onTap: () {
                Exercises exercise = Exercises(
                  name: exerciseList[index].name,
                  docs: exerciseList[index].docs,
                  id: exerciseList[index].id,
                  image: exerciseList[index].image,
                  isCustom: exerciseList[index].isCustom,
                  video: exerciseList[index].video,
                  muscleName: muscleName,
                );
                context.normalNewRoute(
                  SpecificExercise(
                    exercise: exercise,
                  ),
                );
              },
              child: ExercisesCard(
                  imageUrl: exerciseList[index].image[0],
                  title: exerciseList[index].name,
              )
            ),
        separatorBuilder: (context, index) => SizedBox(
              height: 16.h,
            ),
        itemCount: exerciseList.length
    );
  }
}