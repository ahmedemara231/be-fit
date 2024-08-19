import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/data_types/delete_exercise_from_plan.dart';
import 'package:be_fit/view/plans/plans/specific_exercise/stream.dart';
import 'package:be_fit/view/specificExercise/specific_exercise.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/local/cache_helper/shared_prefs.dart';
import '../../../models/data_types/exercises.dart';
import '../../../view_model/plans/cubit.dart';
import 'specific_exercise/exercise_details.dart';

class DayExercises extends StatefulWidget {

  const DayExercises({super.key});

  @override
  State<DayExercises> createState() => _DayExercisesState();
}

class _DayExercisesState extends State<DayExercises> {
  // planName: PlansCubit.getInstance(context).roadToPlanExercise['planName'],

  late PlansCubit plansCubit;
  @override
  void initState() {
    plansCubit = PlansCubit.getInstance(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlansCubit,PlansStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Day${plansCubit.roadToPlanExercise['listIndex']} exercises',),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemBuilder: (context, index) => InkWell(
                onLongPress: ()
                {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromDirectional(
                      textDirection: TextDirection.ltr,
                      start: 50,
                      top: 20,
                      end: 50,
                      bottom: 20,
                    ),
                    items: [
                      PopupMenuItem(
                        child: MyText(text: 'Delete'),
                        onTap: () async
                        {
                          await PlansCubit.getInstance(context).deleteExerciseFromPlan(
                            context,
                            inputs: DeleteFromPlanModel(
                              exerciseIndex: index,
                              planName: plansCubit.roadToPlanExercise['planName'],
                              planDoc: plansCubit.roadToPlanExercise['planDoc'],
                              listIndex: plansCubit.roadToPlanExercise['listIndex'],
                              exerciseDoc: (PlansCubit.getInstance(context).allPlans[plansCubit.roadToPlanExercise['planName']]['list${plansCubit.roadToPlanExercise['listIndex']}'][index] as Exercises).id,
                            ),
                          );
                        },
                      )
                    ],
                  );
                },
                onTap: ()
                {
                  Exercises exercise = PlansCubit.getInstance(context).allPlans[plansCubit.roadToPlanExercise['planName']]['list${plansCubit.roadToPlanExercise['listIndex']}'][index];
                  context.normalNewRoute(
                    SpecificExercise(
                        exercise: exercise,
                        stream: MyPlanStream(
                            exercise: exercise,
                            planDoc: plansCubit.roadToPlanExercise['planDoc'],
                            listIndex: plansCubit.roadToPlanExercise['listIndex']
                        )
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
                        child: Image.network(
                          (PlansCubit.getInstance(context).allPlans[plansCubit.roadToPlanExercise['planName']]['list${plansCubit.roadToPlanExercise['listIndex']}'][index] as Exercises).image[0],
                          errorBuilder: (context, error, stackTrace) => MyText(
                            text: 'Failed to load image',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: MyText(
                        text: (PlansCubit.getInstance(context).allPlans[plansCubit.roadToPlanExercise['planName']]['list${plansCubit.roadToPlanExercise['listIndex']}'][index] as Exercises).name,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 16,),
              itemCount: (PlansCubit.getInstance(context).allPlans[plansCubit.roadToPlanExercise['planName']]['list${plansCubit.roadToPlanExercise['listIndex']}'] as List<Exercises>).length,
            ),
          ),
        );
      },
    );
  }
}
