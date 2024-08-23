import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view/plans/plans/every_day_exercises.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/constants.dart';

class PlanDetails extends StatefulWidget {

  const PlanDetails({super.key});

  @override
  State<PlanDetails> createState() => _PlanDetailsState();
}
class _PlanDetailsState extends State<PlanDetails> {
  late PlansCubit plansCubit;
  late Map<String, List<Exercises>> currentPlan;
  late List<String> planLists;

  @override
  void initState() {
    plansCubit = PlansCubit.getInstance(context);
    currentPlan = plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']] as Map<String,List<Exercises>>;
    planLists = currentPlan.keys.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlansCubit,PlansStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: plansCubit.roadToPlanExercise['planName']),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
                itemBuilder: (context, index) => Column(
                  children: [
                    InkWell(
                      onTap: ()
                      {
                        plansCubit.roadToPlanExercise['listIndex'] = index + 1;
                        context.normalNewRoute(
                          const DayExercises(),
                        );
                      },
                      child: Card(
                        color: Constants.appColor,
                        child: ListTile(
                          title: MyText(
                            text: planLists[index],
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          trailing: MyText(
                            text: '${plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]['list${index+1}']?.length} exercises',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: List.generate(
                          (plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]['list${index+1}'] as List<Exercises>).length,
                              (i) =>  Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: context.decoration()
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ListTile(
                                  leading: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                        width: 80,
                                        height: 80,
                                        child: Image.network(
                                          plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]['list${index+1}']![i].image[0] as String,
                                          errorBuilder: (context, error, stackTrace) => MyText(
                                            text: 'Failed to load image',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                    ),
                                  ),
                                  subtitle: MyText(
                                      text: '${plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]['list${index+1}']![i].name}',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                  ),
                                trailing: Column(
                                  children: [
                                    FittedBox(
                                      child: MyText(
                                          text: 'Sets X Reps',
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    MyText(
                                        text: '${plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]['list${index+1}']![i].sets} X ${plansCubit.allPlans[plansCubit.roadToPlanExercise['planName']]['list${index+1}']![i].reps}',
                                        fontSize: 16,
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
                separatorBuilder: (context, index) => const SizedBox(height: 16,),
                itemCount: planLists.length
            ),
          ),
        );
      },
    );
  }
}