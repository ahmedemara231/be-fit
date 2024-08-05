import 'package:be_fit/models/widgets/modules/myText.dart';
import 'package:flutter/material.dart';

class ScreenModel extends StatelessWidget {

  final String text;
  final String image;

  const ScreenModel({super.key,
    required this.image,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Image.asset('images/$image.png'),
        ),
        MyText(text: text, fontSize: 20,)
      ],
    );
  }
}
