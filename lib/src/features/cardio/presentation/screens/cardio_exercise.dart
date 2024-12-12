import 'package:be_fit/src/core/extensions/routes.dart';
import 'package:be_fit/src/features/cardio/presentation/bloc/cardio_cubit.dart';
import 'package:be_fit/src/features/cardio/presentation/bloc/cardio_cubit.dart';
import 'package:be_fit/src/features/cardio/presentation/bloc/cardio_cubit.dart';
import 'package:be_fit/src/features/cardio/presentation/bloc/cardio_cubit.dart';
import 'package:be_fit/src/features/cardio/presentation/bloc/cardio_cubit.dart';
import 'package:be_fit/src/features/cardio/presentation/bloc/cardio_cubit.dart';
import 'package:be_fit/src/features/cardio/presentation/screens/specific_exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helpers/app_widgets/exercises_card.dart';
import '../../../../core/helpers/app_widgets/invalid_connection_screen.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../../../../core/helpers/global_data_types/exercises.dart';


class Cardio extends StatefulWidget {
  const Cardio({super.key});
  @override
  State<Cardio> createState() => _CardioState();
}

class _CardioState extends State<Cardio> {

  late TextEditingController controller;
  late final NewCardioCubit cardioCubit;
  @override
  void initState() {
    cardioCubit = context.read<NewCardioCubit>();
    controller = TextEditingController();
    context.read<NewCardioCubit>().getCardioExercises();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          text: 'Cardio Section',
          fontWeight: FontWeight.w500,
        ),

      ),
      body: BlocBuilder<NewCardioCubit, CardioStates>(
        builder: (context, state)
        {
          if(state is GetCardioExercisesLoading)
            {
              return Center(
                child: SpinKitCircle(
                  color: Constants.appColor,
                  size: 50.0,
                ),
              );
            }
          else if(state is GetCardioExercisesError)
            {
              return ErrorBuilder(
                msg: 'Try Again Later',
                onPressed: () => context.read<NewCardioCubit>().getCardioExercises()
              );
            }
          else{
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                children: [
                  // AppSearchBar(
                  //   controller: controller,
                  //   onChanged: (pattern) => context.read<NewCardioCubit>().search(pattern),
                  // ),

                  Column(
                    children: List.generate(
                      cardioCubit.cardioExercisesList.length,
                          (index) => InkWell(
                        onTap: () {
                          Exercises exercise = Exercises(
                            name: cardioCubit.cardioExercisesList[index].name,
                            docs: cardioCubit.cardioExercisesList[index].docs,
                            id: cardioCubit.cardioExercisesList[index].id,
                            image: cardioCubit.cardioExercisesList[index].image,
                            isCustom: cardioCubit.cardioExercisesList[index].isCustom,
                            video: cardioCubit.cardioExercisesList[index].video,
                            muscleName: cardioCubit.cardioExercisesList[index].muscleName,
                          );
                          context.normalNewRoute(
                              SpecificCardioExercise(exercise: exercise)
                          );
                        },
                        child: ExercisesCard(
                          imageUrl: cardioCubit.cardioExercisesList[index].image[0],
                          title: cardioCubit.cardioExercisesList[index].name,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
      ),
    );
  }
}