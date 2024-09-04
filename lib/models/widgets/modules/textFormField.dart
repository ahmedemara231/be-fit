import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TFF extends StatelessWidget {
  String? hintText;
  TextStyle? hintStyle;
  String? labelText;
  TextStyle? labelStyle;
  Widget? prefixIcon;
  Color? prefixIconColor;
  Widget? suffixIcon;
  bool obscureText;
  var border;
  var enabledBorder;
  TextInputType? keyboardType;
  TextEditingController controller;
  void Function(String)? onChanged;
  void Function()? onPressed;
  void Function(String)? onFieldSubmitted;
  String? Function(String?)? validator;

  TFF({
    super.key,
    required this.obscureText,
    required this.controller,
    this.hintText,
    this.hintStyle,
    this.labelText,
    this.labelStyle,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.keyboardType,
    this.onPressed,
    this.onChanged,
    this.onFieldSubmitted,
    this.border,
    this.enabledBorder,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      validator: validator ??
          (value) {
            if (value!.isEmpty) {
              return 'This Field is required';
            }
          },
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        border: border,
        enabledBorder: enabledBorder,
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: labelText,
        labelStyle: labelStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
      ),
    );
  }
}
