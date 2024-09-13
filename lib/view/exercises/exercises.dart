import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/models/widgets/default_custom_buttons.dart';
import 'package:be_fit/models/widgets/search_bar.dart';
import 'package:be_fit/view/exercises/types/custom_exercises.dart';
import 'package:be_fit/view/exercises/types/default_exercises.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:be_fit/view_model/exercises/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/remote/firebase_service/fire_store/exercises/implementation.dart';
import '../../model/remote/firebase_service/fire_store/interface.dart';

class ExercisesForMuscle extends StatefulWidget {
  final String muscleName;
  final int numberOfExercises;

  const ExercisesForMuscle({
    super.key,
    required this.muscleName,
    required this.numberOfExercises,
  });

  @override
  State<ExercisesForMuscle> createState() => _ExercisesForMuscleState();
}

class _ExercisesForMuscleState extends State<ExercisesForMuscle> {

  final searchCont = TextEditingController();
  List<ExercisesMain> exerciseTypes = [DefaultExercisesImpl(), CustomExercisesImpl()];
  @override
  void initState() {
    ExercisesCubit.getInstance(context).currentIndex = 1;
    for(ExercisesMain type in exerciseTypes)
      {
        ExercisesCubit.getInstance(context).getExercises(
            context,
            exercisesType: type,
            muscleName: widget.muscleName
        );
      }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisesCubit, ExercisesStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: MyText(
              text:
              '${widget.muscleName}   ${widget.numberOfExercises} Exercises',
              fontWeight: FontWeight.w500,
            ),
          ),
          body: state is GetExercisesLoadingState?
          Center(
            child: SpinKitCircle(
              color: Constants.appColor,
              size: 50.0,
            ),
          ):
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DefaultAndCustomButtons(
                        text: 'Default',
                        onTap: ()
                        {
                          ExercisesCubit.getInstance(context).changeBody(1);
                        },
                        color: ExercisesCubit.getInstance(context).currentIndex == 1?
                        Constants.appColor:
                        null,
                      ),
                      DefaultAndCustomButtons(
                        text: 'Custom (${ExercisesCubit.getInstance(context).customExercisesList.length})',
                        onTap: ()
                        {
                          ExercisesCubit.getInstance(context).changeBody(2);
                        },
                        color: ExercisesCubit.getInstance(context).currentIndex == 2?
                        Constants.appColor:
                        null,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      AppSearchBar(
                        controller: searchCont, onChanged: (newLetter) {
                        if(ExercisesCubit.getInstance(context).currentIndex == 1)
                        {
                          ExercisesCubit.getInstance(context).customExercisesSearch(
                              newLetter
                          );
                        }
                        else{
                          ExercisesCubit.getInstance(context).search(
                              newLetter
                          );
                        }
                      },),

                      if(ExercisesCubit.getInstance(context).currentIndex == 1)
                        DefaultExercises(muscleName: widget.muscleName),
                      if(ExercisesCubit.getInstance(context).currentIndex == 2)
                        CustomExercisesScreen(muscleName: widget.muscleName),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}