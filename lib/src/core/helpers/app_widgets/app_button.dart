import 'package:be_fit/src/core/extensions/mediaQuery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/constants.dart';
import '../base_widgets/myText.dart';

class AppButton extends StatelessWidget {
  void Function()? onPressed;
  String text;

  AppButton({
    super.key,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(12.0.r),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Constants.appColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.setWidth(3.5),
            vertical: 10,
          ),
          child: FittedBox(
            child: MyText(
              text: text,
              color: Colors.white,
              fontSize: 18.sp,
            ),
          ),
        ),
      ),
    );
  }
}
