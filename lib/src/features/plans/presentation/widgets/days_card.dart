import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/helpers/base_widgets/myText.dart';

class DaysCard extends StatelessWidget {
  final String firstText;
  final String secondText;
  const DaysCard({super.key,
    required this.firstText,
    required this.secondText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Constants.appColor,
      child: ListTile(
        title: MyText(
          text: firstText,
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
        trailing: MyText(
          text: secondText,
          fontSize: 20.sp,
        ),
      ),
    );
  }
}
