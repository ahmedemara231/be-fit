import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:be_fit/src/core/extensions/routes.dart';
import 'package:be_fit/src/core/helpers/app_widgets/animated_snack_bar.dart';
import 'package:be_fit/src/core/helpers/app_widgets/app_button.dart';
import 'package:be_fit/src/features/create_plan/presentation/bloc/cubit.dart';
import 'package:be_fit/src/features/create_plan/presentation/bloc/state.dart';
import 'package:be_fit/src/features/plans/presentation/bloc/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/data_source/local/cache_helper/shared_prefs.dart';
import '../../../../core/helpers/app_widgets/app_dialog.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../../../../core/helpers/base_widgets/textFormField.dart';
import '../../../../core/helpers/global_data_types/dialog_inputs.dart';
import '../widgets/choose_plan_days_number.dart';
import 'continue_planning.dart';

class CreatePlan extends StatefulWidget {
  const CreatePlan({super.key});

  @override
  State<CreatePlan> createState() => _CreatePlanState();
}

class _CreatePlanState extends State<CreatePlan> {
  late TextEditingController workOutNameCont;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    workOutNameCont = TextEditingController();
    super.initState();
  }

  Future<void> handleAsking(BuildContext context)async {
    if (CacheHelper.getInstance().getData('isBeginner') as bool) {
      Timer(const Duration(milliseconds: 250), ()async {
        await askUserIfHeIsBeginner(context);
      });
    }
  }

  Future<void> askUserIfHeIsBeginner(BuildContext context)async {
    await AppDialog.show(
        context,
        inputs: DialogInputs(
          title: 'If you are beginner click yes and Receive your plan',
          confirmButtonText: 'Make Plan',
          cancelButtonText: 'not Beginner',
          onTapConfirm: () async=> handleBeginnerClick(context),
          onTapCancel: ()async => handleCancelClick(context),
        )
    );
  }

  Future<void> handleBeginnerClick(BuildContext context)async {
    context.normalNewRoute(
        const ContinuePlanning(
            name: 'Beginner Plan',
            daysNumber: 3
        )
    );
    context.read<PlanCreationCubit>().createBeginnerPlan();
  }

  Future<void> handleCancelClick(BuildContext context)async {
    Navigator.pop(context);
    await CacheHelper.getInstance().setData(
        key: 'isBeginner',
        value: false
    );
  }

  @override
  void didChangeDependencies() {
    if (CacheHelper.getInstance().getData('isBeginner') as bool) {
      askUserIfHeIsBeginner(context);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    workOutNameCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanCreationCubit, CreatePlanState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Create your plan', fontWeight: FontWeight.w500),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TFF(
                    obscureText: false,
                    controller: workOutNameCont,
                    hintText: 'Workout Name',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Constants.appColor)),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  ChoosePlanDaysNumber(currentIndex: state.currentIndex!),
                  const Spacer(),
                  AppButton(
                    text: 'Prepare Plan',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        switch(state.currentIndex!){
                          case 0:
                            AppSnackBar.show(context, msg: 'Days Number can\'t be less than 1');

                          default:
                            if(context.read<PlansCubit>().state.allPlans!.keys.toList().contains(workOutNameCont.text)) {
                              AnimatedSnackBar.material(
                                  'This Plan name already exists',
                                  type: AnimatedSnackBarType.info,
                                  mobileSnackBarPosition: MobileSnackBarPosition.bottom
                              ).show(context);
                            }else{
                              context.normalNewRoute(
                                ContinuePlanning(
                                  name: workOutNameCont.text,
                                  daysNumber: state.currentIndex,
                                ),
                              );
                            }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}