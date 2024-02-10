import 'package:be_fit/view/auth/login/login.dart';
import 'package:be_fit/view/BottomNavBar/bottomNavBar.dart';
import 'package:be_fit/view_model/FCM/FCM.dart';
import 'package:be_fit/view_model/bloc_observer.dart';
import 'package:be_fit/view_model/bottomNavBar/cubit.dart';
import 'package:be_fit/view_model/bottomNavBar/states.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:be_fit/view_model/exercises/states.dart';
import 'package:be_fit/view_model/login/cubit.dart';
import 'package:be_fit/view_model/login/states.dart';
import 'package:be_fit/view_model/plan_creation/cubit.dart';
import 'package:be_fit/view_model/plan_creation/states.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:be_fit/view_model/setting/cubit.dart';
import 'package:be_fit/view_model/setting/states.dart';
import 'package:be_fit/view_model/sign_up/cubit.dart';
import 'package:be_fit/view_model/sign_up/states.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.getInstance().initCache();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await HandleNotifications.getInstance().getToken();
  await HandleNotifications.getInstance().handleOnForeGround();
  HandleNotifications.getInstance().handleOnBackGround();

  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BottomNavCubit(BottomNavState()),
        ),
        BlocProvider(
          create: (context) => ExercisesCubit(ExerInitialState()),
        ),
        BlocProvider(
          create: (context) => PlanCreationCubit(PlanCreationInitialState()),
        ),
        BlocProvider(
          create: (context) => PlansCubit(PlansInitialState()),
        ),
        BlocProvider(
          create: (context) => LoginCubit(LoginInitialState()),
        ),
        BlocProvider(
          create: (context) => SignUpCubit(SignUpInitialState()),
        ),
        BlocProvider(
          create: (context) => SettingCubit(SettingInitialState()),
        ),
      ],
      child: BlocBuilder<SettingCubit,SettingStates>(
        builder: (context, state)
        {
          return MaterialApp(
            theme: CacheHelper.getInstance().sharedPreferences.getBool('appTheme') == false?
            ThemeData.light():
            ThemeData.dark(),
            debugShowCheckedModeBanner: false,
            home: CacheHelper.getInstance().sharedPreferences.getStringList('userData') == null ||
                  CacheHelper.getInstance().sharedPreferences.getStringList('userData')!.isEmpty?
            Login() :
            const BottomNavBar(),
          );
        },
      ),
    );
  }
}
