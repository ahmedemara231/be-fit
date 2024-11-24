import 'package:audioplayers/audioplayers.dart';
import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/models/data_types/cardio_records.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/cardio/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../model/remote/firebase_service/fire_store/cardio/implementation.dart';
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
  List<String> actions = ['Start', 'Stop', 'Reset'];

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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayTime,
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),

                if(value! > 0)
                  ElevatedButton(
                    onPressed: ()async
                    {
                      String result = calcResult();

                      await CardioCubit.getInstance(context).setRecord(
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
                      await playFinishVoice();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: MyText(text: 'Add', color: Constants.appColor,),
                    ),
                  ),
              ],
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
                    case 2:
                      _stopWatchTimer.onResetTimer();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: MyText(text: actions[index], color: Constants.appColor,),
                ),
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

  Future<void> playFinishVoice()async
  {
    final player = AudioPlayer();
    final source = AssetSource('audio/finish_cardio.mp3');
    await player.play(source);
  }
}