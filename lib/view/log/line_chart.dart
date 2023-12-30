import 'package:be_fit/models/data_types/records_model.dart';
import 'package:be_fit/view/log/titles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final List<Color> gradiantColors = [
    Colors.redAccent,
    Colors.orangeAccent
  ];

  List<Records> records;

  LineChartWidget({super.key,
    required this.records,
  });
  @override
  Widget build(BuildContext context) {
    return LineChart(
        LineChartData(
            minX: 5,
            maxX: 400,
            minY: 1,
            maxY: 15,
            titlesData: Titles.getTitleData(),
            gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (value){
                return FlLine(
                    color: Colors.grey[800],
                    strokeWidth: 1
                );
              },
            ),
            borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey[800]!, width: 2)
            ),
            lineBarsData: List.generate(
                records.length, (index) => LineChartBarData(
              show: true,
              spots: [
                FlSpot(
                  records[index].weight,
                  records[index].reps,
                ),
                // FlSpot(50, 3),
                // FlSpot(200, 2),
              ],
              // isCurved: true,
              colors: gradiantColors,
              barWidth: 3,
              belowBarData: BarAreaData(
                  show: true,
                  colors: gradiantColors.map((color) => color.withOpacity(.4)).toList()
              ),
            )),

        )
    );
  }
}