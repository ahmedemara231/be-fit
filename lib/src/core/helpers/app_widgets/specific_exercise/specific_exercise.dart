import 'package:be_fit/src/core/extensions/container_decoration.dart';
import 'package:be_fit/src/core/helpers/app_widgets/specific_exercise/specific_exercise_widgets/carousel_slider.dart';
import 'package:be_fit/src/core/helpers/app_widgets/specific_exercise/specific_exercise_widgets/docs_video.dart';
import 'package:be_fit/src/core/helpers/app_widgets/specific_exercise/specific_exercise_widgets/otp_tff.dart';
import 'package:be_fit/src/core/helpers/app_widgets/specific_exercise/specific_exercise_widgets/stream.dart';
import 'package:be_fit/src/features/exercises/presentation/blocs/exercises/cubit.dart';
import 'package:be_fit/src/features/exercises/presentation/blocs/exercises/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../../../features/exercises/data/data_source/models/controllers.dart';
import '../../../../features/exercises/data/data_source/models/set_record_model.dart';
import '../../../constants/constants.dart';
import '../../../data_source/remote/firebase_service/fire_store/interface.dart';
import '../../base_widgets/myText.dart';
import '../../global_data_types/exercises.dart';
import '../app_button.dart';
import '../specific_exercise_app_bar.dart';
import 'factory/set_rec_factory_method.dart';

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

  @override
  void initState() {
    weightCont = TextEditingController();
    repsCont = TextEditingController();
    controller = PageController();
    // ExercisesCubit.getInstance(context).dot = 0;
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
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                  child: BlocBuilder<ExercisesCubit, ExercisesState>(
                    builder: (context, state) =>
                        MyCarousel(images: widget.exercise.image),
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
                            child: FittedBox(
                              child: Padding(
                                padding: EdgeInsets.all(8.0.r),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    OtpTff(controller: weightCont, hintText: 'weight'),
                                    OtpTff(controller: repsCont, hintText: 'reps'),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: BlocBuilder<ExercisesCubit, ExercisesState>(
                    builder: (context, state) => AppButton(
                      onPressed: state.currentState == ExercisesInternalStates.addNewRecordLoading?
                      null : () async {
                              if (formKey.currentState!.validate()) {
                                controllers = Controllers(
                                    weight: double.tryParse(weightCont.text),
                                    reps: double.tryParse(repsCont.text)
                                );

                                SetRecModel model = SetRecModel(
                                    muscleName: widget.exercise.muscleName!,
                                    exerciseId: widget.exercise.id,
                                    controllers: controllers
                                );
                                final ExercisesInterface exercisesType = SetRec.factory(
                                    exercise: widget.exercise,
                                    model: model
                                );
                                await GetIt.instance.get<ExercisesCubit>().setRecord(
                                  instance: exercisesType,
                                );
                                _clearCont(weightCont: weightCont , repsCont: repsCont);
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

  void _clearCont({
    required TextEditingController weightCont,
    required TextEditingController repsCont
  }) {
    weightCont.clear();
    repsCont.clear();
  }
}