import 'package:be_fit/src/core/extensions/mediaQuery.dart';
import 'package:be_fit/src/core/helpers/app_widgets/app_button.dart';
import 'package:be_fit/src/features/create_plan/data/data_source/models/change_ckeckbox_val.dart';
import 'package:be_fit/src/features/create_plan/presentation/bloc/state.dart';
import 'package:be_fit/src/features/create_plan/presentation/widgets/app_list_tile.dart';
import 'package:be_fit/src/features/plans/presentation/bloc/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helpers/app_widgets/invalid_connection_screen.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../bloc/cubit.dart';
import '../widgets/reps_sets.dart';

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
    planCreationCubit = context.read<PlanCreationCubit>();
    if(widget.isExist) {
      planCreationCubit.state.lists?['list1'] = List.empty(growable: true);
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
          await planCreationCubit.getAllExercises();
        },
        child: Padding(
          padding:  EdgeInsets.all(5.0.r),
          child: BlocBuilder<PlanCreationCubit, CreatePlanState>(
            builder: (context, state) {
              switch(state.currentState){
                case CreatePlanInternalStates.getAllMusclesLoading:
                  return Center(
                    child: SpinKitCircle(
                      color: Constants.appColor,
                      size: 50.0,
                    ),
                  );
                case CreatePlanInternalStates.getAllMusclesError:
                  return ErrorBuilder(
                      msg: 'Try Again Later',
                      onPressed: () async =>
                      await planCreationCubit.getAllExercises()
                  );
                default:
                  return ListView.separated(
                      itemBuilder: (context, index) => Column(
                        children: [
                          Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                                color: Constants.appColor,
                                borderRadius: BorderRadius.circular(12)),
                            child:
                            ExpansionTile(
                              title: MyText(
                                text: state.musclesAndItsExercises!.keys.toList()[index],
                                fontSize: 20.sp,
                              ),
                              subtitle: MyText(
                                text:
                                'Choose Now From ${state.musclesAndItsExercises!.keys.toList()[index]} collection',
                                fontSize: 13.sp,
                              ),
                              children: List.generate(
                                state.musclesAndItsExercises![state.musclesAndItsExercises!.keys.toList()[index]]!.length,
                                    (i) => AppListTile(
                                        exerciseImage: state.musclesAndItsExercises![state.musclesAndItsExercises!.keys.toList()[index]]![i].image[0],
                                        exerciseName: state.musclesAndItsExercises![state.musclesAndItsExercises!.keys.toList()[index]]![i].name,
                                        checkboxVal: state.dayCheckBox!['day${widget.day}']![state.musclesAndItsExercises?.keys.toList()[index]]![i],
                                        onChanged:  (value) {
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
                                                        state.musclesAndItsExercises?[state.musclesAndItsExercises!.keys.toList()[index]]![i].reps = repsCont.text;
                                                        state.musclesAndItsExercises?[state.musclesAndItsExercises!.keys.toList()[index]]![i].sets = setsCont.text;
                                                        planCreationCubit.addToPlanExercises(
                                                            day: widget.day,
                                                            exercise: state.musclesAndItsExercises![state.musclesAndItsExercises!.keys.toList()[index]]![i]
                                                        );
                                                        planCreationCubit.newChangeCheckBoxValue(
                                                            ChangeCheckBoxVal(
                                                                dayIndex: widget.day,
                                                                muscle: state.musclesAndItsExercises!.keys.toList()[index],
                                                                exerciseIndex: i,
                                                                value: value!
                                                            )
                                                        );

                                                        Navigator.pop(context);
                                                        repsCont.text = '';
                                                        setsCont.text = '';
                                                      }},
                                                  )),
                                            ));
                                          } else {
                                            planCreationCubit.removeFromPlanExercises(
                                              day: widget.day,
                                              exercise: state.musclesAndItsExercises![state.musclesAndItsExercises!.keys.toList()[index]]![i],
                                            );
                                            planCreationCubit.newChangeCheckBoxValue(
                                                ChangeCheckBoxVal(
                                                    dayIndex: widget.day,
                                                    muscle: state.musclesAndItsExercises!.keys.toList()[index],
                                                    exerciseIndex: i,
                                                    value: value!
                                                )
                                            );
                                          }
                                        },
                                    )
                              ),
                            ),
                          ),
                          if(index == 6)
                            AppButton(
                              text: 'Save',
                              onPressed: state.lists!['list${widget.day}']!.isEmpty ?
                              null : () {
                                Navigator.pop(context);
                                if(widget.isExist) {
                                  context.read<PlansCubit>().addExercisesToExistingPlanInDatabase(
                                    exercises: state.lists!['list1']!,
                                  );
                                }
                              },
                            )
                        ],
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 16.h,
                      ),
                      itemCount: state.musclesAndItsExercises!.keys.toList().length
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}