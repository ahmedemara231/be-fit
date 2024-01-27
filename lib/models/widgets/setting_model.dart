import 'package:flutter/material.dart';

import 'modules/myText.dart';

abstract class SettingModel extends StatelessWidget {

  IconData icon;
  final String optionName;

  SettingModel({
    required this.icon,
    required this.optionName,
});

  @override
  Widget build(BuildContext context);
}

class DarkModeOption extends SettingModel
{
  void Function(bool)? onChanged;
  bool? value;
  DarkModeOption({
    required super.icon,
    required super.optionName,
    required this.value,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: MyText(text: optionName,fontWeight: FontWeight.w500,fontSize: 18,),
      trailing: Switch(
        value: value!,
        onChanged: onChanged,
      ),
    );
  }
}

class OtherOptions extends SettingModel
{
  OtherOptions({
    required super.icon,
    required super.optionName,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(icon),
        title: MyText(text: optionName,fontWeight: FontWeight.w500,fontSize: 18,),
        trailing: const Icon(Icons.arrow_forward_ios)
    );
  }
}
