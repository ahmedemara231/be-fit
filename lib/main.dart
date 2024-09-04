import 'package:be_fit/view_model/bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'model/local/cache_helper/shared_prefs.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // final LocalAuthentication auth = LocalAuthentication();
  // final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
  // if (availableBiometrics.isNotEmpty) {
  //   availableBiometrics.forEach((element) {
  //     print(element.name);
  //   });
  //   // Some biometrics are enrolled.
  // }
  // else{
  //   print('none');
  // }

  SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  ]);
  configLoading();
  Bloc.observer = MyBlocObserver();
  await ScreenUtil.ensureScreenSize();
  await CacheHelper.getInstance().initCache();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BeFitApp());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..maskType = EasyLoadingMaskType.black;
}