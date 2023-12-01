import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Titles{
  static getTitleData() => FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 35,
        getTextStyles: (value) => const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
        getTitles: (value) {
          switch (value.toInt()){
            case 0:
              return '0';
            case 1:
              return '';
            case 2:
              return '';
            case 3:
              return '';
            case 4:
              return '';
            // case 2:
            //   return '2020';
            // case 5:
            //   return '2021';
            // case 8:
            //   return '2022';
          }
          return '';
        },
        margin: 5,
      ),
      leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,fontSize: 13,
          ),
          getTitles: (value){
            switch (value){
              case 1:
                return '1';
              case 2:
                return '2';
              case 3:
                return '3';
              case 4:
                return '4';
              case 5:
                return '5';
              case 6:
                return '6';
              case 7:
                return '7';
              case 8:
                return '8';
              case 9:
                return '9';
              case 10:
                return '10';
              // case 10000:
              //   return '10k';
              // case 20000:
              //   return '20k';
              // case 30000:
              //   return '30k';
              // case 40000:
              //   return '40k';
              // case 50000:
              //   return '50k';
              // case 60000:
              //   return '60k';
              // case 70000:
              //   return '70k';
            }
            return '';
          },
          reservedSize:  35,
          margin: 5
      )
  );
}