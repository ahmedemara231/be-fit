import 'dart:async';
import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/view/BottomNavBar/bottom_nav_bar.dart';
import 'package:be_fit/view/auth/login/login.dart';
import 'package:be_fit/view/onBoarding/page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/local/cache_helper/shared_prefs.dart';
import '../models/methods/internet_check.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  bool get userLoginState
  {
    List<String>? userData = CacheHelper.getInstance().shared.getStringList('userData');

    if(userData == null)
      {
        return true;
      }
    else if(userData.isEmpty)
      {
        return true;
      }
    else{
      return false;
    }
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Timer(
        const Duration(seconds: 2), () {
      if(CacheHelper.getInstance().shared.getBool('finishOnBoarding') == true)
        {
          if(userLoginState)
            {
              context.removeOldRoute(Login());
            }
          else{
            context.removeOldRoute(BottomNavBar());
          }
        }
      else{
        context.removeOldRoute(const OnBoarding());
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    CheckInternetConnection.getInstance().startInternetInterceptor(context);
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('images/app_logo.png',color: Colors.white,),
      ),
    );
  }
}
