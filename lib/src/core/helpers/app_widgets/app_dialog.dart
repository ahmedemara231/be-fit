import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import '../../constants/constants.dart';
import '../global_data_types/dialog_inputs.dart';

class AppDialog
{
  static Future<void> show(BuildContext context, {required DialogInputs inputs})async {
    await PanaraConfirmDialog.show(
      context,
      color: Constants.appColor,
      message: inputs.title,
      confirmButtonText: inputs.confirmButtonText,
      cancelButtonText: inputs.cancelButtonText?? 'Cancel',
      onTapCancel: inputs.onTapCancel ??() {
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