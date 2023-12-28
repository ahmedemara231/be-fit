import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view/log/chart_screen.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/log/cubit.dart';
import 'package:be_fit/view_model/log/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Log extends StatefulWidget {

  String exerciseId;
  String muscleName;
  bool isCustom;
   Log({super.key,
    required this.exerciseId,
     required this.muscleName,
     required this.isCustom,
  });

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {

  @override
  void initState() {
    if(widget.isCustom == true)
      {
        LogCubit.getInstance(context).sendRecordsToMakeChartForSpeExer(
          exerciseId: widget.exerciseId,
          uId: CacheHelper.uId
        );
      }
    else{
      LogCubit.getInstance(context).sendRecordsToMakeChart(
        muscleName: widget.muscleName,
        exerciseId: widget.exerciseId,
      );
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogCubit,LogStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Statistics'),
          ),
          body: ChartScreen(
            records: widget.isCustom?
                LogCubit.getInstance(context).recordsRepsForSpecExercise :
                LogCubit.getInstance(context).recordsRepsForExercise,
          ),
        );
      },
    );
  }
}
