// import 'package:be_fit/models/data_types/exercises.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../../../../../models/data_types/get_muscle_exercises.dart';
// import '../../../../../models/data_types/muscle_result.dart';
//
// abstract class GetMuscles
// {
//   Future<GetMuscleResult> getMuscle(GetMuscleExercise model);
// }
//
// class GetChest extends GetMuscles{
//
//   late Exercises chestExercises;
//   late bool chestCheckBox;
//
//   @override
//   Future<GetMuscleResult> getMuscle(GetMuscleExercise model) async {
//
//     chestCheckBox.add(false);
//     chestExercises.add(
//       Exercises.fromJson(model.element),
//     );
//
//     if(model.element.data()['name'] == 'Chest press machine')
//     {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(model.uId)
//           .collection('customExercises')
//           .where('muscle', isEqualTo: 'chest')
//           .get()
//           .then((value)
//       {
//         for (var element in value.docs) {
//           chestCheckBox.add(false);
//           chestExercises.add(
//             Exercises.fromJson(element),
//           );
//         }
//       });
//     }
//
//     return GetMuscleResult(
//         muscleExercises: chestExercises,
//         muscleCheckBox: chestCheckBox
//     );
//   }
// }