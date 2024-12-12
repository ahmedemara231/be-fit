import 'package:be_fit/src/core/helpers/app_widgets/invalid_connection_screen.dart';
import 'package:be_fit/src/core/helpers/app_widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../blocs/exercises/cubit.dart';
import '../blocs/exercises/states.dart';
import '../widgets/default_custom_buttons.dart';
import '../widgets/search_bar.dart';
import 'custom_exercises.dart';
import 'default_exercises.dart';

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

  late final TextEditingController searchCont ;

  @override
  void initState() {
    context.read<ExercisesCubit>().getExercises(widget.muscleName);
    searchCont = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    searchCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          text: '${widget.muscleName}   ${widget.numberOfExercises} Exercises',
          fontWeight: FontWeight.w500,
        ),
      ),
      body: BlocBuilder<ExercisesCubit, ExercisesState>(
        builder: (context, state) {
          switch(state.currentState){
            case ExercisesInternalStates.getExercisesLoading:
              return const LoadingIndicator();

            case ExercisesInternalStates.getExercisesError:
              return ErrorBuilder(
                msg: state.errorMsg!,
                onPressed: () => context.read<ExercisesCubit>().getExercises(widget.muscleName),
              );

            default:
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16),
                child: RefreshIndicator(
                  onRefresh: () => context.read<ExercisesCubit>().getExercises(widget.muscleName),
                  color: Colors.white,
                  backgroundColor: Constants.appColor,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DefaultAndCustomButtons(
                              text: 'Default',
                              onTap: () {
                                context.read<ExercisesCubit>().changeBody(1);
                              },
                              color: state.currentIndex == 1?
                              Constants.appColor:
                              null,
                            ),
                            DefaultAndCustomButtons(
                              text: 'Custom (${state.customExercisesList!.length})',
                              onTap: () {
                                context.read<ExercisesCubit>().changeBody(2);
                              },
                              color: state.currentIndex == 2?
                              Constants.appColor : null,
                            ),
                          ],
                        ),
                      ),
                      Expanded( // page view
                        child: Column(
                          children: [
                            AppSearchBar(
                              controller: searchCont, onChanged: (newLetter) {
                              if(state.currentIndex == 1) {
                                context.read<ExercisesCubit>().customExercisesSearch(
                                    newLetter
                                );
                              }
                              else{
                                context.read<ExercisesCubit>().search(
                                    newLetter
                                );
                              }
                            },),
                            Expanded(
                              child: PageView(
                                children: [
                                  DefaultExercises(muscleName: widget.muscleName, exerciseList: state.defaultExercisesList!),
                                  CustomExercisesScreen(muscleName: widget.muscleName, customExercises: state.customExercisesList!)
                                ],
                              ),
                            ),
                          ],

                        ),
                        // child: ListView(
                        //   children: [
                        //     AppSearchBar(
                        //       controller: searchCont, onChanged: (newLetter) {
                        //       if(state.currentIndex == 1) {
                        //         context.read<ExercisesCubit>().customExercisesSearch(
                        //             newLetter
                        //         );
                        //       }
                        //       else{
                        //         context.read<ExercisesCubit>().search(
                        //             newLetter
                        //         );
                        //       }
                        //     },),
                        //
                        //     if(state.currentIndex == 1)
                        //       DefaultExercises(muscleName: widget.muscleName),
                        //     if(state.currentIndex == 2)
                        //       CustomExercisesScreen(muscleName: widget.muscleName),
                        //   ],
                        // ),
                      ),
                    ],
                  ),
                ),
              );
          }
        },
      )
    );
  }
}