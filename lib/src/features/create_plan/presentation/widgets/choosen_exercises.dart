import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/base_widgets/image.dart';
import '../../../../core/helpers/base_widgets/myText.dart';

class ChosenExercises extends StatelessWidget {
  const ChosenExercises({Key? key,
    required this.imageUrl,
    required this.exerciseName,
    required this.setsAndReps,
  }) : super(key: key);

  final String imageUrl;
  final String exerciseName;
  final String setsAndReps;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(padding: EdgeInsets.all(10.0.r),
          child: SizedBox(
              width: 80.w,
              height: 80.h,
              child: MyNetworkImage(url: imageUrl)
          )
      ),
      subtitle: MyText(
        text: exerciseName,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      ),
      trailing: FittedBox(
        child: Column(
          children: [
            MyText(
              text: 'Sets X Reps',
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
            SizedBox(height: 7.h),
            MyText(
              text: setsAndReps,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
