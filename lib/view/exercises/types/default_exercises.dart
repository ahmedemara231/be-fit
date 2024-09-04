import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/model/remote/repositories/exercises/implementation.dart';
import 'package:be_fit/models/widgets/exercises_card.dart';
import 'package:flutter/material.dart';
import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/widgets/specificExercise/specific_exercise.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';

class DefaultExercises extends StatelessWidget {
  final String muscleName;
  const DefaultExercises({super.key, required this.muscleName});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Constants.appColor,
      color: Colors.white,
      onRefresh: () {
        ExercisesCubit.getInstance(context).getExercises(
          context,
          exercisesType: DefaultExercisesImpl(),
          muscleName: muscleName,
        );
        return Future(() => null);
      },
      child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Exercises exercise = Exercises(
                    name: ExercisesCubit.getInstance(context)
                        .exercisesList[index].name,
                    docs: ExercisesCubit.getInstance(context)
                        .exercisesList[index].docs,
                    id: ExercisesCubit.getInstance(context)
                        .exercisesList[index].id,
                    image: ExercisesCubit.getInstance(context)
                        .exercisesList[index].image,
                    isCustom: ExercisesCubit.getInstance(context)
                        .exercisesList[index].isCustom,
                    video: ExercisesCubit.getInstance(context)
                        .exercisesList[index].video,
                    muscleName: muscleName,
                  );
                  context.normalNewRoute(
                    SpecificExercise(
                      exercise: exercise,
                    ),
                  );
                },
                child: ExercisesCard(
                    imageUrl: ExercisesCubit.getInstance(context).exercisesList[index].image[0],
                    title: ExercisesCubit.getInstance(context).exercisesList[index].name,
                )
              ),
          separatorBuilder: (context, index) => SizedBox(
                height: 16.h,
              ),
          itemCount: ExercisesCubit.getInstance(context).exercisesList.length
      ),
    );
  }
}