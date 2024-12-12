import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helpers/base_widgets/myText.dart';

class ScreenModel extends StatelessWidget {
  final String text;
  final String image;

  const ScreenModel({
    super.key,
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
        MyText(
          text: text,
          fontSize: 20.sp,
        )
      ],
    );
  }
}
