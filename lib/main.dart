import 'package:be_fit/src/core/constants/constants.dart';
import 'package:be_fit/src/core/data_source/local/cache_helper/shared_prefs.dart';
import 'package:be_fit/src/core/shared/observers/bloc_observer.dart';
import 'package:be_fit/src/core/shared/service_locator/blocs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Constants.configLoading();
  Bloc.observer = MyBlocObserver();
  ServiceLocator().prepareAllDependencies();
  await ScreenUtil.ensureScreenSize();
  await CacheHelper.getInstance().initCache();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // asynchronous errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const BeFitApp());
}