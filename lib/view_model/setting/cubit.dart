import 'dart:developer';

import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view/setting/Setting/contacting_us.dart';
import 'package:be_fit/view_model/setting/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../view/auth/login/login.dart';
import '../cache_helper/shared_prefs.dart';

class SettingCubit extends Cubit<SettingStates>
{
  SettingCubit(super.initialState);
  static SettingCubit getInstance(context) => BlocProvider.of(context);

  bool darkMode = false;
  Future<void> changeAppTheme(bool newMode)async
  {
    darkMode = newMode;
    await CacheHelper.instance.setAppTheme(darkMode);
    emit(ChangeAppThemeSuccessState());
  }

  void contacting(context)
  {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Contacting(),
        ),
    );
  }

  void reportProblem() {}
  void tips() {}

  Future<void> logout(context) async
  {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: MyText(text: 'are you sure to logout?',fontSize: 20,),
        actions: [
          TextButton(
              onPressed: ()
              {
                Navigator.pop(context);
              },
              child: MyText(text: 'Cancel',fontSize: 16,),
          ),
          TextButton(
              onPressed: () async
              {
                Navigator.pop(context);
                await CacheHelper.instance.kill().then((value)
                {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ), (route) => false,
                  );
                  // FirebaseAuth.instance.signOut();
                });
              },
              child: MyText(text: 'logout',fontSize: 16),
          ),
        ],
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
}