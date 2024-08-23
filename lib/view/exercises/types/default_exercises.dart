import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/model/remote/repositories/exercises/implementation.dart';
import 'package:be_fit/view/specificExercise/stream.dart';
import 'package:flutter/material.dart';
import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/widgets/specific_exercise.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';

class DefaultExercises extends StatelessWidget {

  final String muscleName;
  const DefaultExercises({super.key,
    required this.muscleName
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Constants.appColor,
      color: Colors.white,
      onRefresh: () {
        ExercisesCubit.getInstance(context).getExercises(
          context,
          exercisesType: DefaultExercisesImpl.getInstance(),
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
                name: ExercisesCubit.getInstance(context).exercisesList[index].name,
                docs: ExercisesCubit.getInstance(context).exercisesList[index].docs,
                id: ExercisesCubit.getInstance(context).exercisesList[index].id,
                image: ExercisesCubit.getInstance(context).exercisesList[index].image,
                isCustom: ExercisesCubit.getInstance(context).exercisesList[index].isCustom,
                video: ExercisesCubit.getInstance(context).exercisesList[index].video,
                muscleName: muscleName,
              );
              context.normalNewRoute(
                SpecificExercise(
                  exercise: exercise,
                  stream: MyStream(exercise: exercise),
                ),
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Image.network(
                      ExercisesCubit.getInstance(context).exercisesList[index].image[0],
                      errorBuilder: (context, error, stackTrace) => MyText(
                        text: 'Failed to load image',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: MyText(
                    text: ExercisesCubit.getInstance(context).exercisesList[index].name,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  trailing:
                  const Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ),
          separatorBuilder: (context, index) =>
          const SizedBox(
            height: 16,
          ),
          itemCount: ExercisesCubit.getInstance(context).exercisesList.length),
    );
  }
}
