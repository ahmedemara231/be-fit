import 'package:be_fit/view_model/bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'model/local/cache_helper/shared_prefs.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.getInstance().initCache();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await HandleNotifications.getInstance().getToken();
  // await HandleNotifications.getInstance().handleOnForeGround();
  // HandleNotifications.getInstance().handleOnBackGround();

  Bloc.observer = MyBlocObserver();
  runApp(const BeFitApp());
}