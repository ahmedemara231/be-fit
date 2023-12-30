import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper
{

  static late SharedPreferences sharedPreferences;

  static Future<void> initCache()async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> handleUserData({
    required List<String> userData
})async
  {
    await sharedPreferences.setStringList('userData', userData)
        .then((value)
    {
      getUserData();
      return value;
    });
  }

  static late String uId;
  static late String userName;
  static void getUserData()
  {
    uId = sharedPreferences.getStringList('userData')![0];
    userName = sharedPreferences.getStringList('userData')![1];
    print(uId);
    print(userName);
  }

  static Future<void> kill()async
  {
    bool logOut = await sharedPreferences.setStringList('userData', []);
    print(logOut);
  }
}