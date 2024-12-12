import 'dart:developer';

import 'package:be_fit/src/core/data_source/local/cache_helper/shared_prefs.dart';
import 'package:be_fit/src/core/helpers/global_data_types/permission_process_model.dart';
import 'package:be_fit/src/core/helpers/methods/check_permission.dart';
import 'package:be_fit/src/features/auth/presentation/bloc/cubit.dart';
import 'package:be_fit/src/features/auth/presentation/screens/login.dart';
import 'package:be_fit/src/features/bottom_bar/presentation/bloc/cubit.dart';
import 'package:be_fit/src/features/bottom_bar/presentation/bottom_nav_bar.dart';
import 'package:be_fit/src/features/cardio/presentation/bloc/cardio_cubit.dart';
import 'package:be_fit/src/features/create_plan/presentation/bloc/cubit.dart';
import 'package:be_fit/src/features/exercises/data/dependency_injection/bloc.dart';
import 'package:be_fit/src/features/exercises/presentation/blocs/exercises/cubit.dart';
import 'package:be_fit/src/features/plans/presentation/bloc/cubit.dart';
import 'package:be_fit/src/features/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

class BeFitApp extends StatefulWidget {
  const BeFitApp({super.key});

  @override
  State<BeFitApp> createState() => _BeFitAppState();
}

class _BeFitAppState extends State<BeFitApp> {
  @override
  void initState() {
    // ExercisesDependencies.exercisesStream.listen((event) {
    //   log('some event');
    //   setState(() {});
    // });
    // checkPermission(
    //   PermissionProcessModel(
    //     permissionClient: PermissionClient.notification,
    //     onPermissionGranted: () {},
    //     onPermissionDenied: () {},
    //   ),
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavCubit(),),
        // BlocProvider(create: (context) => SettingCubit()),
        BlocProvider(create: (context) => GetIt.instance.get<ExercisesCubit>()),
        BlocProvider(create: (context) => GetIt.instance.get<PlanCreationCubit>(),),
        BlocProvider(create: (context) => GetIt.instance.get<AuthCubit>(),),
        BlocProvider(create: (context) => GetIt.instance.get<NewCardioCubit>(),),
        BlocProvider(create: (context) => GetIt.instance.get<PlansCubit>()..getPlans()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
            title: 'Be Fit',
            theme: CacheHelper.getInstance().shared.getBool('appTheme') == false
                    ? ThemeData.light()
                    : ThemeData.dark(),
            debugShowCheckedModeBanner: false,
            home: const BottomNavBar(),
            builder: EasyLoading.init(),
        ),
      ),
    );
  }
}