import 'package:be_fit/constants.dart';
import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/data_types/make_plan.dart';
import 'package:be_fit/view_model/plan_creation/cubit.dart';
import 'package:be_fit/view_model/plan_creation/states.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'choose_exercises/choose_exercises.dart';

class ContinuePlanning extends StatefulWidget {
  String name;
  int? daysNumber;

  ContinuePlanning({super.key,
    required this.name,
    required this.daysNumber,
  });

  @override
  State<ContinuePlanning> createState() => _ContinuePlanningState();
}

class _ContinuePlanningState extends State<ContinuePlanning> {

  @override
  void initState() {
    PlanCreationCubit.getInstance(context).makeListForEachDay(widget.daysNumber);
    PlanCreationCubit.getInstance(context).initializingDaysCheckBox(widget.daysNumber!);
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
            padding: const EdgeInsets.all(8.0),
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        maintainState: false,
                                        builder: (context) => ChooseExercises(
                                          day: index + 1,
                                        ),
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
                              PlanCreationCubit.getInstance(context).lists['list${index+1}']!.length, (i)
                            {
                              return Dismissible(
                                background: Container(
                                  color: Colors.red,
                                  child: const Icon(Icons.delete,color: Colors.white,),
                                ),
                                key: ValueKey<Exercises>(PlanCreationCubit.getInstance(context).lists['list${index+1}']![i]),
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
                                              child: Image.network(PlanCreationCubit.getInstance(context).lists['list${index+1}']![i].image)),
                                        ),
                                      subtitle: MyText(
                                          text: PlanCreationCubit.getInstance(context).lists['list${index+1}']![i].name,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      trailing: MyText(
                                        text: '${PlanCreationCubit.getInstance(context).lists['list${index+1}']![i].reps!} X ${PlanCreationCubit.getInstance(context).lists['list${index+1}']![i].sets!}',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                onDismissed: (direction)
                                {
                                  PlanCreationCubit.getInstance(context).removeFromPlanExercises(
                                      index + 1,
                                      PlanCreationCubit.getInstance(context).lists['list${index+1}']![i],
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
                    PlanCreationCubit.getInstance(context).lists.entries.every((element) => element.value.isEmpty)?
                    null : () async
                    {
                      await PlanCreationCubit.getInstance(context).createNewPlan(
                        context,
                        uId: CacheHelper.getInstance().uId,
                        makePlanModel: MakePlanModel(
                            daysNumber: widget.daysNumber,
                            name: widget.name,
                            uId: CacheHelper.getInstance().uId,
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/5),
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
