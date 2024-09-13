import 'package:flutter/material.dart';

extension Routes on BuildContext
{
  normalNewRoute(Widget newRoute)
  {
    Navigator.push(
      this,
      MaterialPageRoute(
        builder: (context) => newRoute,
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
      MaterialPageRoute(
        builder: (context) => newRoute,
      ),
    );
  }
}