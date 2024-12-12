import 'package:be_fit/src/core/extensions/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/data_source/local/cache_helper/shared_prefs.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import 'exercises.dart';

class BodyMuscles extends StatelessWidget {
  const BodyMuscles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: ListView(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: MyText(
                  text: 'Hello, ${CacheHelper.getInstance().getData('userData')[1]}',
                  fontSize: 18.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      MyText(
                        text: 'Select',
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      MyText(
                        text: 'Muscle',
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color: Constants.appColor,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => InkWell(
                          onTap: () => context.normalNewRoute(
                            ExercisesForMuscle(
                              muscleName: Constants.musclesList[index].text,
                              numberOfExercises: Constants.musclesList[index].numberOfExercises,
                            ),
                          ),
                          child: Constants.musclesList[index],
                        ),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 16.h,
                        ),
                    itemCount: Constants.musclesList.length),
              ),
            ],
          ),
        ),
      ),
    );
  }
}