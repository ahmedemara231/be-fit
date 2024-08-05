import 'package:be_fit/constants/constants.dart';
import 'package:flutter/material.dart';

extension ContainerDecoration on BuildContext
{
  Border decoration()
  {
    return Border.all(
      color: Constants.appColor
    );
  }
}