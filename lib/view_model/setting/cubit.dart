import 'dart:developer';
import 'package:be_fit/constants.dart';
import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/data_types/report.dart';
import 'package:be_fit/view/setting/Setting/contacting_us.dart';
import 'package:be_fit/view/setting/Setting/notifications/notifications.dart';
import 'package:be_fit/view_model/login/cubit.dart';
import 'package:be_fit/view_model/setting/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/widgets/modules/myText.dart';
import '../../models/widgets/setting_model.dart';
import '../../view/auth/login/login.dart';
import '../../view/setting/Setting/report_problem/reports.dart';
import '../../view/setting/Setting/report_problem/report_problem.dart';
import '../cache_helper/shared_prefs.dart';

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
        value: CacheHelper.getInstance().sharedPreferences.getBool('appTheme'),
        onChanged: (newMode)async {
          await changeAppTheme(newMode);
        },
      ),
      OtherOptions(icon: Icons.notifications, optionName: 'Notifications'),
      OtherOptions(icon: Icons.contact_phone_sharp, optionName: 'About Us & Contacting'),
      OtherOptions(icon: Icons.report_gmailerrorred_sharp, optionName: 'Report a problem'),
      OtherOptions(icon: Icons.tips_and_updates, optionName: 'Tips'),
      OtherOptions(icon: Icons.share, optionName: 'Share the app'),
      OtherOptions(icon: Icons.logout, optionName: 'Logout'),
    ];
  }

  bool darkMode = false;
  Future<void> changeAppTheme(bool newMode)async
  {
    darkMode = newMode;
    await CacheHelper.getInstance().setAppTheme(darkMode);
    emit(ChangeAppThemeSuccessState());
  }

  bool isEnabled = false;
  void notifications(context)
  {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Notifications(),
        ),
    );
  }

  List<SwitchOption> notificationOptions = [];
  void setNotificationOptions()
  {
    notificationOptions =
    [
      SwitchOption(
        icon: Icons.notifications,
        optionName: 'notifications everyday',
        value: CacheHelper.getInstance().sharedPreferences.getBool('notificationsEveryDay')?? false,
        onChanged: (value) async
        {
          await setNotificationsOnEveryDay(value);
        },
      ),
      SwitchOption(
        icon: Icons.notifications,
        optionName: 'notification on workout days',
        value: CacheHelper.getInstance().sharedPreferences.getBool('notificationsOnWorkoutDays')?? false,
        onChanged: (value) async
        {
          await setNotificationsOnWorkoutDays(value);
        },
      ),
    ];
  }

  Future<void> setNotificationsOnEveryDay(bool value)async
  {
    await CacheHelper.getInstance().setNotificationsOnEveryDay(everyday: value);
    emit(ChangeNotificationEveryDayState());
  }

  Future<void> setNotificationsOnWorkoutDays(bool value)async
  {
    await CacheHelper.getInstance().setNotificationsOnWorkoutDays(onWorkoutDays: value);
    emit(ChangeNotificationsOnWorkoutDays());
  }

  // Contacting
  void contacting(context)
  {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Contacting(),
        ),
    );
  }

  Future<void> contactingPhoneClick({required String phone})async
  {
    Uri mobileNumber = Uri.parse(phone);
    launchUrl(mobileNumber);
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
          'dateTime' : Jiffy().yMMMMEEEEdjm,
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
      value.docs.forEach((element) {
        reports.add(
          Report(
            problem: element.data()['problem'],
            dateTime: element.data()['dateTime'],
          ),
        );
      });
      emit(GetAllReportsSuccessState());
    }).catchError((error)
    {
      emit(GetAllReportsErrorState());
    });
  }

  void tips() {}

  Future<void> share()async
  {
    final result = await Share.shareWithResult('check out my website https://example.com');

    if (result.status == ShareResultStatus.success) {
      log('Thank you for sharing my app!');
    }
  }

  void personalData(BuildContext context, Widget newRoute)
  {
    context.normalNewRoute(newRoute);
  }

  Future<void> setNewUserData({String? userName, String? email})async
  {
    emit(ChangePersonalDataLoadingState());
    await CacheHelper.getInstance().handleUserData(
        userData: [
          userName?? CacheHelper.getInstance().userName,
          email?? ''
        ],
    ).then((value)
    {
      emit(ChangePersonalDataSuccessState());
    });
  }

  Future<void> logout(context) async
  {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Container(
            decoration: BoxDecoration(
                color: CacheHelper.getInstance().sharedPreferences.getBool('appTheme') == false?
                Colors.grey[300]:
                Constants.scaffoldBackGroundColor,

                border: context.decoration()
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyText(
                    text: 'Logout',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MyText(
                      text: 'Are you sure to logout?',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: ()
                          {
                            Navigator.pop(context);
                          },
                          child: MyText(text: 'Cancel',fontSize: 14,),
                        ),
                        const SizedBox(
                          width: 22,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.appColor,
                          ),
                          onPressed: () async
                          {
                            Navigator.pop(context);

                            if(CacheHelper.getInstance().sharedPreferences.getBool('isGoogleUser') == true)
                            {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ), (route) => false,
                              );
                              await LoginCubit.getInstance(context).google.disconnect();
                              await CacheHelper.getInstance().kill();
                              await CacheHelper.getInstance().killGoogleUser();
                            }
                            else{
                              await CacheHelper.getInstance().kill().then((value)
                              {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ), (route) => false,
                                );
                              });
                            }
                          },
                          child: MyText(text: 'Yes, Logout',fontSize: 14),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}