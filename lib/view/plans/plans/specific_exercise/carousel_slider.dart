// import 'package:be_fit/models/data_types/exercises.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:dots_indicator/dots_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../models/widgets/modules/myText.dart';
// import '../../../../view_model/plans/cubit.dart';
// import '../../../../view_model/plans/states.dart';
//
// class MyPlanCarousel extends StatelessWidget {
//   final Exercises exercise;
//   const MyPlanCarousel({super.key,
//     required this.exercise,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(5.0),
//           child: Container(
//             clipBehavior: Clip.antiAliasWithSaveLayer,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16)
//             ),
//             width: double.infinity,
//             child: CarouselSlider(
//                 items: exercise.image.map((e) => Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Container(
//                     clipBehavior: Clip.antiAliasWithSaveLayer,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16)
//                     ),
//                     child: Image.network(
//                       e,
//                       fit: BoxFit.contain,
//                       errorBuilder: (context, error, stackTrace) => MyText(
//                         text: 'Failed to load image',
//                         fontWeight: FontWeight.bold,
//                       ),),
//                   ),
//                 )).toList(),
//                 options: CarouselOptions(
//                   onPageChanged: (newDot, reason)
//                   {
//                     PlansCubit.getInstance(context).changeDot(newDot);
//                   },
//                   enableInfiniteScroll: false,
//                   autoPlay: false,
//                 )
//             ),
//           ),
//         ),
//         BlocBuilder<PlansCubit,PlansStates>(
//           builder: (context, state) => DotsIndicator(
//             dotsCount: exercise.image.length,
//             position: PlansCubit.getInstance(context).dot,
//             decorator: const DotsDecorator(
//               color: Colors.black87, // Inactive color
//               activeColor: Colors.redAccent,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
