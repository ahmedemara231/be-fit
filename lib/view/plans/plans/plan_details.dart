import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/widgets/modules/image.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view/plans/plans/every_day_exercises.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlanDetails extends StatefulWidget {
  const PlanDetails({super.key});

  @override
  State<PlanDetails> createState() => _PlanDetailsState();
}

class _PlanDetailsState extends State<PlanDetails> {
  late PlansCubit plansCubit;

  @override
  void initState() {
    plansCubit = PlansCubit.getInstance(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlansCubit, PlansStates>(
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
                          child: Card(
                            color: Constants.appColor,
                            child: ListTile(
                              title: MyText(
                                text: (plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']] as Map).keys.toList()[index],
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              trailing: MyText(
                                text: '${plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]['list${index + 1}']?.length} exercises',
                                fontSize: 20.sp,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0.r),
                          child: Column(
                            children: List.generate(
                              (plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]
                                      ['list${index + 1}'] as List<Exercises>).length,
                              (i) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: context.decoration()
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0.r),
                                    child: ListTile(
                                      leading: Padding(
                                        padding: EdgeInsets.all(10.0.r),
                                        child: Container(
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            width: 60.w,
                                            height: 60.h,
                                            child: MyNetworkImage(
                                              url: plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]
                                                      ['list${index + 1}']![i].image[0] as String,
                                            )),
                                      ),
                                      subtitle: MyText(
                                          text: '${plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]['list${index + 1}']![i].name}',
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500
                                      ),
                                      trailing: Column(
                                        children: [
                                          FittedBox(
                                            child: MyText(
                                                text: 'Sets X Reps',
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(height: 7.h),
                                          MyText(
                                              text: '${plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]['list${index + 1}']![i].sets} X ${plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]['list${index + 1}']![i].reps}',
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                itemCount: (plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']] as Map).keys.toList().length
            ),
          ),
        );
      },
    );
  }
}