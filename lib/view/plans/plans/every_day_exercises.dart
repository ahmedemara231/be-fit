import 'package:be_fit/constants.dart';
import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/models/data_types/delete_exercise_from_plan.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/data_types/exercises.dart';
import '../../../view_model/plans/cubit.dart';
import 'exercise_details.dart';

class DayExercises extends StatelessWidget {

  String planName;
  int listIndex;

  String planDoc;

  DayExercises({super.key,
    required this.planName,
    required this.listIndex,
    required this.planDoc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlansCubit,PlansStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Day$listIndex exercises',),
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
                            deleteFromPlanModel: DeleteFromPlanModel(
                              exerciseIndex: index,
                              planName: planName,
                              uId: CacheHelper.getInstance().uId,
                              planDoc: planDoc,
                              listIndex: listIndex,
                              exerciseDoc: (PlansCubit.getInstance(context).allPlans[planName]['list$listIndex'][index] as Exercises).id,
                            ),
                          );
                        },
                      )
                    ],
                  );
                },
                onTap: ()
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlanExerciseDetails(
                        planDoc: planDoc,
                        listIndex: listIndex,
                        exercise: PlansCubit.getInstance(context).allPlans[planName]['list$listIndex'][index]
                      ),
                    ),
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
                          (PlansCubit.getInstance(context).allPlans[planName]['list$listIndex'][index] as Exercises).image,
                          errorBuilder: (context, error, stackTrace) => MyText(
                            text: 'Failed to load image',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: MyText(
                        text: (PlansCubit.getInstance(context).allPlans[planName]['list$listIndex'][index] as Exercises).name,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 16,),
              itemCount: (PlansCubit.getInstance(context).allPlans[planName]['list$listIndex'] as List<Exercises>).length,
            ),
          ),
        );
      },
    );
  }
}
