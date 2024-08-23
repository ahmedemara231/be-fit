import 'package:flutter/material.dart';
import 'app_button.dart';
import 'modules/myText.dart';

class AuthComponent extends StatelessWidget {

  final void Function()? onPressed;
  final String buttonText;
  final String secondText;
  final void Function()? textButtonClick;

  const AuthComponent({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.secondText,
    required this.textButtonClick
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          onPressed: onPressed,
          text: buttonText,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyText(text: secondText),
            TextButton(
                onPressed: textButtonClick,
                child: MyText(text: 'sign up',)
            ),
          ],
        ),
      ],
    );
  }
}
