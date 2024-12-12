import 'package:be_fit/src/core/extensions/routes.dart';
import 'package:be_fit/src/features/plans/presentation/bloc/state.dart';
import 'package:be_fit/src/features/plans/presentation/widgets/days_card.dart';
import 'package:be_fit/src/features/plans/presentation/widgets/days_exercises.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../../../../core/helpers/global_data_types/exercises.dart';
import '../bloc/cubit.dart';
import 'every_day_exercises.dart';

class PlanDetails extends StatefulWidget {
  const PlanDetails({super.key});

  @override
  State<PlanDetails> createState() => _PlanDetailsState();
}

class _PlanDetailsState extends State<PlanDetails> {
  late final PlansCubit plansCubit;

  @override
  void initState() {
    plansCubit = context.read<PlansCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlansCubit, PlansState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: plansCubit.roadToPlanExercise['planName']),
          ),
          body: Padding(
            padding: EdgeInsets.all(8.0.r),
            child: ListView.separated(
                itemBuilder: (context, index) => Column(
                      children: [
                        InkWell(
                          onTap: () {
                            plansCubit.roadToPlanExercise['listIndex'] = index + 1;
                            context.normalNewRoute(
                              const DayExercises(),
                            );
                          },
                          child: DaysCard(
                              firstText: (state.allPlans?[plansCubit.roadToPlanExercise['planName']] as Map).keys.toList()[index],
                              secondText: '${state.allPlans?[plansCubit.roadToPlanExercise['planName']]['list${index + 1}']?.length} exercises',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0.r),
                          child: Column(
                            children: List.generate(
                              (state.allPlans?[plansCubit.roadToPlanExercise['planName']]
                                      ['list${index + 1}'] as List<Exercises>).length,
                              (i) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: DaysExercises(
                                    imageUrl: state.allPlans?[plansCubit.roadToPlanExercise['planName']]
                                    ['list${index + 1}']![i].image[0] as String,
                                    exerciseName: '${state.allPlans?[plansCubit.roadToPlanExercise['planName']]['list${index + 1}']![i].name}',
                                    setsAndReps: '${state.allPlans?[plansCubit.roadToPlanExercise['planName']]['list${index + 1}']![i].sets} X ${state.allPlans?[plansCubit.roadToPlanExercise['planName']]['list${index + 1}']![i].reps}',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                separatorBuilder: (context, index) => SizedBox(
                      height: 16.h,
                    ),
                itemCount: (state.allPlans?[plansCubit.roadToPlanExercise['planName']] as Map).keys.toList().length
            ),
          ),
        );
      },
    );
  }
}