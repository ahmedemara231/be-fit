import 'package:be_fit/src/features/create_plan/presentation/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheel_slider/wheel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/constants.dart';
import '../bloc/cubit.dart';

class NumberSelection extends StatelessWidget {
  const NumberSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanCreationCubit, CreatePlanState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Constants.appColor,
          ),
          child: Padding(
            padding:  EdgeInsets.all(10.0.r),
            child: WheelSlider.number(
              isInfinite: false,
              horizontal: false,
              verticalListWidth: 65.w,
              verticalListHeight: 140.h,
              enableAnimation: true,
              animationDuration: const Duration(milliseconds: 500),
              perspective: 0.01,
              totalCount: 6,
              initValue: 1,
              selectedNumberStyle: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              unSelectedNumberStyle: TextStyle(
                fontSize: 16.sp,
                color: Colors.black54,
              ),
              currentIndex: state.currentIndex,
              onValueChanged: (val) {
                context.read<PlanCreationCubit>().changeDaysNumber(val);
              },
              hapticFeedbackType: HapticFeedbackType.heavyImpact,
            ),
          ),
        );
      },
    );
  }
}
