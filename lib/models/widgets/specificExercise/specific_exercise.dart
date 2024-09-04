import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/model/remote/repositories/exercises/implementation.dart';
import 'package:be_fit/model/remote/repositories/interface.dart';
import 'package:be_fit/models/data_types/controllers.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/data_types/setRecord_model.dart';
import 'package:be_fit/models/widgets/specific_exercise_app_bar.dart';
import 'package:be_fit/models/widgets/specific_exercise_widgets/carousel_slider.dart';
import 'package:be_fit/models/widgets/specific_exercise_widgets/stream.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../models/widgets/modules/myText.dart';
import '../../../../view_model/exercises/states.dart';
import '../../../constants/constants.dart';
import '../app_button.dart';
import '../specific_exercise_widgets/docs_video.dart';
import '../specific_exercise_widgets/otp_tff.dart';

class SpecificExercise extends StatefulWidget {
  final Exercises exercise;

  const SpecificExercise({
    super.key,
    required this.exercise,
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
      appBar: ExerciseAppBar(exercise: widget.exercise),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Container(
                  width: double.infinity,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(16)),
                  child: BlocBuilder<ExercisesCubit, ExercisesStates>(
                    builder: (context, state) =>
                        MyCarousel(images: widget.exercise.image),
                    buildWhen: (previous, current) => current is ChangeDot,
                  )),
            ),
            MyStream(exercise: widget.exercise),
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
                  decoration: BoxDecoration(border: context.decoration()),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: [
                          MyText(
                            text: Constants.dataTime,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                          SizedBox(height: 20.h),
                          Form(
                            key: formKey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OtpTff(
                                    controller: weightCont, hintText: 'weight'),
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
                      onPressed: state is SetNewRecordLoadingState
                          ? null
                          : () async {
                              if (formKey.currentState!.validate()) {
                                controllers = Controllers(
                                    weight: double.tryParse(weightCont.text),
                                    reps: double.tryParse(repsCont.text));

                                SetRecModel model = SetRecModel(
                                    muscleName: widget.exercise.muscleName!,
                                    exerciseId: widget.exercise.id,
                                    controllers: controllers
                                );

                                print(model.muscleName);
                                print(model.exerciseId);

                                if (widget.exercise.isCustom) {
                                  exercisesType = CustomExercisesImpl(model: model);
                                } else {
                                  exercisesType = DefaultExercisesImpl(model: model);
                                }

                                await ExercisesCubit.getInstance(context).setRecord(
                                        exerciseType: exercisesType,
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

  void _clearCont(
      TextEditingController weightCont, TextEditingController repsCont) {
    weightCont.clear();
    repsCont.clear();
  }
}
