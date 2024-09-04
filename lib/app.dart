import 'package:be_fit/view/cardio/cardio_exercise.dart';
import 'package:be_fit/view/onBoarding/page_view.dart';
import 'package:be_fit/view/plans/create_plan/create_plan.dart';
import 'package:be_fit/view/splash.dart';
import 'package:be_fit/view_model/bottomNavBar/cubit.dart';
import 'package:be_fit/view_model/bottomNavBar/states.dart';
import 'package:be_fit/view_model/cardio/cubit.dart';
import 'package:be_fit/view_model/cardio/states.dart';
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
          create: (context) => BottomNavCubit(BottomNavState()),
        ),
        BlocProvider(
          create: (context) => ExercisesCubit(ExercisesInitialState()),
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
        BlocProvider(
          create: (context) => CardioCubit(CardioInitialState())
        ),
      ],
      child: BlocBuilder<SettingCubit, SettingStates>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp(
                theme: CacheHelper.getInstance().shared.getBool('appTheme') == false
                        ? ThemeData.light()
                        : ThemeData.dark(),
                debugShowCheckedModeBanner: false,
                home:  Splash(),
                builder: EasyLoading.init(),
            ),
          );
        },
      ),
    );
  }
}
