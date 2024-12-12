import 'package:be_fit/src/core/extensions/mediaQuery.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'myText.dart';

class MyToast {
  static final toast = FToast();

  static void showToast(BuildContext context,{
    required String msg,
    Color? color,
    Duration? duration,
  }) {
    toast.init(context);
    toast.showToast(
      isDismissable: true,
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color?? Colors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 28),
          child: Center(
            child: MyText(
              text: msg,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      toastDuration: duration?? const Duration(seconds: 2),
      positionedToastBuilder: (context, child) {
        return Positioned(
          bottom: context.setWidth(5),
          left: context.setWidth(4),
          right: context.setWidth(4),
          child: child,
        );
      },
      gravity: ToastGravity.BOTTOM,
    );
  }
}