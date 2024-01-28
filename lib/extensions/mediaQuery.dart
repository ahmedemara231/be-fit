import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext
{
  double setWidth(double width)
  {
    return MediaQuery.of(this).size.width/ width;
  }

  double setHeight(double height)
  {
    return MediaQuery.of(this).size.height/height;
  }
}