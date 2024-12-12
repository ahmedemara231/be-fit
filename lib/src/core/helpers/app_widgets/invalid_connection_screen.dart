import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../base_widgets/myText.dart';
import 'app_button.dart';

class ErrorBuilder extends StatelessWidget {
  final String msg;
  final void Function()? onPressed;

  const ErrorBuilder({
    super.key,
    required this.msg,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 70,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: MyText(
              text: msg,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          AppButton(text: 'Try Again', onPressed: onPressed)
        ],
      ),
    );
  }
}
