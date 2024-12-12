import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';

class AppSnackBar{
  static void show(BuildContext context,{
    required String msg,
    AnimatedSnackBarType? type
  }){
    AnimatedSnackBar.material(
        msg,
        type: type?? AnimatedSnackBarType.info,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom
    ).show(context);
  }
}