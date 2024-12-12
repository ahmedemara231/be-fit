import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/global_data_types/delete_record.dart';
import '../../../../core/helpers/global_data_types/exercises.dart';
import '../../data/data_source/models/cardio_records.dart';
import '../../data/data_source/models/set_cardio_rec_model.dart';
import '../../data/repo/cario_repo.dart';
part 'cardio_state.dart';

class NewCardioCubit extends Cubit<CardioStates> {
  NewCardioCubit(this.repo) : super(CardioInitial());

  CardioRepo repo;

  late List<Exercises> cardioExercises;
  late List<Exercises> cardioExercisesList;
  Future<void> getCardioExercises()async{
    emit(GetCardioExercisesLoading());
    final result = await repo.getCardioExercises();
    if(result.isSuccess()){
      cardioExercises = result.getOrThrow();
      cardioExercisesList = List.from(cardioExercises);

      emit(GetCardioExercisesSuccess(
        cardioExercises: result.getOrThrow(),
        cardioExercisesList: result.getOrThrow(),
      ));
    }else{
      emit(GetCardioExercisesError(
          error: result.tryGetError()!.message
      ));
    }
  }

  void search(String pattern){
    if(pattern.isEmpty)
    {
      cardioExercisesList = List.from(cardioExercises);
    }
    else{
      cardioExercisesList = cardioExercises
          .where((element) => element.name.contains(pattern))
          .toList();
    }
    emit(NewSearchState());
  }

  Future<void> setRec(SetCardioRecModel? model)async{
    emit(SetCardioRecLoading());
    final result = await repo.setRec(model);
    if(result.isSuccess()){
      emit(SetCardioRecSuccess());
    }else{
      emit(SetCardioRecError(
          error: result.tryGetError()!.message
      ));
    }
  }

  Future<void> deleteRec(DeleteRecForExercise deleteRecModel)async{
    emit(DeleteCardioRecLoading());
    final result = await repo.deleteRec(deleteRecModel);
    if(result.isSuccess()){
      emit(DeleteCardioRecSuccess());
    }else{
      emit(DeleteCardioRecError(
        error: result.tryGetError()!.message
      ));
    }
  }

  Future<void> getCardioRecords(String exerciseId)async{
    emit(GetCardioRecordsLoading());
    final result = await repo.getRecords(exerciseId);
    if(result.isSuccess()){
      emit(GetCardioRecordsSuccess(
        result.getOrThrow()
      ));
    }else{
      emit(GetCardioRecordsError(
          error: result.tryGetError()!.message
      ));
    }
  }
}
