import 'package:animation_list/animation_list.dart';
import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/widgets/modules/myText.dart';
import 'package:be_fit/models/widgets/specific_exercise_widgets/carousel_slider.dart';
import 'package:be_fit/view/cardio/stop_watch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../model/local/cache_helper/shared_prefs.dart';
import '../../models/widgets/cardio_records_model.dart';
import '../../models/widgets/specific_exercise_app_bar.dart';

class SpecificCardioExercise extends StatelessWidget {

  final Exercises exercise;
  SpecificCardioExercise({super.key,
    required this.exercise
  });

  final stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp
  );

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ExerciseAppBar(exercise: exercise),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
        child: ListView(
          children: [
            MyCarousel(images: exercise.image),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('cardio')
                    .doc(exercise.id)
                    .collection('records')
                    .where('uId', isEqualTo: CacheHelper.getInstance().shared.getStringList('userData')?[0])
                    .snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData)
                    {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: snapshot.data!.docs.isEmpty
                            ? null : SizedBox(
                          height: context.setHeight(2.8),
                          child: Container(
                            decoration: BoxDecoration(border: context.decoration()),
                            child: Padding(
                              padding:  EdgeInsets.all(8.0.r),
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: CardioRecordsModel(),
                                  ),
                                  Expanded(
                                    child: AnimationList(
                                        duration: 1000,
                                        reBounceDepth: 10.0,
                                        children: List.generate(
                                          snapshot.data!.docs.length,
                                              (index) => Padding(
                                            padding:  EdgeInsets.all(8.0.r),
                                            child: Row(
                                              children: [
                                                const Spacer(),
                                                SizedBox(
                                                  width: 100.w,
                                                  child: Column(
                                                    children: [
                                                      MyText(
                                                        text: snapshot
                                                            .data?.docs[index]
                                                            .data()['dateTime'],
                                                        fontSize: 22.sp,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                                Column(
                                                  children: [
                                                    MyText(
                                                      text:
                                                      '${snapshot.data?.docs[index].data()['time']}',
                                                      fontSize: 22.sp,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  else if(snapshot.hasError)
                    {
                      return MyText(text: 'error');
                    }
                  else{
                    return MyText(text: 'Loading...');
                  }
                },
            ),
            const Spacer(),
            MyStopWatch(exercise: exercise)
          ],
        ),
      ),
    );
  }
}