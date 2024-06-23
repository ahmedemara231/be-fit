import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import '../model/local/cache_helper/shared_prefs.dart';
import '../models/widgets/modules/snackBar.dart';

class Constants
{
  static var appColor = HexColor('#D84D4D');
  static var scaffoldBackGroundColor = HexColor('#242424');

  // user
  static String userId = CacheHelper.getInstance().getData('userData')[0];
  static String userName = CacheHelper.getInstance().getData('userData')[1];
  static String userEmail = CacheHelper.getInstance().getData('userData')[2];
}

class MyMethods
{
 static Exception handleError(context, Exception e)
  {
    if(e is FirebaseException)
      {

      }
    switch(e)
    {
      case SocketException() :
        MySnackBar.showSnackBar(
            context: context,
            message: 'Check your internet connection and try again',
            color: Constants.appColor
        );
        break;

      case FirebaseException() :
        MySnackBar.showSnackBar(
            context: context,
            message: 'try again later',
            color: Constants.appColor
        );
        break;

      case PlatformException() :
        MySnackBar.showSnackBar(
            context: context,
            message: 'try again later',
            color: Constants.appColor
        );
        break;

        default:
          MySnackBar.showSnackBar(
              context: context,
              message: 'Failed to make changes try again later',
              color: Constants.appColor
          );
          break;
    }
    return e;
  }
}