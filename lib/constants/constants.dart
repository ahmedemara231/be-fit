import 'package:hexcolor/hexcolor.dart';
import 'package:jiffy/jiffy.dart';

class Constants
{
  static var appColor = HexColor('#D84D4D');
  static var scaffoldBackGroundColor = HexColor('#242424');

  static final List<String> muscles =
  [
    'Aps',
    'chest',
    'Back',
    'biceps',
    'triceps',
    'Shoulders',
    'legs'
  ];

  //date time
  static String dataTime = Jiffy().yMMMd;
}