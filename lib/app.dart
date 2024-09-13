import 'package:be_fit/view/splash.dart';
import 'package:be_fit/view_model/bottomNavBar/cubit.dart';
import 'package:be_fit/view_model/cardio/cubit.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:be_fit/view_model/login/cubit.dart';
import 'package:be_fit/view_model/plan_creation/cubit.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/setting/cubit.dart';
import 'package:be_fit/view_model/setting/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'model/local/cache_helper/shared_prefs.dart';
import 'models/data_types/permission_process_model.dart';
import 'models/methods/check_permission.dart';

class BeFitApp extends StatefulWidget {
  const BeFitApp({super.key});

  @override
  State<BeFitApp> createState() => _BeFitAppState();
}

class _BeFitAppState extends State<BeFitApp> {
  @override
  void initState() {
    checkPermission(
      PermissionProcessModel(
        permissionClient: PermissionClient.notification,
        onPermissionGranted: () {},
        onPermissionDenied: () {},
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingCubit(),
        ),

        BlocProvider(
          create: (context) => BottomNavCubit(),
        ),

        BlocProvider(
          create: (context) => ExercisesCubit(),
        ),

        BlocProvider(
          create: (context) => PlanCreationCubit(),
        ),

        BlocProvider(
          create: (context) => PlansCubit(),
        ),

        BlocProvider(
          create: (context) => LoginCubit(),
        ),

        BlocProvider(
          create: (context) => CardioCubit()
        ),

        // setting - sign up
      ],
      child: BlocBuilder<SettingCubit, SettingStates>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp(
                title: 'Be Fit',
                theme: CacheHelper.getInstance().shared.getBool('appTheme') == false
                        ? ThemeData.light()
                        : ThemeData.dark(),
                debugShowCheckedModeBanner: false,
                home: const Splash(),
                builder: EasyLoading.init(),
            ),
          );
        },
      ),
    );
  }
}
