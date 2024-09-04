import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/widgets/exercises_card.dart';
import 'package:be_fit/models/widgets/invalid_connection_screen.dart';
import 'package:be_fit/view/cardio/specific_exercise.dart';
import 'package:be_fit/view_model/cardio/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../constants/constants.dart';
import '../../models/data_types/exercises.dart';
import '../../models/widgets/modules/myText.dart';
import '../../models/widgets/search_bar.dart';
import '../../view_model/cardio/states.dart';

class Cardio extends StatefulWidget {
  const Cardio({super.key});

  @override
  State<Cardio> createState() => _CardioState();
}

class _CardioState extends State<Cardio> {

  late TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController();
    CardioCubit.getInstance(context).getCardioExercises(context);
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
      body: BlocBuilder<CardioCubit, CardioStates>(
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
                onPressed: () => CardioCubit.getInstance(context).getCardioExercises(context)
              );
            }
          else{
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                children: [

                  AppSearchBar(
                    controller: controller,
                    onChanged: (pattern) => CardioCubit.getInstance(context).search(pattern),
                  ),

                  Column(
                    children: List.generate(
                      CardioCubit.getInstance(context).cardioExercisesList.length,
                          (index) => InkWell(
                        onTap: () {
                          Exercises exercise = Exercises(
                            name: CardioCubit.getInstance(context)
                                .cardioExercisesList[index].name,
                            docs: CardioCubit.getInstance(context)
                                .cardioExercisesList[index].docs,
                            id: CardioCubit.getInstance(context)
                                .cardioExercisesList[index].id,
                            image: CardioCubit.getInstance(context)
                                .cardioExercisesList[index].image,
                            isCustom: CardioCubit.getInstance(context)
                                .cardioExercisesList[index].isCustom,
                            video: CardioCubit.getInstance(context)
                                .cardioExercisesList[index].video,
                            muscleName: CardioCubit.getInstance(context)
                                .cardioExercisesList[index].muscleName,
                          );
                          context.normalNewRoute(
                              SpecificCardioExercise(exercise: exercise)
                          );
                        },
                        child: ExercisesCard(
                          imageUrl: CardioCubit.getInstance(context).cardioExercisesList[index].image[0],
                          title: CardioCubit.getInstance(context).cardioExercisesList[index].name,
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