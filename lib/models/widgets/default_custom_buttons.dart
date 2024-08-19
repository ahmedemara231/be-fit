import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:flutter/material.dart';
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
          border: context.decoration(),
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
