import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper
{

  static late SharedPreferences sharedPreferences;

  static Future<void> initCache()async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> setData({
    required List<String> userData
})async
  {
    bool result = await sharedPreferences.setStringList('userData', userData);
    print(result);
  }
}