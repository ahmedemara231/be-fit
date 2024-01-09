// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// class Titles{
//
//   static getTitleData() => FlTitlesData(
//       show: true,
//       bottomTitles: SideTitles(
//         showTitles: true,
//         reservedSize: 50,
//         getTextStyles: (value) => const TextStyle(
//             fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
//         getTitles: (value) {
//               switch (value) {
//                 case 10:
//                   return '10';
//                 case 20:
//                   return '20';
//                 case 30:
//                   return '30';
//                 case 40:
//                   return '40';
//                 case 50:
//                   return '50';
//                 case 100:
//                   return '100';
//                 case 120:
//                   return '120';
//                 case 150:
//                   return '150';
//                 case 200:
//                   return '200';
//                 case 250:
//                   return '250';
//                 case 300:
//                   return '300';
//                 case 350:
//                   return '350';
//                 case 400:
//                   return '400';
//               }
//               return '';
//               //   case 5:
//               //     return '5';
//               //   case 10:
//               //     return '10';
//               //   case 15:
//               //     return '15';
//               //   case 20:
//               //     return '20';
//               //   case 25:
//               //     return '25';
//               //
//               // // case 2:
//               // //   return '2020';
//               // // case 5:
//               // //   return '2021';
//               // // case 8:
//               // //   return '2022';
//               // }
//         },
//         margin: 5,
//       ),
//       leftTitles: SideTitles(
//           showTitles: true,
//           getTextStyles: (value) => const TextStyle(
//             color: Colors.grey,
//             fontWeight: FontWeight.bold,fontSize: 13,
//           ),
//           getTitles: (value){
//             switch (value){
//               case 1:
//                 return '1';
//               case 2:
//                 return '2';
//               case 3:
//                 return '3';
//               case 4:
//                 return '4';
//               case 5:
//                 return '5';
//               case 6:
//                 return '6';
//               case 7:
//                 return '7';
//               case 8:
//                 return '8';
//               case 9:
//                 return '9';
//               case 10:
//                 return '10';
//               case 11:
//                 return '11';
//               case 12:
//                 return '12';
//               case 13:
//                 return '13';
//               case 14:
//                 return '14';
//               case 15:
//                 return '15';
//             }
//             return '';
//           },
//           reservedSize:  35,
//           margin: 5
//       )
//   );
// }