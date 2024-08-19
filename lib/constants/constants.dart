import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiffy/jiffy.dart';
import '../model/local/cache_helper/shared_prefs.dart';
import '../models/widgets/modules/snackBar.dart';

class Constants
{
  static var appColor = HexColor('#D84D4D');
  static var scaffoldBackGroundColor = HexColor('#242424');

  //date time
  static String dataTime = Jiffy().yMMMd;
}

class MyMethods
{
 static Exception handleError(context, Exception e)
  {
    switch(e)
    {
      case FirebaseException() :
      case PlatformException() :
        MySnackBar.showSnackBar(
            context: context,
            message: 'Try Again Later',
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