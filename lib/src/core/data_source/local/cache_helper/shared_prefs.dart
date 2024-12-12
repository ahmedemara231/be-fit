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
}
