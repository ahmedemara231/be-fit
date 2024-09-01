import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/data_types/delete_exercise_from_plan.dart';
import 'package:be_fit/models/widgets/modules/image.dart';
import 'package:be_fit/models/widgets/specificExercise/specific_exercise.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:flutter/material.dart';
import '../../../models/data_types/dialog_inputs.dart';
import '../../../models/data_types/exercises.dart';
import '../../../models/widgets/app_dialog.dart';
import '../../../view_model/plans/cubit.dart';

class DayExercises extends StatefulWidget {

  const DayExercises({super.key});

  @override
  State<DayExercises> createState() => _DayExercisesState();
}

class _DayExercisesState extends State<DayExercises> {

  late PlansCubit plansCubit;
  @override
  void initState() {
    plansCubit = PlansCubit.getInstance(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: 'Day ${plansCubit.roadToPlanExercise['listIndex']} exercises'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PlansCubit, PlansStates>(
          builder: (context, state) => ListView.separated(
            itemBuilder: (context, index) => InkWell(
              onTap: ()
              {
                Exercises exercise = plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]['list${plansCubit.roadToPlanExercise['listIndex']}'][index];
                context.normalNewRoute(
                    SpecificExercise(
                        exercise: exercise,
                    )
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    border: context.decoration()
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    leading: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: MyNetworkImage(
                        url:(plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]['list${plansCubit.roadToPlanExercise['listIndex']}'][index] as Exercises).image[0],
                      )
                    ),
                    title: MyText(
                      text: (plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]['list${plansCubit.roadToPlanExercise['listIndex']}'][index] as Exercises).name,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: MyText(text: 'Delete'),
                            onTap: () async
                            {
                              await AppDialog.showAppDialog(
                                  context,
                                  inputs: DialogInputs(
                                    title: 'Are you sure to delete ${(plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]['list${plansCubit.roadToPlanExercise['listIndex']}'][index] as Exercises).name} From ${plansCubit.roadToPlanExercise['planName']} ?',
                                    confirmButtonText: 'Delete',
                                    onTapConfirm: ()async => await plansCubit.deleteExerciseFromPlan(
                                      context,
                                      inputs: DeleteFromPlanModel(
                                        exerciseIndex: index,
                                        planName: plansCubit.roadToPlanExercise['planName'],
                                        planDoc: plansCubit.roadToPlanExercise['planDoc'],
                                        listIndex: plansCubit.roadToPlanExercise['listIndex'],
                                        exerciseDoc: (plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]['list${plansCubit.roadToPlanExercise['listIndex']}'][index] as Exercises).id,
                                      ),
                                    )
                                  )
                              );
                            },
                          )
                        ];
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  ),
                ),
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 16,),
            itemCount: (plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]['list${plansCubit.roadToPlanExercise['listIndex']}'] as List<Exercises>).length,
          ),
          buildWhen: (previous, current) => current is DeleteExerciseFromPlanSuccessState
        ),
      ),
    );
  }
}
