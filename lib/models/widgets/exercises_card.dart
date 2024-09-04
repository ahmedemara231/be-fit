import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'modules/image.dart';
import 'modules/myText.dart';

class ExercisesCard extends StatelessWidget {

  final String imageUrl;
  final String title;
  final Widget? trailing;

  const ExercisesCard({super.key,
    required this.imageUrl,
    required this.title,
    this.trailing
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:  EdgeInsets.all(8.0.r),
        child: ListTile(
          leading: MyNetworkImage(
              url: imageUrl
          ),
          title: MyText(
            text: title,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
          trailing: trailing?? const Icon(Icons.arrow_forward)
        ),
      ),
    );
  }
}
