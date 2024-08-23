import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/model/remote/repositories/exercises/implementation.dart';
import 'package:be_fit/model/remote/repositories/interface.dart';
import 'package:be_fit/models/data_types/controllers.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/data_types/setRecord_model.dart';
import 'package:be_fit/models/widgets/carousel_slider.dart';
import 'package:be_fit/view/statistics/statistics.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/widgets/modules/myText.dart';
import '../../../view_model/exercises/states.dart';
import '../../constants/constants.dart';
import 'app_button.dart';
import 'docs_video.dart';
import 'modules/otp_tff.dart';

class SpecificExercise extends StatefulWidget {

  final Exercises exercise;
  final Widget stream;

  const SpecificExercise({super.key,
    required this.exercise,
    required this.stream,
  });

  @override
  State<SpecificExercise> createState() => _SpecificExerciseState();
}

class _SpecificExerciseState extends State<SpecificExercise> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();

  late TextEditingController weightCont;

  late TextEditingController repsCont;

  late PageController controller;

  late Controllers controllers;

  late ExercisesMain exercisesType;

  @override
  void initState() {
    weightCont = TextEditingController();
    repsCont = TextEditingController();
    controller = PageController();
    ExercisesCubit.getInstance(context).dot = 0;
    super.initState();
  }
  @override
  void dispose() {
    weightCont.dispose();
    repsCont.dispose();
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: MyText(text: widget.exercise.name,fontWeight: FontWeight.w500,),
        actions: [
          TextButton(
              onPressed: ()
              {
                context.normalNewRoute(
                    Statistics(
                      exercise: widget.exercise,
                    )
                );
              },
              child: MyText(
                text: 'Statistics',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Constants.appColor,
              )
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 8),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Container(
                  width: double.infinity,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16)
                  ),
                  child: BlocBuilder<ExercisesCubit,ExercisesStates>(
                    builder: (context, state) => MyCarousel(images: widget.exercise.image),
                    buildWhen: (previous, current) => current is ChangeDot,
                  )
              ),
            ),
            widget.stream,
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: DocsAndVideo(
                    exercise: widget.exercise,
                    scaffoldKey: scaffoldKey,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: context.decoration()
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: [
                          MyText(
                            text: Constants.dataTime,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          const SizedBox(height: 20),
                          Form(
                            key: formKey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OtpTff(controller: weightCont, hintText: 'weight'),
                                OtpTff(controller: repsCont, hintText: 'reps'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: BlocBuilder<ExercisesCubit, ExercisesStates>(
                    builder: (context, state) => AppButton(
                      onPressed: state is SetNewRecordLoadingState? null : ()async
                      {
                        if(formKey.currentState!.validate())
                        {
                          controllers = Controllers(
                              weight: double.tryParse(weightCont.text),
                              reps: double.tryParse(repsCont.text)
                          );

                          if(widget.exercise.isCustom)
                          {
                            exercisesType = CustomExercisesImpl();
                          }
                          else{
                            exercisesType = DefaultExercisesImpl.getInstance();
                          }
                          await ExercisesCubit.getInstance(context).setRecord(
                              exerciseType: exercisesType,
                              model: SetRecModel(
                                  muscleName: widget.exercise.muscleName!,
                                  exerciseId: widget.exercise.id,
                                  controllers: controllers
                              )
                          );
                          _clearCont(weightCont, repsCont);
                        }
                      },
                      text: 'Add',
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _clearCont(TextEditingController weightCont, TextEditingController repsCont)
  {
    weightCont.clear();
    repsCont.clear();
  }
}