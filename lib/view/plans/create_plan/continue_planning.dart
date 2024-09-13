import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/data_types/make_plan.dart';
import 'package:be_fit/models/widgets/modules/image.dart';
import 'package:be_fit/view/BottomNavBar/bottom_nav_bar.dart';
import 'package:be_fit/view_model/plan_creation/cubit.dart';
import 'package:be_fit/view_model/plan_creation/states.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'choose_exercises/choose_exercises.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  late PlanCreationCubit planCreationCubit;

  @override
  void initState() {
    planCreationCubit = PlanCreationCubit.getInstance(context);
    if(widget.name != 'Beginner Plan')
      {
        planCreationCubit.finishGettingMuscles(context, day: widget.daysNumber!);
      }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanCreationCubit, PlanCreationStates>(
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
                        Card(
                          color: Constants.appColor,
                          child: Padding(
                            padding:  EdgeInsets.all(8.0.r),
                            child: ListTile(
                                leading: MyText(
                                  text: 'Day ${index + 1}',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    context.normalNewRoute(
                                      ChooseExercises(
                                        day: index + 1,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                )),
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.all(10.0.r),
                          child: Column(
                            children: List.generate(
                                planCreationCubit
                                    .lists['list${index + 1}']!.length, (i) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: context.decoration()),
                                  child: Padding(
                                    padding:  EdgeInsets.all(10.0.r),
                                    child: ListTile(
                                      leading: Padding(
                                          padding:
                                               EdgeInsets.all(10.0.r),
                                          child: SizedBox(
                                              width: 80.w,
                                              height: 80.h,
                                              child: MyNetworkImage(
                                                  url: planCreationCubit
                                                      .lists[
                                                          'list${index + 1}']![i]
                                                      .image[0]))),
                                      subtitle: MyText(
                                        text: planCreationCubit
                                            .lists['list${index + 1}']![i]
                                            .name,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      trailing: FittedBox(
                                        child: Column(
                                          children: [
                                            MyText(
                                              text: 'Sets X Reps',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.sp,
                                            ),
                                            SizedBox(height: 7.h),
                                            MyText(
                                              text:
                                                  '${planCreationCubit.lists['list${index + 1}']![i].sets} X ${planCreationCubit.lists['list${index + 1}']![i].reps}',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.sp,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400]),
                    onPressed: state is CreateNewPlanLoadingState? ||
                            planCreationCubit.lists.entries
                                .every((element) => element.value.isEmpty)
                        ? null
                        : () async {
                            await planCreationCubit
                                .createPlan(
                                    context,
                                    MakePlanModel(
                                        daysNumber: widget.daysNumber,
                                        name: widget.name,
                                        lists: planCreationCubit.lists))
                                .whenComplete(() async {
                              context.removeOldRoute(const BottomNavBar());
                              await PlansCubit.getInstance(context)
                                  .getAllPlans(context);
                            });
                          },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: context.setWidth(5)),
                      child: MyText(
                        text: 'Create Plan',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}