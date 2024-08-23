import 'package:flutter/material.dart';

import 'myText.dart';

class MySnackBar
{
  static void showSnackBar({
    required BuildContext context,
    required String message,
    Color? color
})
  {
    SnackBar snackBar = SnackBar(
      backgroundColor: color?? Colors.grey,
        content: MyText(
          text: message,
          fontSize: 20,
        ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}