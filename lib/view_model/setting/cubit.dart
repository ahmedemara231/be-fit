import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view_model/setting/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view/auth/login/login.dart';
import '../cache_helper/shared_prefs.dart';

class SettingCubit extends Cubit<SettingStates>
{
  SettingCubit(super.initialState);
  static SettingCubit getInstance(context) => BlocProvider.of(context);

  void changeDarkMode() {}
  void contacting() {}
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
                await CacheHelper.kill().then((value)
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

}