import 'dart:developer';
import 'package:be_fit/constants.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/widgets/app_button.dart';
import 'package:be_fit/view/statistics/statistics.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:be_fit/view_model/internet_connection_check/internet_connection_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import '../../../models/data_types/setRecord_model.dart';
import '../../../models/widgets/modules/myText.dart';
import '../../../models/widgets/modules/otp_tff.dart';
import '../../../models/widgets/modules/snackBar.dart';
import '../../../view_model/exercises/states.dart';
import '../../../models/widgets/records_model.dart';
import 'exercise_video.dart';

class SpecificExercise extends StatefulWidget {

Exercises exercise;
  int? index;

  SpecificExercise({super.key,
    required this.exercise,
    this.index,
  });

  @override
  State<SpecificExercise> createState() => _SpecificExerciseState();
}

class _SpecificExerciseState extends State<SpecificExercise> {
  final weightCont = TextEditingController();

  final repsCont = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if(widget.exercise.isCustom == false)
      {
        ExercisesCubit.getInstance(context).pickRecordsToMakeChart(
          muscleName: widget.exercise.muscleName!,
          exerciseDoc: widget.exercise.id,
          uId: CacheHelper.getInstance().uId,
        );
      }
    else
    {
      ExercisesCubit.getInstance(context).pickRecordsForCustomExerciseToMakeChart(
          uId: CacheHelper.getInstance().uId,
          exerciseDoc: widget.exercise.id,
      );
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisesCubit,ExercisesStates>(
      builder: (context, state)
      {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: MyText(text: widget.exercise.name,fontWeight: FontWeight.w500,),
            actions: [
              TextButton(
                  onPressed: ()
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Statistics(
                              records: widget.exercise.isCustom == false ?
                              ExercisesCubit.getInstance(context).records:
                              ExercisesCubit.getInstance(context).recordsForCustomExercise,
                          )
                        ),
                    );
                  },
                  child: MyText(text: 'Statistics',fontSize: 18,fontWeight: FontWeight.w500,))
            ],
          ),
          body: state is GetRecordsLoadingState?
          const Center(
            child: CircularProgressIndicator(),
          ):
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 8),
            child: ListView(
              children: [
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  width: double.infinity,
                  child: Image.network(
                    widget.exercise.image,
                    fit: BoxFit.contain,
                  ),
                ),
                StreamBuilder(
                  stream: widget.exercise.isCustom == false?
                  FirebaseFirestore.instance.collection(widget.exercise.muscleName!).doc(widget.exercise.id).collection('records').where('uId',isEqualTo: CacheHelper.getInstance().uId).orderBy('dateTime').snapshots() :
                  FirebaseFirestore.instance.collection('users').doc(CacheHelper.getInstance().uId).collection('customExercises').doc(widget.exercise.id).collection('records').orderBy('dateTime').snapshots(),
                  builder: (context, snapshot)
                  {
                    if(snapshot.hasData)
                      {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: SizedBox(
                            height: context.setHeight(2.8),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(color: Constants.appColor),
                                    bottom: BorderSide(color: Constants.appColor),
                                    top: BorderSide(color: Constants.appColor),
                                    left: BorderSide(color: Constants.appColor),
                                  )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const RecordsModel(),
                                    Expanded(
                                      child: ListView.builder(
                                        itemBuilder: (context, index) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              const Spacer(),
                                              SizedBox(
                                                width: 100,
                                                child: Column(
                                                  children: [
                                                    MyText(
                                                      text: snapshot.data?.docs[index].data()['dateTime'],
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              Column(
                                                children: [
                                                  MyText(
                                                    text: '${snapshot.data?.docs[index].data()['weight']}',
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              Column(
                                                children: [
                                                  MyText(
                                                    text: '${snapshot.data?.docs[index].data()['reps']}',
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                            ],
                                          ),
                                        ),
                                        itemCount: snapshot.data?.docs.length,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    else if(snapshot.hasError)
                    {
                      log('error : ${snapshot.error.toString()}');
                      MySnackBar.showSnackBar(
                      context: context,
                      message: 'Try again latter',
                      color: Constants.appColor,
                    );
                      return MyText(text: '');
                    }
                    else {return MyText(text: '');}
                  },

                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: ()
                      {
                        scaffoldKey.currentState!.showBottomSheet((context) => SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height/1.2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyText(
                              text: widget.exercise.docs,
                              maxLines: 20,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ));
                      },
                      icon: const Icon(Icons.question_mark),
                    ),
                    const Spacer(),
                    if(widget.exercise.isCustom == false)
                      IconButton(
                      onPressed: ()
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseVideo(
                                exerciseName: widget.exercise.name,
                                url: widget.exercise.video.isEmpty?
                                'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4' :
                                widget.exercise.video,
                              ),
                            ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                    )
                  ],
                ),

                Container(
                  height: context.setHeight(5),
                  decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: Constants.appColor),
                        bottom: BorderSide(color: Constants.appColor),
                        top: BorderSide(color: Constants.appColor),
                        left: BorderSide(color: Constants.appColor),
                      )
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: MyText(
                            text: Jiffy().yMMMMEEEEd,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
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
                AppButton(
                    onPressed: () async
                    {
                      if(formKey.currentState!.validate())
                      {
                        if(widget.exercise.isCustom == false)
                        {
                          await ExercisesCubit.getInstance(context).setRecord(
                            recModel: SetRecModel(
                              muscleName: widget.exercise.muscleName!,
                              exerciseId: widget.exercise.id,
                              weight: weightCont.text,
                              reps: repsCont.text,
                              uId: CacheHelper.getInstance().uId,
                            ),
                            context: context,
                            internetCheck: FirstCheckMethod.getInstance(),
                          ).then((value)
                          {
                            repsCont.clear();
                            weightCont.clear();
                          });
                        }
                        else{
                          ExercisesCubit.getInstance(context).setRecordForCustomExercise(
                            context,
                            setCustomExerciseRecModel: SetCustomExerciseRecModel(
                              index: widget.index!,
                              reps: repsCont.text,
                              weight: weightCont.text,
                              uId: CacheHelper.getInstance().uId,
                            ),
                          ).then((value)
                          {
                            repsCont.clear();
                            weightCont.clear();
                          });
                        }
                      }
                    },
                    text: 'Add',
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
