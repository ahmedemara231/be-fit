import 'package:flutter/material.dart';

class MyText extends StatelessWidget {

  String text;
  double? fontSize;
  FontWeight? fontWeight;
  int? maxLines;
  Color? color;
  TextDecoration? textDecoration;

  MyText({Key? key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.maxLines,
    this.color,
    this.textDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: TextOverflow.ellipsis,
      text,
      maxLines: maxLines?? 2,
      style: TextStyle(
        fontSize: fontSize ,
        fontWeight: fontWeight,
        color: color,
        decoration: textDecoration,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
