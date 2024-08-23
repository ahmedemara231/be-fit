import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/data_types/make_plan.dart';
import 'package:be_fit/view/BottomNavBar/bottom_nav_bar.dart';
import 'package:be_fit/view_model/plan_creation/cubit.dart';
import 'package:be_fit/view_model/plan_creation/states.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'choose_exercises/choose_exercises.dart';

class ContinuePlanning extends StatefulWidget {
  final String name;
  final int? daysNumber;

  const ContinuePlanning({super.key,
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
    planCreationCubit.makeListForEachDay(widget.daysNumber);
    planCreationCubit.finishGettingMuscles(context, day: widget.daysNumber!);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanCreationCubit,PlanCreationStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => Column(
                      children: [
                        Card(
                          color: Constants.appColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                                leading: MyText(
                                  text: 'Day ${index + 1}',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                trailing: IconButton(
                                  onPressed: ()
                                  {
                                    context.normalNewRoute(
                                      ChooseExercises(
                                        day: index + 1,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: List.generate(
                              planCreationCubit.lists['list${index+1}']!.length, (i)
                            {
                              return Dismissible(
                                background: Container(
                                  color: Colors.red,
                                  child: const Icon(Icons.delete,color: Colors.white,),
                                ),
                                key: ValueKey<Exercises>(planCreationCubit.lists['list${index+1}']![i]),
                                child: Padding(
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
                                            child: SizedBox(
                                                width: 80,
                                                height: 80,
                                                child: Image.network(planCreationCubit.lists['list${index+1}']![i].image[0])),
                                          ),
                                        subtitle: MyText(
                                            text: planCreationCubit.lists['list${index+1}']![i].name,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        trailing: Column(
                                          children: [
                                            FittedBox(
                                              child: MyText(
                                                text: 'Sets X Reps',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 7),
                                            MyText(
                                              text: '${planCreationCubit.lists['list${index+1}']![i].sets!} X ${planCreationCubit.lists['list${index+1}']![i].reps!}',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                onDismissed: (direction)
                                {
                                  planCreationCubit.removeFromPlanExercises(
                                      index + 1,
                                      planCreationCubit.lists['list${index+1}']![i],
                                  );
                                },
                              );
                             }
                            ),
                          ),
                        ),
                      ],
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                    itemCount: widget.daysNumber!,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400]
                    ),
                    onPressed: state is CreateNewPlanLoadingState? ||
                    planCreationCubit.lists.entries.every((element) => element.value.isEmpty)?
                    null : () async
                    {
                      await planCreationCubit.createPlan(
                          context,
                          MakePlanModel(
                              daysNumber: widget.daysNumber,
                              name: widget.name,
                              lists: planCreationCubit.lists
                          )
                      ).whenComplete(()async {
                        context.removeOldRoute(const BottomNavBar());
                        await PlansCubit.getInstance(context).getAllPlans(context);
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.setWidth(5)),
                      child: MyText(
                        text: 'Create Plan',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
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
