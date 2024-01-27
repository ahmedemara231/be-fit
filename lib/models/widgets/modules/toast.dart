import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'myText.dart';

class MyToast
{
  static final toast = FToast();

  static void showToast(context,{required String msg, Color? color})
  {
    toast.init(context);
    toast.showToast(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color?? Colors.green,
        ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 28),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check),
                const SizedBox(width: 20,),
                MyText(
                  text: msg,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      toastDuration: const Duration(seconds: 2),
      positionedToastBuilder: (context, child)
      {
        return Positioned(
          bottom: 80,
          left: MediaQuery.of(context).size.width/4,
          child: child,
        );
      },
      gravity: ToastGravity.BOTTOM,
    );
  }
}