import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'modules/myText.dart';

class DefaultAndCustomButtons extends StatelessWidget {
  String text;
  void Function()? onTap;
  Color? color;

  DefaultAndCustomButtons({super.key,
    required this.text,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: const Border(
            right: BorderSide(color: Colors.white),
            bottom: BorderSide(color: Colors.white),
            top: BorderSide(color: Colors.white),
            left: BorderSide(color: Colors.white),
          ),
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        width: context.setWidth(2.5),
        height: context.setWidth(8),
        child: Center(child: MyText(text: text,fontSize: 18)),
      ),
    );
  }
}
