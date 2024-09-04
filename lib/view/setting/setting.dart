import 'package:be_fit/models/widgets/modules/divider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/setting/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/data_types/dialog_inputs.dart';
import '../../models/widgets/app_dialog.dart';
import '../../view_model/setting/states.dart';
import 'package:in_app_update/in_app_update.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Future<void> _checkForUpdate(BuildContext context) async {
    AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      _showUpdateDialog(context, info: updateInfo);
    }
  }

  void _showUpdateDialog(BuildContext context,
      {required AppUpdateInfo info}) async {
    AppDialog.showAppDialog(context,
        inputs: DialogInputs(
          title: 'There is an Available update, update now?',
          confirmButtonText: 'Update',
          onTapConfirm: () async => await _startFlexibleUpdate(info),
        ));
  }

  Future<void> _startFlexibleUpdate(AppUpdateInfo info) async {
    if (info.updateAvailability == UpdateAvailability.updateAvailable) {
      InAppUpdate.performImmediateUpdate();
    }
  }

  @override
  void initState() {
    // _checkForUpdate(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingStates>(
      builder: (context, state) {
        SettingCubit.getInstance(context).createSettings(context);
        return Scaffold(
          appBar: AppBar(
            title: MyText(
              text: 'Setting',
              fontWeight: FontWeight.w500,
            ),
          ),
          body: Padding(
            padding:  EdgeInsets.all(8.0.r),
            child: ListView.separated(
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  switch (index) {
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
                      SettingCubit.getInstance(context).rate();
                      break;
                    case 6:
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
              separatorBuilder: (context, index) => SizedBox(
                height: 16.h,
              ),
              itemCount: SettingCubit.getInstance(context).settingModel.length,
            ),
          ),
        );
      },
    );
  }
}
