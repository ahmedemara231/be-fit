import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper
{
  // try to use Singleton design pattern
  CacheHelper._internal();
  static CacheHelper? cacheInstance;


  // Lazy Singleton
  factory CacheHelper.getInstance()
  {
    cacheInstance ??= CacheHelper._internal();
    return cacheInstance!;
  }

   late SharedPreferences sharedPreferences;

   Future<void> initCache()async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> setAppTheme(bool newMode)async
  {
    await sharedPreferences.setBool('appTheme', newMode);
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

  Future<void> setNotificationsOnEveryDay({
    required bool everyday,
  })async
  {
    await sharedPreferences.setBool('notificationsEveryDay', everyday);
  }

  Future<void> setNotificationsOnWorkoutDays({
    required bool onWorkoutDays,
  })async
  {
    await sharedPreferences.setBool('notificationsOnWorkoutDays', onWorkoutDays);
  }

   Future<void> kill()async
  {
    await sharedPreferences.setStringList('userData', []);
  }

  Future<void> googleUser()async
  {
    await sharedPreferences.setBool('isGoogleUser', true);
  }

  Future<void> killGoogleUser()async
  {
    await sharedPreferences.setBool('isGoogleUser', false);
  }
}

void ahmed()
{
  esraa();
}
void esraa({String? name})
{
  String name2 = name ?? 'sksksks';
}