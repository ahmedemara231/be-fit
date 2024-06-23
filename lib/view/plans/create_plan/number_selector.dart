import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/view_model/plan_creation/cubit.dart';
import 'package:be_fit/view_model/plan_creation/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheel_slider/wheel_slider.dart';

class NumberSelection extends StatelessWidget {
  const NumberSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanCreationCubit,PlanCreationStates>(
      builder: (context, state)
      {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Constants.appColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: WheelSlider.number(
              isInfinite: false,
              horizontal: false,
              verticalListWidth: 60,
              verticalListHeight: 120,
              enableAnimation: true,
              animationDuration: const Duration(milliseconds: 500),
              perspective: 0.01,
              totalCount: 6,
              initValue: 1,
              selectedNumberStyle: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              unSelectedNumberStyle: const TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
              currentIndex: PlanCreationCubit.getInstance(context).currentIndex,
              onValueChanged: (val) {
                PlanCreationCubit.getInstance(context).changeDaysNumber(val);
              },
              hapticFeedbackType: HapticFeedbackType.heavyImpact,
            ),
          ),
        );
      },
    );
  }
}

