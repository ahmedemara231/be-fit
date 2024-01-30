import 'package:be_fit/constants.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/view/plans/create_plan/choose_exercises/reps_sets.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/widgets/modules/myText.dart';

class ChooseExercises extends StatelessWidget {

  int day;
  ChooseExercises({super.key,
    required this.day,
  });

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final repsCont = TextEditingController();
  final setsCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlansCubit,PlansStates>(
      builder: (context, state)
      {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: MyText(text: 'Choose your exercises',fontWeight: FontWeight.w500),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
              ),
            ],
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
                      color: Constants.appColor,
                      child: ExpansionTile(
                        title: MyText(
                          text: PlansCubit.getInstance(context).musclesAndItsExercises.keys.toList()[index],
                          fontSize: 20,
                        ),
                        children: List.generate(
                            PlansCubit.getInstance(context).musclesAndItsExercises[PlansCubit.getInstance(context).musclesAndItsExercises.keys.toList()[index]]!.length,
                                (i) => ListTile(
                                  leading: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                        PlansCubit.getInstance(context).musclesAndItsExercises[PlansCubit.getInstance(context).musclesAndItsExercises.keys.toList()[index]]![i].image
                                    ),
                                  ),
                                  title: MyText(
                                      text: PlansCubit.getInstance(context).musclesAndItsExercises[PlansCubit.getInstance(context).musclesAndItsExercises.keys.toList()[index]]![i].name,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  trailing: Checkbox(
                                    value: PlansCubit.getInstance(context).muscleExercisesCheckBox[PlansCubit.getInstance(context).muscleExercisesCheckBox.keys.toList()[index]]?[i],
                                    onChanged: (value)
                                    {
                                      if(value == true)
                                      {
                                        scaffoldKey.currentState?.showBottomSheet((context) => Form(
                                          key: formKey,
                                          child: SizedBox(
                                              width: double.infinity,
                                              height: context.setHeight(4),
                                              child: RepsAnaSets(
                                                repsCont: repsCont,
                                                setsCont: setsCont,
                                                cancelButtonAction: ()
                                                {
                                                  Navigator.pop(context);
                                                },
                                                conformButtonAction: ()
                                                {
                                                  if(formKey.currentState!.validate())
                                                  {
                                                    PlansCubit.getInstance(context).musclesAndItsExercises[PlansCubit.getInstance(context).musclesAndItsExercises.keys.toList()[index]]![i].reps = repsCont.text;
                                                    PlansCubit.getInstance(context).musclesAndItsExercises[PlansCubit.getInstance(context).musclesAndItsExercises.keys.toList()[index]]![i].sets = setsCont.text;

                                                    PlansCubit.getInstance(context).addToPlanExercises(
                                                        day,
                                                        PlansCubit.getInstance(context).musclesAndItsExercises[PlansCubit.getInstance(context).musclesAndItsExercises.keys.toList()[index]]![i]
                                                    );

                                                    PlansCubit.getInstance(context).newChangeCheckBoxValue(
                                                      value: value!,
                                                      dayIndex: day,
                                                      muscle: PlansCubit.getInstance(context).musclesAndItsExercises.keys.toList()[index],
                                                      exerciseIndex: i,
                                                    );

                                                    Navigator.pop(context);
                                                    repsCont.text = '';
                                                    setsCont.text = '';
                                                  }
                                                },
                                              )
                                          ),
                                        ));
                                      }
                                      else{
                                        PlansCubit.getInstance(context).removeFromPlanExercises(
                                            day,
                                            PlansCubit.getInstance(context).musclesAndItsExercises[PlansCubit.getInstance(context).musclesAndItsExercises.keys.toList()[index]]![i]
                                        );

                                        PlansCubit.getInstance(context).newChangeCheckBoxValue(
                                          value: value!,
                                          dayIndex: day,
                                          muscle: PlansCubit.getInstance(context).musclesAndItsExercises.keys.toList()[index],
                                          exerciseIndex: i,
                                        );
                                      }
                                    },
                                  ),
                                ),
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(height: 16,),
                    itemCount: PlansCubit.getInstance(context).musclesAndItsExercises.keys.toList().length
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.appColor,
                  ),
                  onPressed:
                  PlansCubit.getInstance(context).lists['list$day']!.isEmpty?
                      null : ()
                  {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.setWidth(5),
                    ),
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
