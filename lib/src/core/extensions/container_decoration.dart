import 'package:flutter/material.dart';

import '../constants/constants.dart';

extension ContainerDecoration on BuildContext
{
  Border decoration()
  {
    return Border.all(
      color: Constants.appColor
    );
  }
}