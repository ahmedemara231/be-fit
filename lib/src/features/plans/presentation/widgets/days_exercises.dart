import 'package:be_fit/src/core/extensions/container_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/base_widgets/image.dart';
import '../../../../core/helpers/base_widgets/myText.dart';

class DaysExercises extends StatelessWidget {
  final String imageUrl;
  final String exerciseName;
  final String setsAndReps;

  const DaysExercises({super.key,
    required this.imageUrl,
    required this.exerciseName,
    required this.setsAndReps,
});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: context.decoration()
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0.r),
        child: ListTile(
          leading: Padding(
            padding: EdgeInsets.all(10.0.r),
            child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                width: 60.w,
                height: 60.h,
                child: MyNetworkImage(
                  url: imageUrl
                )
            ),
          ),
          subtitle: MyText(
              text: exerciseName,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500
          ),
          trailing: Column(
            children: [
              FittedBox(
                child: MyText(
                    text: 'Sets X Reps',
                    fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(height: 7.h),
              MyText(
                  text: setsAndReps,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500
              ),
            ],
          ),
        ),
      ),
    );
  }
}
