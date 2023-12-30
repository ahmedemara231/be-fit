import 'package:be_fit/modules/myText.dart';
import 'package:flutter/material.dart';

class SettingModel extends StatelessWidget {

  final optionName;
  const SettingModel({super.key,
    required this.optionName,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: MyText(text: optionName,fontSize: 18,fontWeight: FontWeight.w500),
        trailing: const Icon(Icons.arrow_forward_ios),
      );
  }
}
