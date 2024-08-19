import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/model/remote/repositories/exercises/implementation.dart';
import 'package:be_fit/models/widgets/default_custom_buttons.dart';
import 'package:be_fit/view/exercises/custom_exercises.dart';
import 'package:be_fit/view/exercises/default_exercises.dart';
import '../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:be_fit/view_model/exercises/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/remote/repositories/interface.dart';
import '../../models/widgets/modules/textFormField.dart';

class ExercisesForMuscle extends StatefulWidget {
  String muscleName;
  int numberOfExercises;

  ExercisesForMuscle({
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

    for(ExercisesMain exerciseType in exerciseTypes)
      {
        ExercisesCubit.getInstance(context).getExercises(
            context,
            exercisesType: exerciseType,
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
          const Center(
            child: CircularProgressIndicator(),
          ):
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16),
            child: Column(
              children: [
                Row(
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
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10),
                        child: TFF(
                          obscureText: false,
                          controller: searchCont,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Constants.appColor),
                              borderRadius: BorderRadius.circular(25)
                          ),
                          hintText: 'Search for Exercise',
                          prefixIcon: const Icon(Icons.search),
                          onChanged: (newLetter)
                          {
                            if(ExercisesCubit.getInstance(context).currentIndex == 1)
                            {
                              ExercisesCubit.getInstance(context).exerciseSearch(newLetter);
                            }
                            else{
                              ExercisesCubit.getInstance(context).customExerciseSearch(newLetter);
                            }
                          },
                        ),
                      ),
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