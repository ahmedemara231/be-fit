import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper
{
  CacheHelper._internal();
  static CacheHelper? cacheInstance;


  // Lazy Singleton
  factory CacheHelper.getInstance()
  {
    cacheInstance ??= CacheHelper._internal();
    return cacheInstance!;
  }

   late SharedPreferences shared;

   Future<void> initCache()async
  {
    shared = await SharedPreferences.getInstance();
  }


  Future<void> setData({
    required String key,
    required dynamic value,
  })async
  {
    switch(value.runtimeType)
    {
      case String:
        await shared.setString(key, value);

      case int:
        await shared.setInt(key, value);

      case bool:
        await shared.setBool(key, value);

      case double :
        await shared.setDouble(key, value);

      default:
        await shared.setStringList(key, value);
    }
  }

  dynamic getData(String key)
  {
    return shared.get(key);
  }



  void clearCache()async
  {
    await shared.clear();
  }









  Future<void> setAppTheme(bool newMode)async
  {
    await shared.setBool('appTheme', newMode);
  }

   Future<void> handleUserData({
    required List<String> userData
})async
  {
    await shared.setStringList('userData', userData)
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
    uId = shared.getStringList('userData')![0];
    userName = shared.getStringList('userData')![1];
  }

  Future<void> setNotificationsOnEveryDay({
    required bool everyday,
  })async
  {
    await shared.setBool('notificationsEveryDay', everyday);
  }

  Future<void> setNotificationsOnWorkoutDays({
    required bool onWorkoutDays,
  })async
  {
    await shared.setBool('notificationsOnWorkoutDays', onWorkoutDays);
  }

   Future<void> kill()async
  {
    await shared.setStringList('userData', []);
  }

  Future<void> googleUser()async
  {
    await shared.setBool('isGoogleUser', true);
  }

  Future<void> killGoogleUser()async
  {
    await shared.setBool('isGoogleUser', false);
  }
}
