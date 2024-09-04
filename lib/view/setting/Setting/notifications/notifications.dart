import 'package:be_fit/models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/setting/cubit.dart';
import 'package:be_fit/view_model/setting/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingStates>(
      builder: (context, state) {
        SettingCubit.getInstance(context).setNotificationOptions();
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Notifications Settings'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ListView.separated(
              itemBuilder: (context, index) =>
                  SettingCubit.getInstance(context).notificationOptions[index],
              separatorBuilder: (context, index) => SizedBox(
                height: 16.h,
              ),
              itemCount:
                  SettingCubit.getInstance(context).notificationOptions.length,
            ),
          ),
        );
      },
    );
  }
}
