import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/data_types/dialog_inputs.dart';
import 'package:be_fit/models/data_types/report.dart';
import 'package:be_fit/models/widgets/app_dialog.dart';
import 'package:be_fit/view/setting/Setting/contacting_us.dart';
import 'package:be_fit/view/setting/Setting/notifications/notifications.dart';
import 'package:be_fit/view_model/bottomNavBar/cubit.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/setting/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/local/cache_helper/shared_prefs.dart';
import '../../models/data_types/permission_process_model.dart';
import '../../models/methods/check_permission.dart';
import '../../models/widgets/setting_model.dart';
import '../../view/auth/login/login.dart';
import '../../view/setting/Setting/report_problem/reports.dart';
import '../../view/setting/Setting/report_problem/report_problem.dart';

class SettingCubit extends Cubit<SettingStates>
{
  SettingCubit(super.initialState);
  static SettingCubit getInstance(context) => BlocProvider.of(context);

  late List<SettingModel> settingModel;

  void createSettings(context)
  {
    settingModel =
    [
      SwitchOption(
        icon: Icons.dark_mode,
        optionName: 'Dark Mode',
        value: CacheHelper.getInstance().shared.getBool('appTheme')?? true,
        onChanged: (newMode)async {
          await changeAppTheme(newMode);
        },
      ),
      OtherOptions(icon: Icons.notifications, optionName: 'Notifications'),
      OtherOptions(icon: Icons.contact_phone_sharp, optionName: 'About Us & Contacting'),
      OtherOptions(icon: Icons.report_gmailerrorred_sharp, optionName: 'Report a problem'),
      OtherOptions(icon: Icons.share, optionName: 'Share the app'),
      OtherOptions(icon: Icons.star_rate_rounded, optionName: 'Rate us'),
      OtherOptions(icon: Icons.logout, optionName: 'Logout'),
    ];
  }

  bool darkMode = false;
  Future<void> changeAppTheme(bool newMode)async
  {
    darkMode = newMode;
    await CacheHelper.getInstance().setData(key: 'appTheme', value: darkMode);
    emit(ChangeAppThemeSuccessState());
  }

  bool isEnabled = false;
  void notifications(BuildContext context)
  {
    context.normalNewRoute(const Notifications());
  }

  List<SwitchOption> notificationOptions = [];
  void setNotificationOptions()
  {
    notificationOptions =
    [
      SwitchOption(
        icon: Icons.notifications,
        optionName: 'notifications everyday',
        value: CacheHelper.getInstance().shared.getBool('notificationsEveryDay')?? false,
        onChanged: (value) async
        {
          await setNotificationsOnEveryDay(value);
        },
      ),
      SwitchOption(
        icon: Icons.notifications,
        optionName: 'notification on workout days',
        value: CacheHelper.getInstance().shared.getBool('notificationsOnWorkoutDays')?? false,
        onChanged: (value) async
        {
          await setNotificationsOnWorkoutDays(value);
        },
      ),
    ];
  }

  Future<void> setNotificationsOnEveryDay(bool value)async
  {
    await CacheHelper.getInstance().setData(key: 'notificationsEveryDay', value: value);
    emit(ChangeNotificationEveryDayState());
  }

  Future<void> setNotificationsOnWorkoutDays(bool value)async
  {
    await CacheHelper.getInstance().setData(key: 'notificationsOnWorkoutDays', value: value);
    emit(ChangeNotificationsOnWorkoutDays());
  }

  // Contacting
  void contacting(BuildContext context)
  {
    context.normalNewRoute(Contacting());
  }

  Future<void> contactingPhoneClick({required String phone})async
  {
    checkPermission(
      PermissionProcessModel(
        permissionClient: PermissionClient.contacts,
        onPermissionGranted: () {
          Uri mobileNumber = Uri.parse(phone);
          launchUrl(mobileNumber);
        },
        onPermissionDenied: () {},
      ),
    );
  }

  Future<void> contactingEmailClick({required String emailAddress})async
  {
    Uri email = Uri.parse(emailAddress);
    await launchUrl(email);
  }

  // Reporting
  void reportProblem(BuildContext context)
  {
    context.normalNewRoute(ReportProblem());
  }

  Future<void> report(BuildContext context, {
    required String problem,
    required String uId
  })async
  {
    await FirebaseFirestore.instance
        .collection('problems')
        .add(
        {
          'problem' : problem,
          'dateTime' : Constants.dataTime,
          'uId' : uId,
        },
    ).then((value)
    {
     context.replacementRoute(const Reports());
      emit(SetAReportSuccessState());
    }).catchError((error)
    {
      emit(SetAReportErrorState());
    });
  }

  List<Report> reports = [];
  Future<void> getAllReports({
    required String uId,
  })async
  {
    reports = [];
    emit(GetAllReportsLoadingState());
    await FirebaseFirestore.instance
        .collection('problems')
        .where('uId',isEqualTo: uId)
        .get()
        .then((value)
    {
      for (var element in value.docs) {
        reports.add(
          Report(
            problem: element.data()['problem'],
            dateTime: element.data()['dateTime'],
          ),
        );
      }
      emit(GetAllReportsSuccessState());
    }).catchError((error)
    {
      emit(GetAllReportsErrorState());
    });
  }

  Future<void> share(context)async
  {
    final result = await Share.shareWithResult('https://play.google.com/store/apps/details?id=com.app.be_fit&pcampaignid=web_share');

    if (result.status == ShareResultStatus.success) {
      AnimatedSnackBar.material(
        'Thank you for sharing the app!',
        type: AnimatedSnackBarType.info,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom
      ).show(context);
    }
  }

  void personalData(BuildContext context, Widget newRoute)
  {
    context.normalNewRoute(newRoute);
  }

  Future<void> rate()async
  {
    final InAppReview inAppReview = InAppReview.instance;

      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
  }

  Future<void> logout(context) async
  {
    await AppDialog.showAppDialog(
        context,
        inputs: DialogInputs(
            title: 'Are you sure to logout ?',
            confirmButtonText: 'Yes, Logout',
          onTapConfirm: ()async {
            makeLogout(context);
            await Future.delayed(const Duration(milliseconds: 250));

            if(CacheHelper.getInstance().shared.getBool('isGoogleUser') == true)
            {
              await finishLogoutWhenGoogleUser(context);
            }
            else{
              await finishLogoutWhenNormalUser();
            }
          },
        )
    );
  }

  Future<void> emptyCache()async
  {
    await CacheHelper.getInstance().setData(key: 'userData', value: <String>[]);
  }

  Future<void> finishLogoutWhenNormalUser()async
  {
    FirebaseAuth.instance.signOut();
    await emptyCache();
  }

  Future<void> emptyGoogleUserCache()async
  {
    await CacheHelper.getInstance().setData(key: 'isGoogleUser', value: false);
    await emptyCache();
  }

  Future<void> finishLogoutWhenGoogleUser(context)async
  {
    GoogleSignIn().disconnect();
    await emptyGoogleUserCache();
  }

  void makeLogout(BuildContext context)
  {
    Navigator.pop(context);
    context.removeOldRoute(const Login());
    BottomNavCubit.getInstance(context).returnToFirst();
    PlansCubit.getInstance(context).allPlans.clear();
    ExercisesCubit.getInstance(context).customExercises.clear();
  }
}

Future<void> checkForUpdate() async {
  InAppUpdate.checkForUpdate().then((info)async {
    print(1);
    print(info.flexibleUpdateAllowed);
    if(info.flexibleUpdateAllowed)
      {
        print(info.flexibleUpdateAllowed);
        // await InAppUpdate.completeFlexibleUpdate();
      }
  });
}