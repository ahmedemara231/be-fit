import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/model/remote/repositories/cardio/implementation.dart';
import 'package:be_fit/models/data_types/cardio_records.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/cardio/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../models/data_types/set_cardio_rec_model.dart';

class MyStopWatch extends StatefulWidget {

  final Exercises exercise;
  const MyStopWatch({super.key,
    required this.exercise
  });

  @override
  MyStopWatchState createState() => MyStopWatchState();
}

class MyStopWatchState extends State<MyStopWatch> {
  late StopWatchTimer _stopWatchTimer;
  final _isHours = true;
  List<String> actions = ['Start' , 'Stop', 'Reset'];

  @override
  void initState() {
    _stopWatchTimer = StopWatchTimer();
    super.initState();
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  int? value;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StreamBuilder<int>(
          stream: _stopWatchTimer.rawTime,
          initialData: _stopWatchTimer.rawTime.value,
          builder: (context, snapshot) {
            value = snapshot.data;
            final displayTime = StopWatchTimer.getDisplayTime(value!, hours: _isHours);
            return Text(
              displayTime,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              actions.length, (index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: ElevatedButton(
                onPressed: ()
                {
                  switch(index)
                  {
                    case 0:
                      _stopWatchTimer.onStartTimer();
                    case 1:
                      _stopWatchTimer.onStopTimer();
                      String result = calcResult();

                      CardioCubit.getInstance(context).setRecord(
                        repo: CardioRepo(
                            model: SetCardioRecModel(
                                exerciseId: widget.exercise.id,
                                inputs: CardioRecords(
                                    dateTime: Constants.dataTime,
                                    time: result
                                )
                            )
                        )
                      );
                    case 2:
                      _stopWatchTimer.onResetTimer();
                      CardioCubit.getInstance(context).getRecords(
                          context,
                          repo: CardioRepo(
                              exerciseId: widget.exercise.id
                          )
                      );
                  }
                },
                child: MyText(text: actions[index], color: Constants.appColor,),
                ),
              ),
            )
          ),
        ),
      ],
    );
  }
  String calcResult()
  {
    final elapsedTime = _stopWatchTimer.rawTime.value;
    final minutes = (elapsedTime / 60000).floor();
    final seconds = ((elapsedTime % 60000) / 1000).floor();
    return '$minutes : ${seconds.toString().padLeft(2, '0')}';
  }
}
