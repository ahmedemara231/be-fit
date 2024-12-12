import 'dart:developer';
import 'package:be_fit/src/core/extensions/routes.dart';
import 'package:be_fit/src/features/create_plan/presentation/bloc/cubit.dart';
import 'package:be_fit/src/features/plans/presentation/bloc/state.dart';
import 'package:be_fit/src/features/plans/presentation/widgets/exercise_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helpers/app_widgets/specific_exercise/specific_exercise.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../../../../core/helpers/base_widgets/toast.dart';
import '../../../../core/helpers/global_data_types/dialog_inputs.dart';
import '../../../../core/helpers/global_data_types/exercises.dart';
import '../../../create_plan/presentation/screens/choose_exercises.dart';
import '../../data/data_source/models/delete_exercise_from_plan.dart';
import '../bloc/cubit.dart';

class DayExercises extends StatefulWidget {
  const DayExercises({super.key});

  @override
  State<DayExercises> createState() => _DayExercisesState();
}

class _DayExercisesState extends State<DayExercises> {
  late final PlansCubit plansCubit;
  @override
  void initState() {
    plansCubit = context.read<PlansCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
            text: 'Day ${plansCubit.roadToPlanExercise['listIndex']} exercises'
        ),
        actions: [
          IconButton(
              onPressed: () {
                context.read<PlanCreationCubit>().prepareExercisesAndDaysToMakePlan(1);
                context.normalNewRoute(const ChooseExercises(day: 1, isExist: true));
              },
              icon: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Image.asset('images/add_exercises_btn.png'))
          )
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.all(8.0.r),
        child: BlocConsumer<PlansCubit, PlansState>(
            listener: (context, state) {
              if(state.currentState == PlansInternalStates.addExercisesToExistingPlanSuccess){
                MyToast.showToast(
                    context,
                    msg: 'Added!',
                    color: Constants.appColor
                );
              }else if(state.currentState == PlansInternalStates.deleteExerciseFromPlanSuccess &&
                  (state.allPlans?[plansCubit.roadToPlanExercise['planName']]['list${plansCubit.roadToPlanExercise['listIndex']}'] as List<Exercises>).isEmpty){
                log('if');
                Navigator.pop(context);
              }
            },
            builder: (context, state) => ListView.separated(
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Exercises exercise = state.allPlans?[plansCubit.roadToPlanExercise['planName']]
                  ['list${plansCubit.roadToPlanExercise['listIndex']}'][index];
                  context.normalNewRoute(
                      SpecificExercise(
                        exercise: exercise,
                      )
                  );
                },
                child: ExerciseCard(
                    imgUrl: (state.allPlans?[plansCubit.roadToPlanExercise['planName']]
                    ['list${plansCubit.roadToPlanExercise['listIndex']}'][index] as Exercises).image[0],
                    exerciseName: (state.allPlans?[plansCubit.roadToPlanExercise['planName']]
                                ['list${plansCubit.roadToPlanExercise['listIndex']}'][index] as Exercises).name,
                    inputs: DialogInputs(
                            title: 'Are you sure to delete ${(state.allPlans?[plansCubit.roadToPlanExercise['planName']]['list${plansCubit.roadToPlanExercise['listIndex']}'][index] as Exercises).name} From ${plansCubit.roadToPlanExercise['planName']} ?',
                            confirmButtonText: 'Delete',
                            onTapConfirm: () async =>
                            await plansCubit.deleteExerciseFromPlan(
                              inputs: DeleteFromPlanModel(
                                exerciseIndex: index,
                                planName: plansCubit.roadToPlanExercise['planName'],
                                planDoc: plansCubit.roadToPlanExercise['planDoc'],
                                listIndex: plansCubit.roadToPlanExercise['listIndex'],
                                exerciseDoc: (state.allPlans?[plansCubit.roadToPlanExercise['planName']]
                                ['list${plansCubit.roadToPlanExercise['listIndex']}'][index] as Exercises).id,
                              ),
                            ))
                ),
              ),
              separatorBuilder: (context, index) => SizedBox(
                height: 16.h,
              ),
              itemCount: (state.allPlans?[plansCubit.roadToPlanExercise['planName']]
              ['list${plansCubit.roadToPlanExercise['listIndex']}'] as List<Exercises>).length,
            ),
        ),
      ),
    );
  }
}