import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension Routes on BuildContext
{
  normalNewRoute(Widget newRoute)
  {
    Navigator.push(
        this,
        CupertinoDialogRoute(
            builder: (context) => newRoute,
            context: this,
        ),
    );
  }

  removeOldRoute(Widget newRoute)
  {
    Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(
          builder: (context) => newRoute,
        ), (route) => false,
    );
  }

  replacementRoute(Widget newRoute)
  {
    Navigator.pushReplacement(
      this,
      CupertinoDialogRoute(
        builder: (context) => newRoute,
        context: this,
      ),
    );  }
}