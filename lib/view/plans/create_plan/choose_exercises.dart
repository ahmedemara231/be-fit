import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseExercises extends StatefulWidget {

  int day;
  // List dayCheckBox = [];
  ChooseExercises({super.key,
    required this.day,
    // required this.dayCheckBox,
  });

  @override
  State<ChooseExercises> createState() => _ChooseExercisesState();
}

class _ChooseExercisesState extends State<ChooseExercises> {

  @override
  void initState() {
    PlansCubit.getInstance(context).getMuscles(
      day: widget.day
    );
    PlansCubit.getInstance(context).planExercises = [];
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
          Column(
            children: [
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) => Card(
                      color: Colors.red[400],
                      child: ExpansionTile(
                        title: MyText(
                          text: PlansCubit.getInstance(context).muscles[index],
                          fontSize: 20,
                        ),
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
                                    value: PlansCubit.getInstance(context).daysCheckBox['day${widget.day}'][index][i],
                                    onChanged: (value)
                                    {
                                      PlansCubit.getInstance(context).newChangeCheckBoxValue(
                                        value: value!,
                                        dayIndex: widget.day,
                                        muscle: index,
                                        exerciseIndex: i,
                                      );
                                      if(value == true)
                                      {
                                        PlansCubit.getInstance(context).addToPlanExercises(
                                            widget.day,
                                            PlansCubit.getInstance(context).musclesForPlan[index][i],
                                        );
                                      }
                                      else{
                                        PlansCubit.getInstance(context).removeFromPlanExercises(
                                          widget.day,
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
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400]
                  ),
                  onPressed: PlansCubit.getInstance(context).bringingListListForEachDay['bList${widget.day}']!.isEmpty?
                      null : ()
                  {
                    PlansCubit.getInstance(context).putExerciseList(
                        index: widget.day,
                        exercises: PlansCubit.getInstance(context).planExercises
                    );
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/5),
                    child: MyText(
                      text: 'Save',
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
