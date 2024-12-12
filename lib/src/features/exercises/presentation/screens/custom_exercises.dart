import 'package:be_fit/src/core/extensions/container_decoration.dart';
import 'package:be_fit/src/core/extensions/mediaQuery.dart';
import 'package:be_fit/src/core/extensions/routes.dart';
import 'package:be_fit/src/features/exercises/presentation/blocs/exercises/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/app_widgets/app_dialog.dart';
import '../../../../core/helpers/app_widgets/exercises_card.dart';
import '../../../../core/helpers/app_widgets/specific_exercise/specific_exercise.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../../../../core/helpers/global_data_types/dialog_inputs.dart';
import '../../../../core/helpers/global_data_types/exercises.dart';
import '../../data/data_source/models/delete_custom_exercise.dart';
import 'create_exercise.dart';

class CustomExercisesScreen extends StatelessWidget {
  final String muscleName;
  final List<Exercises> customExercises;
  const CustomExercisesScreen({super.key,
    required this.muscleName,
    required this.customExercises
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (customExercises.isEmpty)
          Center(
            child: MyText(
                text: 'No Custom Exercises Yet',
                fontSize: 20.sp,
                fontWeight: FontWeight.w500),
          ),
        if (customExercises.isNotEmpty)
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Exercises exercise = Exercises(
                      name: customExercises[index].name,
                      docs: customExercises[index].docs,
                      id: customExercises[index].id,
                      image: customExercises[index].image,
                      isCustom: customExercises[index].isCustom,
                      video: customExercises[index].video,
                      muscleName: muscleName,
                    );
                    context.normalNewRoute(
                      SpecificExercise(
                        exercise: exercise,
                      ),
                    );
                  },
                  child: ExercisesCard(
                    imageUrl: customExercises[index].image[0],
                    title: customExercises[index].name,
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            onTap: () async {
                              AppDialog.show(
                                  context, inputs: DialogInputs(
                                title: 'Are you sure to delete ${customExercises[index].name} ?',
                                confirmButtonText: 'Delete',
                                onTapConfirm: ()async => await context.read<ExercisesCubit>().deleteCustomExercise(
                                    DeleteCustomExercise(
                                      muscleName: muscleName,
                                      exercise: customExercises[index],
                                    )),
                              ));

                            },
                            child: MyText(text: 'Delete', fontSize: 16.sp),
                          ),
                        ];
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  )
              ),
              separatorBuilder: (context, index) => SizedBox(
                height: 16.h,
              ),
              itemCount: customExercises.length),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: InkWell(
            onTap: () => context.normalNewRoute(
              CreateExercise(
                muscleName: muscleName,
              ),
            ),
            child: Container(
              width: context.setWidth(1.2),
              height: 40.h,
              decoration: BoxDecoration(
                border: context.decoration(),
              ),
              child: const Center(child: Icon(Icons.add)),
            ),
          ),
        )
      ],
    );
  }
}