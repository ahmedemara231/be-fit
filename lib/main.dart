import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/view_model/bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'model/local/cache_helper/shared_prefs.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Constants.configLoading();
  Bloc.observer = MyBlocObserver();
  await ScreenUtil.ensureScreenSize();
  await CacheHelper.getInstance().initCache();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BeFitApp());
}