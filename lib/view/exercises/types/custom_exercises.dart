import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/data_types/delete_custom_exercise.dart';
import 'package:be_fit/models/data_types/dialog_inputs.dart';
import 'package:be_fit/models/widgets/app_dialog.dart';
import 'package:be_fit/models/widgets/exercises_card.dart';
import 'package:flutter/material.dart';
import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/widgets/specificExercise/specific_exercise.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../model/remote/firebase_service/fire_store/exercises/implementation.dart';
import '../../createExercise/create_exercise.dart';

class CustomExercisesScreen extends StatelessWidget {
  final String muscleName;
  const CustomExercisesScreen({super.key, required this.muscleName});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Constants.appColor,
      onRefresh: () async {
        ExercisesCubit.getInstance(context).getExercises(
          context,
          exercisesType: CustomExercisesImpl(),
          muscleName: muscleName,
        );
        return Future(() => null);
      },
      child: Column(
        children: [
          if (ExercisesCubit.getInstance(context).customExercisesList.isEmpty)
            Center(
              child: MyText(
                  text: 'No Custom Exercises Yet',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500),
            ),
          if (ExercisesCubit.getInstance(context).customExercisesList.isNotEmpty)
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Exercises exercise = Exercises(
                          name: ExercisesCubit.getInstance(context)
                              .customExercisesList[index].name,
                          docs: ExercisesCubit.getInstance(context)
                              .customExercisesList[index]
                              .docs,
                          id: ExercisesCubit.getInstance(context)
                              .customExercisesList[index]
                              .id,
                          image: ExercisesCubit.getInstance(context)
                              .customExercisesList[index]
                              .image,
                          isCustom: ExercisesCubit.getInstance(context)
                              .customExercisesList[index]
                              .isCustom,
                          video: ExercisesCubit.getInstance(context)
                              .customExercisesList[index]
                              .video,
                          muscleName: muscleName,
                        );
                        context.normalNewRoute(
                          SpecificExercise(
                            exercise: exercise,
                          ),
                        );
                      },
                      child: ExercisesCard(
                        imageUrl: ExercisesCubit.getInstance(context)
                            .customExercisesList[index].image[0],
                        title: ExercisesCubit.getInstance(context)
                            .customExercisesList[index].name,
                        trailing: PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                onTap: () async {
                                  AppDialog.showAppDialog(
                                      context, inputs: DialogInputs(
                                      title: 'Are you sure to delete ${ExercisesCubit.getInstance(context).customExercisesList[index].name} ?',
                                      confirmButtonText: 'Delete',
                                      onTapConfirm: ()async => await ExercisesCubit.getInstance(context).deleteCustomExercise(
                                      exerciseType: CustomExercisesImpl(),
                                      context,
                                      inputs: DeleteCustomExercise(
                                        muscleName: muscleName,
                                        exercise: ExercisesCubit.getInstance(context).customExercisesList[index],
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
                itemCount: ExercisesCubit.getInstance(context)
                    .customExercisesList
                    .length),
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
                height: 40.h,
                decoration: BoxDecoration(
                  border: context.decoration(),
                ),
                child: const Center(child: Icon(Icons.add)),
              ),
            ),
          )
        ],
      ),
    );
  }
}