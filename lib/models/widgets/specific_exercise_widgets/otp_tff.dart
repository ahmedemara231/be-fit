import 'package:be_fit/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpTff extends StatelessWidget {
  var controller;
  String hintText;

  OtpTff({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      width: 150.w,
      child: TextFormField(
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Constants.appColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
