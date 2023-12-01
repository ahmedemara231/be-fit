import 'package:be_fit/view/log/titles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final List<Color> gradiantColors = [
    Colors.redAccent,
    Colors.orangeAccent
  ];

  List<double> reps;

  LineChartWidget({super.key,
    required this.reps,
  });
  @override
  Widget build(BuildContext context) {
    return LineChart(
        LineChartData(
            minX: 0,
            maxX: 1000,
            minY: 1,
            maxY: 50,
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
                reps.length, (index) => LineChartBarData(
              show: true,
              spots: [
                // المفروض كل spot ازود 1 على محور x
                FlSpot(
                    (index + 1).toDouble(),
                    reps[index],
                ),
                // FlSpot(1, 3),
                // FlSpot(2, 2),
                // FlSpot(3, 6),
                // FlSpot(4, 4),
                // FlSpot(0,30000),
                // FlSpot(2.5,10000),
                // FlSpot(4,50000),
                // FlSpot(6,43000),
                // FlSpot(8,40000),
                // FlSpot(9,30000),
                // FlSpot(11,38000),
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