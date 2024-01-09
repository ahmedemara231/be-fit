import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper
{
  // try to use singleton design pattern
  CacheHelper._internal();
  static CacheHelper instance = CacheHelper._internal();


   late SharedPreferences sharedPreferences;

   Future<void> initCache()async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }

   Future<void> handleUserData({
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

   late String uId;
   late String userName;
   void getUserData()
  {
    uId = sharedPreferences.getStringList('userData')![0];
    userName = sharedPreferences.getStringList('userData')![1];
  }

   Future<void> kill()async
  {
    bool logOut = await sharedPreferences.setStringList('userData', []);
    print(logOut);
  }

  Future<void> setAppTheme(bool newMode)async
  {
    await sharedPreferences.setBool('appTheme', newMode).then((value)
    {
      print(newMode);
    });
  }
}