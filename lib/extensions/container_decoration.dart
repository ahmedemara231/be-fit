import 'package:be_fit/constants/constants.dart';
import 'package:flutter/material.dart';

extension ContainerDecoration on BuildContext
{
  Border decoration()
  {
    return Border(
      left: BorderSide(color: Constants.appColor),
      bottom: BorderSide(color: Constants.appColor),
      right: BorderSide(color: Constants.appColor),
      top: BorderSide(color: Constants.appColor),
    );
  }
}