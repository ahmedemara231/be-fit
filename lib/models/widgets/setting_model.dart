import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'modules/myText.dart';

abstract class SettingModel extends StatelessWidget {
  final IconData icon;
  final String optionName;

  const SettingModel({
    required super.key,
    required this.icon,
    required this.optionName,
  });

  @override
  Widget build(BuildContext context);
}

class SwitchOption extends SettingModel {

  final void Function(bool)? onChanged;
  final bool? value;

  const SwitchOption({super.key,
    required super.icon,
    required super.optionName,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: MyText(
        text: optionName,
        fontWeight: FontWeight.w500,
        fontSize: 18.sp,
      ),
      trailing: Switch(
        value: value!,
        onChanged: onChanged,
      ),
    );
  }
}

class OtherOptions extends SettingModel {

  const OtherOptions({
    super.key,
    required super.icon,
    required super.optionName,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(icon),
        title: MyText(
          text: optionName,
          fontWeight: FontWeight.w500,
          fontSize: 18.sp,
        ),
        trailing: const Icon(Icons.arrow_forward_ios));
  }
}
