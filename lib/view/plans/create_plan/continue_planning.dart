import 'package:be_fit/models/exercises.dart';
import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view/bottomNavBar.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'choose_exercises.dart';

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
    PlansCubit.getInstance(context).makeListForEachDay(widget.daysNumber);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlansCubit,PlansStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => Column(
                    children: [
                      Card(
                        color: Colors.red[400],
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
                      Column(
                        children: List.generate(
                          PlansCubit.getInstance(context).lists['list${index+1}']!.length, (i)
                        {
                          return Dismissible(
                            background: Container(
                              color: Colors.red,
                              child: const Icon(Icons.delete,color: Colors.white,),
                            ),
                            key: ValueKey<Exercises>(PlansCubit.getInstance(context).lists['list${index+1}']![i]),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Image.network(PlansCubit.getInstance(context).lists['list${index+1}']![i].image)),
                                ),
                                MyText(
                                  text: PlansCubit.getInstance(context).lists['list${index+1}']![i].name,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            onDismissed: (direction)
                            {
                              PlansCubit.getInstance(context).removeFromPlanExercises(
                                  index + 1,
                                  PlansCubit.getInstance(context).lists['list${index+1}']![i],
                              );
                            },
                          );
                         }
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
                  onPressed: state is CreateNewPlanLoadingState?
                      // || PlansCubit.getInstance(context).lists.entries.toList().isEmpty?
                  null : () async
                  {
                    await PlansCubit.getInstance(context).createNewPlan(
                      daysNumber: widget.daysNumber,
                      name: widget.name,
                    ).then((value)
                    {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavBar(),
                          ), (route) => false,
                      );
                    });
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
        );
      },
    );
  }
}
