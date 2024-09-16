import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/models/widgets/modules/image.dart';
import 'package:be_fit/models/widgets/invalid_connection_screen.dart';
import 'package:be_fit/view/plans/create_plan/choose_exercises/reps_sets.dart';
import 'package:be_fit/view_model/plan_creation/cubit.dart';
import 'package:be_fit/view_model/plan_creation/states.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseExercises extends StatefulWidget {
  final int day;
  final bool isExist;

  const ChooseExercises({
    super.key,
    required this.day,
    this.isExist = false,
  });

  @override
  State<ChooseExercises> createState() => _ChooseExercisesState();
}

class _ChooseExercisesState extends State<ChooseExercises> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();

  late TextEditingController repsCont;

  late TextEditingController setsCont;

  late PlanCreationCubit planCreationCubit;

  @override
  void initState() {
    repsCont = TextEditingController();
    setsCont = TextEditingController();
    planCreationCubit = PlanCreationCubit.getInstance(context);
    if(widget.isExist)
    {
      planCreationCubit.lists['list1'] = List.empty(growable: true);
    }
    super.initState();
  }

  @override
  void dispose() {
    repsCont.dispose();
    setsCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: MyText(text: 'Choose Exercises', fontWeight: FontWeight.w500),
      ),
      body: RefreshIndicator(
        backgroundColor: Constants.appColor,
        color: Colors.white,
        onRefresh: () async {
          await planCreationCubit.getAllExercises(context);
        },
        child: Padding(
          padding:  EdgeInsets.all(5.0.r),
          child: BlocBuilder<PlanCreationCubit, PlanCreationStates>(
            builder: (context, state) {
              if (state is GetAllMusclesLoadingState) {
                return Center(
                  child: SpinKitCircle(
                    color: Constants.appColor,
                    size: 50.0,
                  ),
                );
              }
              if (state is GetAllMusclesErrorState) {
                return ErrorBuilder(
                    msg: 'Try Again Later',
                    onPressed: () async =>
                        await planCreationCubit.getAllExercises(context));
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) => Column(
                            children: [
                              Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(
                                        color: Constants.appColor,
                                        borderRadius: BorderRadius.circular(12)),
                                    child: ExpansionTile(
                                      title: MyText(
                                        text: planCreationCubit.musclesAndItsExercises.keys.toList()[index],
                                        fontSize: 20.sp,
                                      ),
                                      subtitle: MyText(
                                        text:
                                        'Choose Now From ${planCreationCubit.musclesAndItsExercises.keys.toList()[index]} collection',
                                        fontSize: 13.sp,
                                      ),
                                      children: List.generate(
                                        planCreationCubit.musclesAndItsExercises[planCreationCubit.musclesAndItsExercises.keys.toList()[index]]!.length,
                                        (i) => ListTile(
                                          leading: Padding(
                                            padding:  EdgeInsets.all(8.0.r),
                                            child: MyNetworkImage(
                                                url: planCreationCubit.musclesAndItsExercises[planCreationCubit.musclesAndItsExercises.keys.toList()[index]]![i].image[0]),
                                          ),
                                          title: MyText(
                                            text: planCreationCubit
                                                .musclesAndItsExercises[planCreationCubit.musclesAndItsExercises.keys.toList()[index]]![i]
                                                .name,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          trailing: Checkbox(
                                            value: planCreationCubit.dayCheckBox['day${widget.day}']?[planCreationCubit.musclesAndItsExercises.keys.toList()[index]]?[i],
                                            onChanged: (value) {
                                              if (value == true) {
                                                scaffoldKey.currentState?.showBottomSheet((context) => Form(
                                                  key: formKey,
                                                  child: SizedBox(
                                                      width: double.infinity,
                                                      height: context.setHeight(4),
                                                      child: RepsAnaSets(
                                                        repsCont: repsCont,
                                                        setsCont: setsCont,
                                                        cancelButtonAction: () {
                                                          Navigator.pop(context);
                                                          },
                                                        conformButtonAction:
                                                            () {
                                                          if (formKey.currentState!.validate()) {
                                                            planCreationCubit.musclesAndItsExercises[planCreationCubit.musclesAndItsExercises.keys.toList()[index]]![i].reps = repsCont.text;
                                                            planCreationCubit.musclesAndItsExercises[planCreationCubit.musclesAndItsExercises.keys.toList()[index]]![i].sets = setsCont.text;
                                                            planCreationCubit.addToPlanExercises(
                                                                widget.day,
                                                                planCreationCubit.musclesAndItsExercises[planCreationCubit.musclesAndItsExercises.keys.toList()[index]]![i]
                                                            );
                                                            planCreationCubit.newChangeCheckBoxValue(
                                                              value: value!,
                                                              dayIndex: widget.day,
                                                              muscle: planCreationCubit.musclesAndItsExercises.keys.toList()[index],
                                                              exerciseIndex: i,
                                                            );

                                                             Navigator.pop(context);
                                                             repsCont.text = '';
                                                             setsCont.text = '';
                                                          }},
                                                      )),
                                                ));
                                              } else {
                                                planCreationCubit.removeFromPlanExercises(
                                                    widget.day,
                                                    planCreationCubit.musclesAndItsExercises[planCreationCubit.musclesAndItsExercises.keys.toList()[index]]![i]);
                                                planCreationCubit.newChangeCheckBoxValue(
                                                  value: value!,
                                                  dayIndex: widget.day,
                                                  muscle: planCreationCubit.musclesAndItsExercises.keys.toList()[index],
                                                  exerciseIndex: i,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              if(index == 6)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 7.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Constants.appColor,
                                    ),
                                    onPressed: planCreationCubit.lists['list${widget.day}']!.isEmpty ?
                                    null : () {
                                      Navigator.pop(context);
                                      if(widget.isExist)
                                      {
                                        PlansCubit.getInstance(context).addExercisesToExistingPlanInDatabase(
                                          context,
                                          exercises: planCreationCubit.lists['list1']!,
                                        );
                                      }

                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: context.setWidth(5),
                                      ),
                                      child: MyText(
                                        text: 'Save',
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          separatorBuilder: (context, index) => SizedBox(
                                height: 16.h,
                              ),
                          itemCount: planCreationCubit.musclesAndItsExercises.keys.toList().length
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}