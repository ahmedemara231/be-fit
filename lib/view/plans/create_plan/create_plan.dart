import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/view_model/plan_creation/cubit.dart';
import 'package:be_fit/view_model/plan_creation/states.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view/plans/create_plan/continue_planning.dart';
import 'package:be_fit/models/widgets/number_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/local/cache_helper/shared_prefs.dart';
import '../../../models/widgets/modules/textFormField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  @override
  void didChangeDependencies() {
    if (CacheHelper.getInstance().getData('isBeginner') as bool) {
      Timer(const Duration(milliseconds: 250), () {
        PlanCreationCubit.getInstance(context).askUserIfHeIsBeginner(context);
      });
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
    return BlocBuilder<PlanCreationCubit, PlanCreationStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title:
                MyText(text: 'Create your plan', fontWeight: FontWeight.w500),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 28),
                    child: Row(
                      children: [
                        MyText(
                          text: 'Training Days',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        Padding(
                          padding:  EdgeInsets.all(10.0.r),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: CacheHelper.getInstance().shared.getBool('appTheme') == false
                                    ? Colors.grey[300]
                                    : Colors.grey[700]),
                            child: Padding(
                              padding:  EdgeInsets.all(8.0.r),
                              child: MyText(
                                text: '${PlanCreationCubit.getInstance(context).currentIndex}',
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const NumberSelection(),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.appColor,
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (PlanCreationCubit.getInstance(context).currentIndex == 0) {
                          AnimatedSnackBar.material(
                              'Days must be more than 0',
                              type: AnimatedSnackBarType.info,
                              mobileSnackBarPosition: MobileSnackBarPosition.bottom
                          ).show(context);
                        } else {
                          context.normalNewRoute(
                            ContinuePlanning(
                              name: workOutNameCont.text,
                              daysNumber: PlanCreationCubit.getInstance(context)
                                  .currentIndex,
                            ),
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.setWidth(5),
                      ),
                      child: MyText(
                        text: 'Make a Plan',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp,
                      ),
                    ),
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
