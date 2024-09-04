import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'modules/myText.dart';

class CardioRecordsModel extends StatelessWidget {
  const CardioRecordsModel({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        MyText(
          text: 'DATE',
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
        const Spacer(),
        MyText(
          text: 'TIME',
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
        const Spacer(),
      ],
    );
  }
}
