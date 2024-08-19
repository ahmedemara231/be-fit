import 'package:be_fit/models/widgets/app_button.dart';
import '../../../models/widgets/modules/myText.dart';
import 'package:flutter/material.dart';

class ErrorBuilder extends StatelessWidget {

  final String msg;
  final void Function()? onPressed;

  const ErrorBuilder({super.key,
    required this.msg,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          AppButton(text: 'Try Again',onPressed: onPressed,)
        ],
      ),
    );
  }
}
