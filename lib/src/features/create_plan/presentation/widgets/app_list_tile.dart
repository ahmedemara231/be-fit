import 'package:be_fit/src/features/create_plan/presentation/widgets/reps_sets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/base_widgets/image.dart';
import '../../../../core/helpers/base_widgets/myText.dart';

class AppListTile extends StatelessWidget {
  const AppListTile({Key? key,
    required this.exerciseImage,
    required this.exerciseName,
    required this.checkboxVal,
    required this.onChanged,
  }) : super(key: key);

  final String exerciseImage;
  final String exerciseName;
  final bool checkboxVal;

  final void Function(bool?) onChanged;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding:  EdgeInsets.all(8.0.r),
        child: MyNetworkImage(url: exerciseImage),
      ),
      title: MyText(
        text: exerciseName,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      ),
      trailing: Checkbox(
          value: checkboxVal,
          onChanged: onChanged
      ),
    );
  }
}