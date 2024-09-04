// import 'dart:async';
// import 'package:be_fit/extensions/container_decoration.dart';
// import 'package:be_fit/models/data_types/controllers.dart';
// import 'package:be_fit/models/data_types/exercises.dart';
// import 'package:be_fit/models/widgets/docs_video.dart';
// import 'package:flutter/material.dart';
// import '../../constants/constants.dart';
// import '../../model/local/cache_helper/shared_prefs.dart';
// import '../../model/remote/repositories/exercises/implementation.dart';
// import '../../model/remote/repositories/interface.dart';
// import '../../view_model/exercises/cubit.dart';
// import '../data_types/setRecord_model.dart';
// import 'app_button.dart';
// import 'modules/myText.dart';
// import 'modules/otp_tff.dart';
//
// class ExerciseDetailsComponent extends StatefulWidget {
//
//   final Exercises exercise;
//   Future<void> Function()? onPressed;
//   final scaffoldKey;
//   Controllers controllers;
//
//   ExerciseDetailsComponent({super.key,
//     required this.exercise,
//     this.onPressed,
//     required this.scaffoldKey,
//     required this.controllers,
//   });
//
//   @override
//   State<ExerciseDetailsComponent> createState() => _ExerciseDetailsComponentState();
// }
//
// class _ExerciseDetailsComponentState extends State<ExerciseDetailsComponent> {
//
//   // late MainFunctions exercisesType;
//   // final TextEditingController weightCont = TextEditingController();
//   // final TextEditingController repsCont = TextEditingController();
//   var formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 5.0),
//           child: DocsAndVideo(exercise: widget.exercise, scaffoldKey: widget.scaffoldKey,),
//         ),
//         Container(
//           decoration: BoxDecoration(
//               border: context.decoration()
//           ),
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20.0),
//               child: Column(
//                 children: [
//                   MyText(
//                     text: Constants.dataTime,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20.sp,
//                   ),
//                   const SizedBox(height: 20.h),
//                   Form(
//                     key: formKey,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         OtpTff(controller: widget.controllers.weight, hintText: 'weight'),
//                         OtpTff(controller: repsCont, hintText: 'reps'),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16.0),
//           child: AppButton(
//             onPressed: widget.onPressed,
//             text: 'Add',
//           ),
//         ),
//       ],
//     );
//   }
// }