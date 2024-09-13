import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/view/BottomNavBar/bottom_nav_bar.dart';
import 'package:be_fit/view/auth/login/login.dart';
import 'package:be_fit/view/onBoarding/page_view.dart';
import 'package:flutter/material.dart';
import '../model/local/cache_helper/shared_prefs.dart';
import '../models/methods/intercept_internet_connection/internet_check.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get userLoginState {
    List<String>? userData = CacheHelper.getInstance().shared.getStringList('userData');

    switch (userData) {
      case null:
        return true;
      case []:
        return true;
      default:
        return false;
    }
  }

  void _navigate() async {
    Timer(
        const Duration(seconds: 2), () {
      switch (CacheHelper.getInstance().shared.getBool('finishOnBoarding')) {
        case true:
          switch (userLoginState) {
            case true:
              context.removeOldRoute(const Login());
            default:
              context.removeOldRoute(const BottomNavBar());
          }
        default:
          context.removeOldRoute(const OnBoarding());
      }
      CheckInternetConnection().startInternetInterceptor(context);
    });
  }

  @override
  void initState() {
    _navigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Image.asset(
          'images/app_logo.png',
          color: Colors.white,
        ),
      ),
    );
  }
}