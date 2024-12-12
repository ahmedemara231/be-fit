import 'package:be_fit/src/core/extensions/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../screens/choose_exercises.dart';

class DayCard extends StatelessWidget {
  const DayCard({Key? key,
    required this.index,
  }) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return  Card(
      color: Constants.appColor,
      child: Padding(
        padding:  EdgeInsets.all(8.0.r),
        child: ListTile(
            leading: MyText(
              text: 'Day ${index + 1}',
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
            trailing: IconButton(
              onPressed: () => context.normalNewRoute(
                ChooseExercises(
                  day: index + 1,
                ),
              ),
              icon: const Icon(Icons.add),
            )),
      ),
    );
  }
}
