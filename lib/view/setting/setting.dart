import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view_model/setting/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/widgets/setting_model.dart';
import '../../view_model/setting/states.dart';

class Setting extends StatelessWidget {
  Setting({super.key});

  List<SettingModel> settingModel =
  const [
    SettingModel(optionName: 'Dark Mode'),
    SettingModel(optionName: 'About Us & Contacting'),
    SettingModel(optionName: 'Report a problem'),
    SettingModel(optionName: 'Tips'),
    SettingModel(optionName: 'Logout'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit,SettingStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Setting',fontWeight: FontWeight.w500,),
          ),
          body: ListView.separated(
            itemBuilder: (context, index) => InkWell(
              onTap: ()
              {
                switch(index)
                {
                  case 0:
                    SettingCubit.getInstance(context).changeDarkMode();
                    break;
                  case 1:
                    SettingCubit.getInstance(context).contacting();
                    break;
                  case 2:
                    SettingCubit.getInstance(context).reportProblem();
                    break;
                  case 3:
                    SettingCubit.getInstance(context).tips();
                    break;
                  case 4:
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
        );
      },
    );
  }
}