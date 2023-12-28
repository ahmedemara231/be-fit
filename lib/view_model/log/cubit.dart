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
    required String uId,
})async
  {
    recordsRepsForSpecExercise = [];
    emit(GetRecordsRepsForSpecificExerciseLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
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
}