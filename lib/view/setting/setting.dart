import 'package:be_fit/models/widgets/modules/divider.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/setting/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/setting/states.dart';


class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit,SettingStates>(
      builder: (context, state)
      {
        SettingCubit.getInstance(context).createSettings(context);
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Setting',fontWeight: FontWeight.w500,),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemBuilder: (context, index) => InkWell(
                onTap: ()
                {
                  switch(index)
                  {
                    case 1:
                      SettingCubit.getInstance(context).notifications(context);
                      break;
                    case 2:
                      SettingCubit.getInstance(context).contacting(context);
                      break;
                    case 3:
                      SettingCubit.getInstance(context).reportProblem(context);
                      break;
                    case 4:
                      SettingCubit.getInstance(context).share(context);
                      break;
                    case 5:
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
                      SettingCubit.getInstance(context).settingModel[index],
                      const MyDivider(),
                    ],
                  ),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(
                height: 16,
              ),
              itemCount:  SettingCubit.getInstance(context).settingModel.length,
            ),
          ),
        );
      },
    );
  }
}