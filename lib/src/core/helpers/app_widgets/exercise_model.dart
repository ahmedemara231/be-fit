import 'package:be_fit/src/core/extensions/container_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../base_widgets/myText.dart';

class ExerciseModel extends StatelessWidget {
  String imageUrl;
  String text;
  int numberOfExercises;
  ExerciseModel({
    super.key,
    required this.imageUrl,
    required this.text,
    required this.numberOfExercises,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(border: context.decoration()),
        child: Padding(
          padding:  EdgeInsets.all(10.0.r),
          child: ListTile(
            leading: Image.asset('images/$imageUrl.png'),
            title: MyText(
              text: text,
              fontSize: 22.sp,
              fontWeight: FontWeight.w500,
            ),
            subtitle: MyText(
              text: '$numberOfExercises Exercises',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            trailing: const Icon(Icons.arrow_forward),
          ),
        ),
      ),
    );
  }
}
