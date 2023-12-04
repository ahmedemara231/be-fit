import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view/plans/plans.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseExercises extends StatefulWidget {

  int day;
  ChooseExercises({super.key,
    required this.day,
  });

  @override
  State<ChooseExercises> createState() => _ChooseExercisesState();
}

class _ChooseExercisesState extends State<ChooseExercises> {

  List<String> muscles =
  [
    'chest',
    'Back',
    'Shoulders',
  ];
  
  @override
  void initState() {
    PlansCubit.getInstance(context).getMuscles();
    PlansCubit.getInstance(context).planExercises = [];
    print(widget.day);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlansCubit,PlansStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Choose your exercises',fontWeight: FontWeight.w500),
          ),
          body: state is GetAllPlansLoadingState?
          const Center(
            child: CircularProgressIndicator(),
          ):
          // Column(
          //   children: [
          //     Card(
          //       color: Colors.red[400],
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: ExpansionTile(
          //           title: MyText(text: muscles[0],fontSize: 20,fontWeight: FontWeight.w500,),
          //           children: List.generate(
          //               PlansCubit.getInstance(context).chestExercisesForPlan.length,
          //                   (index) => ListTile(
          //                 leading: SizedBox(
          //                     width: 100,
          //                     height: 70,
          //                     child: Image.network(PlansCubit.getInstance(context).chestExercisesForPlan[index].image)),
          //                 title: MyText(text: PlansCubit.getInstance(context).chestExercisesForPlan[index].name,fontWeight: FontWeight.bold),
          //                 trailing: Checkbox(
          //                   value: PlansCubit.getInstance(context).chestCheckBoxes[index],
          //                   onChanged: (value)
          //                   {
          //                     PlansCubit.getInstance(context).changeCheckBoxValue(value!,index);
          //
          //                     if(value == true)
          //                     {
          //                       PlansCubit.getInstance(context).addToPlanExercises(
          //                           PlansCubit.getInstance(context).chestExercisesForPlan[index]
          //                       );
          //                     }
          //                     else{
          //                       PlansCubit.getInstance(context).removeFromPlanExercises(
          //                           PlansCubit.getInstance(context).chestExercisesForPlan[index]
          //                       );
          //                     }
          //                   },
          //                 ),
          //               )
          //           ),
          //           onExpansionChanged: (value) {},
          //         ),
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 16,
          //     ),
          //     Card(
          //       color: Colors.red[400],
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: ExpansionTile(
          //           title: MyText(text: muscles[1],fontSize: 20,),
          //           children: List.generate(
          //               PlansCubit.getInstance(context).backExercisesForPlan.length,
          //                   (index) => ListTile(
          //                 leading: SizedBox(
          //                     width: 100,
          //                     height: 70,
          //                     child: Image.network(PlansCubit.getInstance(context).backExercisesForPlan[index].image)),
          //                 title: MyText(text: PlansCubit.getInstance(context).backExercisesForPlan[index].name,fontWeight: FontWeight.bold),
          //                 trailing: Checkbox(
          //                   value: false,
          //                   onChanged: (value) {},
          //                 ),
          //               )
          //           ),
          //           onExpansionChanged: (value) {},
          //         ),
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 16,
          //     ),
          //     Card(
          //       color: Colors.red[400],
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: ExpansionTile(
          //           title: MyText(text: muscles[2],fontSize: 20,),
          //           children: List.generate(
          //               PlansCubit.getInstance(context).shouldersExercisesForPlan.length,
          //                   (index) => ListTile(
          //                 leading: SizedBox(
          //                     width: 100,
          //                     height: 70,
          //                     child: Image.network(PlansCubit.getInstance(context).shouldersExercisesForPlan[index].image)),
          //                 title: MyText(text: PlansCubit.getInstance(context).shouldersExercisesForPlan[index].name,fontWeight: FontWeight.bold,),
          //                 trailing: Checkbox(
          //                   value: false,
          //                   onChanged: (value) {},
          //                 ),
          //               )
          //           ),
          //           onExpansionChanged: (value) {},
          //         ),
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 16,
          //     ),
          //     ElevatedButton(
          //       style: ElevatedButton.styleFrom(
          //           backgroundColor: Colors.red[400]
          //       ),
          //       onPressed: PlansCubit.getInstance(context).planExercises.isEmpty?
          //       null:
          //           () async
          //       {
          //         PlansCubit.getInstance(context).putExerciseList(
          //           index: widget.day,
          //           exercises: PlansCubit.getInstance(context).planExercises,
          //         );
          //         Navigator.pop(context);
          //       },
          //       child: Padding(
          //         padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/5),
          //         child: MyText(
          //           text: 'Save',
          //           color: Colors.white,
          //           fontWeight: FontWeight.w500,
          //           fontSize: 20,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          ListView.separated(
              itemBuilder: (context, index) => Card(
                color: Colors.red[400],
                child: ExpansionTile(
                  title: MyText(text: muscles[index]),
                  children: List.generate(
                      PlansCubit.getInstance(context).musclesForPlan[index].length,
                          (i) => ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(PlansCubit.getInstance(context).musclesForPlan[index][i].image),
                            ),
                            title: MyText(
                                text: PlansCubit.getInstance(context).musclesForPlan[index][i].name,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            trailing: Checkbox(
                              // onChanged: (value) {},
                              value: PlansCubit.getInstance(context).musclesCheckBoxes[index][i],
                              onChanged: (value)
                              {
                                PlansCubit.getInstance(context).changeCheckBoxValue(
                                    value!,
                                    index,
                                    i,
                                );
                                if(value == true)
                                {
                                  PlansCubit.getInstance(context).addToPlanExercises(
                                    PlansCubit.getInstance(context).musclesForPlan[index][i],
                                  );
                                }
                                else{
                                  PlansCubit.getInstance(context).removeFromPlanExercises(
                                    PlansCubit.getInstance(context).musclesForPlan[index][i],
                                  );
                                }
                              },
                            ),
                          ),
                  ),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 16,),
              itemCount: PlansCubit.getInstance(context).musclesForPlan.length
          ),
        );
      },
    );
  }
}
