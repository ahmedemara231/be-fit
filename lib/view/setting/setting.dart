import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view_model/setting/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/widgets/setting_model.dart';
import '../../view_model/setting/states.dart';

class Setting extends StatefulWidget {
  Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late List<SettingModel> settingModel;

  @override
  void initState() {
    settingModel =
    [
      SettingModel(darkModeOption: false,optionName: 'About Us & Contacting'),
      SettingModel(darkModeOption: false,optionName: 'Report a problem'),
      SettingModel(darkModeOption: false,optionName: 'Tips'),
      SettingModel(darkModeOption: false,optionName: 'Logout'),
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
          body: Column(
            children: [
              SettingModel(
                darkModeOption: true,
                optionName: 'Dark Mode',
                value: SettingCubit.getInstance(context).darkMode,
                onChanged: (newMode)async
                {
                  await SettingCubit.getInstance(context).changeAppTheme(newMode);
                },
              ),
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
                          SettingCubit.getInstance(context).reportProblem();
                          break;
                        case 2:
                          SettingCubit.getInstance(context).tips();
                          break;
                        case 3:
                          SettingCubit.getInstance(context).logout(context);
                          break;
                      }
                    },
                    child: settingModel[index],
                  ),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 16,
                  ),
                  itemCount: settingModel.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}