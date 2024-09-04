import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/constants.dart';
import '../../view/statistics/statistics.dart';
import 'modules/myText.dart';

class ExerciseAppBar extends StatelessWidget implements PreferredSizeWidget {

  final Exercises exercise;
  const ExerciseAppBar({super.key,
    required this.exercise
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: MyText(
        text: exercise.name,
        fontWeight: FontWeight.w500,
      ),
      actions: [
        TextButton(
            onPressed: () {
              context.normalNewRoute(
                  Statistics(
                    exercise: exercise,
                  )
              );
            },
            child: MyText(
              text: 'Statistics',
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Constants.appColor,
            ))
      ],
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 60.h);
}