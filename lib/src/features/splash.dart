import 'package:be_fit/src/core/extensions/routes.dart';
import 'package:flutter/material.dart';
import '../core/data_source/local/cache_helper/shared_prefs.dart';
import 'auth/presentation/screens/login.dart';
import 'bottom_bar/presentation/bottom_nav_bar.dart';
import 'on_boarding/presentation/page_view.dart';

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
  }

  @override
  void initState() {
    _navigate();
    // CheckInternetConnection().startInternetInterceptor(context);
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