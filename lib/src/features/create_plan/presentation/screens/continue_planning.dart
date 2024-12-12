import 'package:be_fit/src/core/extensions/container_decoration.dart';
import 'package:be_fit/src/core/extensions/routes.dart';
import 'package:be_fit/src/core/helpers/app_widgets/app_button.dart';
import 'package:be_fit/src/features/create_plan/presentation/bloc/state.dart';
import 'package:be_fit/src/features/create_plan/presentation/widgets/choosen_exercises.dart';
import 'package:be_fit/src/features/create_plan/presentation/widgets/day_card.dart';
import 'package:be_fit/src/features/plans/presentation/bloc/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../../../bottom_bar/presentation/bottom_nav_bar.dart';
import '../../data/data_source/models/make_plan.dart';
import '../bloc/cubit.dart';

class ContinuePlanning extends StatefulWidget {
  final String name;
  final int? daysNumber;

  const ContinuePlanning({
    super.key,
    required this.name,
    required this.daysNumber,
  });

  @override
  State<ContinuePlanning> createState() => _ContinuePlanningState();
}

class _ContinuePlanningState extends State<ContinuePlanning> {

  @override
  void initState() {
    if(widget.name != 'Beginner Plan') {
        context.read<PlanCreationCubit>()
            .prepareExercisesAndDaysToMakePlan(widget.daysNumber!);
      }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlanCreationCubit, CreatePlanState>(
      listener: (context, state) {
        switch(state.currentState){
          case CreatePlanInternalStates.createPlanForBeginnersLoading:
            EasyLoading.show(status: 'loading...');

          case CreatePlanInternalStates.createPlanForBeginnersSuccess:
            EasyLoading.dismiss();

          case CreatePlanInternalStates.createPlanSuccess:
            context.removeOldRoute(const BottomNavBar());
            context.read<PlansCubit>().getAllPlans();

          default: return;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: widget.name,fontSize: 20.sp,),
          ),
          body: Padding(
            padding:  EdgeInsets.all(5.0.r),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => Column(
                      children: [
                        DayCard(index: index),
                        Padding(
                          padding:  EdgeInsets.all(10.0.r),
                          child: Column(
                            children: List.generate(
                                state.lists!['list${index + 1}']!.length, (i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(border: context.decoration()),
                                  child: Padding(
                                    padding:  EdgeInsets.all(10.0.r),
                                    child: ChosenExercises(
                                        imageUrl: state.lists!['list${index + 1}']![i].image[0],
                                        exerciseName: state.lists!['list${index + 1}']![i].name,
                                        setsAndReps: '${state.lists!['list${index + 1}']![i].sets} X ${state.lists!['list${index + 1}']![i].reps}'
                                    )
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 16.h,
                    ),
                    itemCount: widget.daysNumber!,
                  ),
                ),
                AppButton(
                  text: 'Create Plan',
                  onPressed: state.currentState == CreatePlanInternalStates.createPlanLoading ||
                      state.lists!.entries.any((element) => element.value.isEmpty)?
                  null : () async {
                    await context.read<PlanCreationCubit>().createPlan(
                        MakePlanModel(
                            daysNumber: widget.daysNumber,
                            name: widget.name,
                            lists: state.lists!
                        )
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}