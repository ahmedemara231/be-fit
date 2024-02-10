import 'package:be_fit/models/widgets/modules/divider.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/setting/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/widgets/setting_model.dart';
import '../../view_model/setting/states.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late List<SettingModel> settingModel;

  @override
  void initState() {
    settingModel =
    [
      OtherOptions(icon: Icons.contact_phone_sharp, optionName: 'About Us & Contacting'),
      OtherOptions(icon: Icons.report_gmailerrorred_sharp, optionName: 'Report a problem'),
      OtherOptions(icon: Icons.tips_and_updates, optionName: 'Tips'),
      OtherOptions(icon: Icons.share, optionName: 'Share the app'),
      OtherOptions(icon: Icons.logout, optionName: 'Logout'),
    ];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit,SettingStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Setting',fontWeight: FontWeight.w500,),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SwitchOption(
                  icon: Icons.dark_mode,
                  optionName: 'Dark Mode',
                  value: CacheHelper.getInstance().sharedPreferences.getBool('appTheme')?? false,
                  onChanged: (newMode)async {
                    await SettingCubit.getInstance(context).changeAppTheme(newMode);
                  },
                ),
                const SizedBox(height: 16,),
                SwitchOption(
                  icon: Icons.notifications,
                  optionName: 'Notifications',
                  value: SettingCubit.getInstance(context).isEnabled,
                  onChanged: (value)
                  {
                    SettingCubit.getInstance(context).notificationState(value);
                  },
                ),
                const SizedBox(height: 16,),

                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => InkWell(
                      onTap: ()
                      {
                        switch(index)
                        {
                          case 0:
                            SettingCubit.getInstance(context).contacting(context);
                            break;
                          case 1:
                            SettingCubit.getInstance(context).reportProblem(context);
                            break;
                          case 2:
                            SettingCubit.getInstance(context).tips();
                            break;
                          case 3:
                            SettingCubit.getInstance(context).share();
                            break;
                          case 4:
                            SettingCubit.getInstance(context).logout(context);
                            break;
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4,
                        ),
                        child: Column(
                          children: [
                            settingModel[index],
                            const MyDivider(),
                          ],
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                    itemCount: settingModel.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}