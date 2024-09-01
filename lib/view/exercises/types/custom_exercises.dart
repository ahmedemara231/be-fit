import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/model/remote/repositories/exercises/implementation.dart';
import 'package:be_fit/models/data_types/delete_custom_exercise.dart';
import 'package:be_fit/models/widgets/modules/image.dart';
import 'package:flutter/material.dart';
import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/widgets/specificExercise/specific_exercise.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import '../../../models/widgets/specific_exercise_widgets/stream.dart';
import '../../createExercise/create_exercise.dart';

class CustomExercisesScreen extends StatelessWidget {

  final String muscleName;
  const CustomExercisesScreen({super.key,
    required this.muscleName
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Constants.appColor,
      onRefresh: () async{
        ExercisesCubit.getInstance(context).getExercises(
          context,
          exercisesType: CustomExercisesImpl(),
          muscleName: muscleName,
        );
        return Future(() => null);
      },
      child: Column(
        children: [
          if(ExercisesCubit.getInstance(context).customExercisesList.isEmpty)
            Center(
              child: MyText(text: 'No Custom Exercises Yet',fontSize: 20,fontWeight: FontWeight.w500),
            ),
          if(ExercisesCubit.getInstance(context).customExercisesList.isNotEmpty)
            ListView.separated(
                shrinkWrap:  true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Exercises exercise = Exercises(
                      name: ExercisesCubit.getInstance(context).customExercisesList[index].name,
                      docs: ExercisesCubit.getInstance(context).customExercisesList[index].docs,
                      id: ExercisesCubit.getInstance(context).customExercisesList[index].id,
                      image: ExercisesCubit.getInstance(context).customExercisesList[index].image,
                      isCustom: ExercisesCubit.getInstance(context).customExercisesList[index].isCustom,
                      video: ExercisesCubit.getInstance(context).customExercisesList[index].video,
                      muscleName: muscleName,
                    );
                    context.normalNewRoute(
                      SpecificExercise(
                        exercise: exercise,
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: MyNetworkImage(
                            url: ExercisesCubit.getInstance(context).customExercisesList[index].image[0]
                        ),
                        title: MyText(
                          text: ExercisesCubit.getInstance(context).customExercisesList[index].name,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                onTap: () async {
                                  await ExercisesCubit.getInstance(context).deleteCustomExercise(
                                    exerciseType: CustomExercisesImpl(),
                                    context,
                                    inputs: DeleteCustomExercise(
                                      muscleName: muscleName,
                                      exercise: ExercisesCubit.getInstance(context).customExercisesList[index],
                                    )
                                  );
                                },
                                child: MyText(
                                    text: 'Delete',
                                    fontSize: 16
                                ),
                              ),
                            ];
                          },
                          icon: const Icon(Icons.menu),
                        ),
                      ),
                    ),
                  ),
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 16,),
                itemCount: ExercisesCubit.getInstance(context).customExercisesList.length
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: InkWell(
              onTap: () {
                context.normalNewRoute(
                  CreateExercise(
                    muscleName: muscleName,
                  ),
                );
              },
              child: Container(
                width: context.setWidth(1.2),
                height: 40,
                decoration: BoxDecoration(
                  border: context.decoration(),
                ),
                child: const Center(
                    child: Icon(Icons.add)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
