import 'package:be_fit/models/records_model.dart';
import 'package:be_fit/view_model/log/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogCubit extends Cubit<LogStates>
{
  LogCubit(super.initialState);
  static LogCubit getInstance(context) => BlocProvider.of(context);

  List<Records> recordsRepsForSpecExercise = [];
  Future<void> sendRecordsToMakeChartForSpeExer({
    required String exerciseId,
})async
  {
    recordsRepsForSpecExercise = [];
    emit(GetRecordsRepsForSpecificExerciseLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc('gBWhBoVwrGNldxxAKbKk')
        .collection('customExercises')
        .doc(exerciseId)
        .collection('records')
        .get()
        .then((value)
    {
      value.docs.forEach((element) {
        recordsRepsForSpecExercise.add(
            Records(
                reps: element.data()['reps'],
                weight: element.data()['weight'],
            ),
        );
      });
      emit(GetRecordsRepsForSpecificExerciseSuccessState());
      print('spe reps : $recordsRepsForSpecExercise');

    }).catchError((error)
    {
      emit(GetRecordsRepsForSpecificExerciseErrorState());
    });
  }

  List<Records> recordsRepsForExercise = [];
  Future<void> sendRecordsToMakeChart({
    required String muscleName,
    required String exerciseId,
})async
  {
    recordsRepsForExercise = [];
    emit(GetRepsForExerciseLoadingState());
    await FirebaseFirestore.instance
        .collection(muscleName)
        .doc(exerciseId)
        .collection('records')
        .get()
        .then((value)
    {
      value.docs.forEach((element) {
        recordsRepsForExercise.add(
            Records(
                reps: element.data()['reps'],
                weight: element.data()['weight'],
            ),
        );
      });
      print(recordsRepsForExercise);
      emit(GetRepsForExerciseSuccessState());
    }).catchError((error)
    {
      emit(GetRepsForExerciseErrorState());
    });
  }
  // List<Map<String,dynamic>> allRecords = [];
  // Future<void> getAllRecords()async
  // {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc('gBWhBoVwrGNldxxAKbKk')
  //       .collection('customExercises')
  //       .get()
  //       .then((value)
  //   {
  //     value.docs.forEach((element) {
  //       element
  //           .reference
  //           .collection('records')
  //           .get()
  //           .then((value)
  //       {
  //         value.docs.forEach((element) {
  //           allRecords.add(element.data());
  //         });
  //       });
  //     });
  //   });
  //
  // }
  // // get all reps in records for specific exercise
  // List<double> repsForExercise = [];
  // Future<void> getReps()async
  // {
  //   repsForExercise = [];
  //   emit(GetRepsForSpecificExerciseLoadingState());
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc('gBWhBoVwrGNldxxAKbKk')
  //       .collection('customExercises')
  //       .doc('ZgMKTtqJrkH1iQwy7Qv8')
  //       .collection('records')
  //       .get()
  //       .then((value)
  //   {
  //     value.docs.forEach((element) {
  //       repsForExercise.add(element.data()['reps']);
  //     });
  //     print(repsForExercise);
  //     emit(GetRepsForSpecificExerciseSuccessState());
  //   }).catchError((error)
  //   {
  //     print(error.toString());
  //     emit(GetRepsForSpecificExerciseErrorState());
  //   });
  //
  // }
}