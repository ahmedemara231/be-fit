// import 'package:be_fit/model/remote/repositories/plans/implementation.dart';
// import 'package:be_fit/models/data_types/pick_records_plan.dart';
// import 'package:be_fit/models/data_types/setRecord_model.dart';
// import 'package:be_fit/models/widgets/exercise_details.dart';
// import 'package:be_fit/view/plans/plans/specific_exercise/carousel_slider.dart';
// import 'package:be_fit/view/plans/plans/specific_exercise/stream.dart';
// import '../../../../../models/widgets/modules/myText.dart';
// import 'package:be_fit/view/statistics/statistics.dart';
// import 'package:be_fit/view_model/plans/cubit.dart';
// import 'package:flutter/material.dart';
// import '../../../../model/local/cache_helper/shared_prefs.dart';
// import '../../../../model/remote/repositories/exercises/implementation.dart';
// import '../../../../model/remote/repositories/interface.dart';
// import '../../../../models/data_types/exercises.dart';
// import '../../../../view_model/exercises/cubit.dart';
//
// class PlanExerciseDetails extends StatefulWidget {
//
//   Exercises exercise;
//
//   PlanExerciseDetails({super.key,
//     required this.exercise,
//   });
//
//   @override
//   State<PlanExerciseDetails> createState() => _PlanExerciseDetailsState();
// }
//
// class _PlanExerciseDetailsState extends State<PlanExerciseDetails> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//
//   final formKey = GlobalKey<FormState>();
//
//   final weightCont = TextEditingController();
//
//   final repsCont = TextEditingController();
//
//   late MainFunctions exercisesType;
//
//   late PlansCubit plansCubit;
//   @override
//   void initState() {
//     plansCubit = PlansCubit.getInstance(context);
//
//     plansCubit.dot = 0;
//
//     plansCubit.pickRecordsToMakeChart(
//       context,
//       plansRepo: PlansRepo(
//         getRecordsInputs: RecordsForPlan(
//           uId: CacheHelper.getInstance().getData('userData')[0],
//           planDoc: plansCubit.roadToPlanExercise['planDoc'],
//           listIndex: plansCubit.roadToPlanExercise['listIndex'],
//           exerciseId: widget.exercise.id,
//         ),
//       ),
//     );
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     weightCont.dispose();
//     repsCont.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(
//         title: MyText(text: widget.exercise.name),
//         actions: [
//           TextButton(
//               onPressed: ()
//               {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => Statistics(
//                       exercise : widget.exercise,
//                     )
//                   ),
//                 );
//               },
//               child: MyText(text: 'Statistics',fontSize: 18,fontWeight: FontWeight.w500,))
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 8),
//         child: ListView(
//           children: [
//             MyPlanCarousel(exercise: widget.exercise),
//             MyPlanStream(
//                 exercise: widget.exercise,
//                 planDoc: plansCubit.roadToPlanExercise['planDoc'],
//                 listIndex: plansCubit.roadToPlanExercise['listIndex'],
//             ),
//             ExerciseDetailsComponent(
//               scaffoldKey: scaffoldKey,
//               exercise: widget.exercise,
//               onPressed: () async{
//                 if(widget.exercise.isCustom)
//                 {
//                   exercisesType = CustomExercisesImpl();
//                 }
//                 else{
//                   exercisesType = DefaultExercisesImpl();
//                 }
//
//                 await ExercisesCubit.getInstance(context).setRecord(
//                   exerciseType: exercisesType,
//                   model: SetRecModel(
//                       muscleName: widget.exercise.muscleName!,
//                       exerciseId: widget.exercise.id,
//                       uId: CacheHelper.getInstance().shared.getStringList('userData')![0]
//                   ),
//                 );
//               }
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }