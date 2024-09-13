import 'package:flutter/cupertino.dart';

class BottomNavBarItem
{
  Widget icon;
  String title;
  Color selectedColor;

  BottomNavBarItem({
    required this.icon,
    required this.title,
    required this.selectedColor
  });
}