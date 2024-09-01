import 'package:be_fit/models/data_types/dialog_inputs.dart';
import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import '../../constants/constants.dart';

class AppDialog
{
  static Future<void> showAppDialog(BuildContext context, {required DialogInputs inputs})async
  {
    await PanaraConfirmDialog.show(
      context,
      color: Constants.appColor,
      message: inputs.title,
      confirmButtonText: inputs.confirmButtonText,
      cancelButtonText: inputs.cancelButtonText?? 'Cancel',
      onTapCancel: () {
        Navigator.pop(context);
      },
      onTapConfirm: () {
        Navigator.pop(context);
        inputs.onTapConfirm();
      },
      panaraDialogType: PanaraDialogType.custom,
      barrierDismissible: false, // optional parameter (default is true)
    );
  }
}