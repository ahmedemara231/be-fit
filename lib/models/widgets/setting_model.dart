import 'package:be_fit/modules/myText.dart';
import 'package:flutter/material.dart';

class SettingModel extends StatelessWidget {

  final String optionName;
  bool darkModeOption;
  void Function(bool)? onChanged;
  bool? value;

  SettingModel({super.key,
    required this.optionName,
    required this.darkModeOption,
    this.value,
    this.onChanged,
  });


  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: MyText(text: optionName,fontSize: 18,fontWeight: FontWeight.w500),
        trailing: darkModeOption? Switch(
            value: value!,
            onChanged: onChanged,
        ):
        const Icon(Icons.arrow_forward_ios),
      );
  }
}
