import 'package:be_fit/models/records_model.dart';
import 'package:be_fit/view_model/log/cubit.dart';
import 'package:be_fit/view_model/log/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'line_chart.dart';

class ChartScreen extends StatelessWidget {

  List<Records> records;

  ChartScreen({super.key,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogCubit,LogStates>(
      builder: (context, state)
      {
        return Scaffold(
          backgroundColor: Colors.black12,
          body:
          SingleChildScrollView(
            child:
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: LineChartWidget(
                records: records,
              ),
            ),
          ),
        );
      },
    );
  }
}
