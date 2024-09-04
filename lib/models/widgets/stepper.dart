import 'package:be_fit/constants/constants.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyStepper extends StatefulWidget {

  final int activeStep;
  const MyStepper({super.key,
    required this.activeStep,
  });

  @override
  State<MyStepper> createState() => _MyStepperState();
}

class _MyStepperState extends State<MyStepper> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> titles = ['', '', ''];
  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      activeStep: widget.activeStep,
      lineStyle: LineStyle(
          lineLength: 85,
          lineSpace: 0,
          lineType: LineType.normal,
          defaultLineColor: Colors.white,
          finishedLineColor: Constants.appColor
      ),
      activeStepTextColor: Colors.black87,
      finishedStepTextColor: Colors.black87,
      internalPadding: 0,
      showLoadingAnimation: false,
      stepRadius: 8,
      showStepBorder: false,
      // lineDotRadius: 1.5,
      steps: List.generate(
          titles.length, (index) => EasyStep(
        customStep: CircleAvatar(
          radius: 10.r,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 7.r,
            backgroundColor:
            widget.activeStep >= index ? Constants.appColor : Colors.white,
          ),
        ),
        title: titles[index],
      )),
    );
  }
}