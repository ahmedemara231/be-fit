import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'myText.dart';

class MySnackBar {
  static void showSnackBar(
      {required BuildContext context, required String message, Color? color}) {
    SnackBar snackBar = SnackBar(
      backgroundColor: color ?? Colors.grey,
      content: MyText(
        text: message,
        fontSize: 20.sp,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
