import 'dart:io';

import 'package:hexcolor/hexcolor.dart';

import 'models/widgets/modules/snackBar.dart';

class Constants
{
  static var appColor = HexColor('#D84D4D');
  static var scaffoldBackGroundColor = HexColor('#242424');
}

class MyMethods
{
 static void handleError(context, Exception e)
  {
    if(e is SocketException)
      {
        MySnackBar.showSnackBar(
            context: context,
            message: 'Check your internet connection and try again',
            color: Constants.appColor
        );
      }
    else{
      MySnackBar.showSnackBar(
          context: context,
          message: 'try again later',
          color: Constants.appColor
      );
    }
  }
}