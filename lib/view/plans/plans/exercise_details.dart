import 'package:be_fit/constants.dart';
import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/models/data_types/setRecord_model.dart';
import 'package:jiffy/jiffy.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view/statistics/statistics.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/internet_connection_check/internet_connection_check.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../models/data_types/exercises.dart';
import '../../../models/widgets/app_button.dart';
import '../../../models/widgets/modules/otp_tff.dart';
import '../../../models/widgets/modules/snackBar.dart';
import '../../../models/widgets/records_model.dart';
import '../../exercises/specificExercise/exercise_video.dart';

class PlanExerciseDetails extends StatefulWidget {

  String planDoc;
  int listIndex;
  Exercises exercise;

  PlanExerciseDetails({super.key,
    required this.planDoc,
    required this.listIndex,
    required this.exercise,
  });

  @override
  State<PlanExerciseDetails> createState() => _PlanExerciseDetailsState();
}

class _PlanExerciseDetailsState extends State<PlanExerciseDetails> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();

  final weightCont = TextEditingController();

  final repsCont = TextEditingController();

  @override
  void initState() {
    PlansCubit.getInstance(context).pickRecordsToMakeChart(
        uId: CacheHelper.getInstance().uId,
        planDoc: widget.planDoc,
        listIndex: widget.listIndex,
        exerciseId: widget.exercise.id,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: MyText(text: widget.exercise.name),
        actions: [
          TextButton(
              onPressed: ()
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Statistics(
                      records: PlansCubit.getInstance(context).records,
                    )
                  ),
                );
              },
              child: MyText(text: 'Statistics',fontSize: 18,fontWeight: FontWeight.w500,))
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Image.network(
                widget.exercise.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(CacheHelper.getInstance().uId)
                  .collection('plans')
                  .doc(widget.planDoc)
                  .collection('list${widget.listIndex}')
                  .doc(widget.exercise.id)
                  .collection('records')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: SizedBox(
                      height: context.setHeight(2.8),
                      child: Container(
                        decoration: BoxDecoration(
                            border: context.decoration()
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
                } else if (snapshot.hasError) {
                  MySnackBar.showSnackBar(
                      context: context, message: 'Try again latter');
                  return MyText(text: '');
                } else {
                  print('idk : $snapshot');
                  return MyText(text: '');
                }
              }),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) => SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 1.2,
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
                border: context.decoration()
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
              await PlansCubit.getInstance(context).setARecordFromPlan(
                  internetCheck: FirstCheckMethod.getInstance(),
                  planExerciseRecord: SetRecordForPlanExercise(
                    planDoc: widget.planDoc,
                    listIndex: widget.listIndex + 1,
                    exerciseDoc: widget.exercise.id,
                    reps: repsCont.text,
                    weight: weightCont.text,
                    uId: CacheHelper.getInstance().uId,
                  ),
                  context: context,
                  muscleName: widget.exercise.muscleName!
              ).then((value)
              {
                weightCont.clear();
                repsCont.clear();
              });
            },
            text: 'Add',
          )
        ],
      ),
    );
  }
}
/*
* */
