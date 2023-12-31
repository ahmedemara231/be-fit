import 'package:be_fit/models/data_types/setRecord_model.dart';
import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../models/data_types/exercises.dart';
import '../../../modules/otp_tff.dart';
import '../../../modules/snackBar.dart';
import '../../../widgets_models/records_model.dart';
import '../../log/Log.dart';

class PlanExerciseDetails extends StatelessWidget {

  String planDoc;
  int listIndex;
  Exercises exercise;

  PlanExerciseDetails({super.key,
    required this.planDoc,
    required this.listIndex,
    required this.exercise,
  });

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final weightCont = TextEditingController();
  final repsCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: MyText(text: exercise.name),
        actions: [
          TextButton(
              onPressed: ()
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Log(
                      exerciseId: exercise.id,
                      muscleName: exercise.muscleName!,
                      isCustom: exercise.isCustom,
                    ),
                  ),
                );
              },
              child: MyText(text: 'Statistics',fontSize: 18,fontWeight: FontWeight.w500,))
        ],
      ),
      body: ListView(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(CacheHelper.uId)
                  .collection('plans')
                  .doc(planDoc)
                  .collection('list$listIndex')
                  .doc(exercise.id)
                  .collection('records')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: MediaQuery.of(context).size.height / 4,
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
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        MyText(
                                          text:
                                              '${snapshot.data?.docs[index].data()['weight']}',
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        MyText(
                                          text:
                                              '${snapshot.data?.docs[index].data()['reps']}',
                                          fontSize: 25,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Image.network(
                exercise.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
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
                                text: exercise.docs,
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
                onPressed: () {},
                icon: const Icon(Icons.play_arrow),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(20)),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 55,
                          ),
                          MyText(
                            text: 'TODAY',
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Row(
                        children: [
                          const Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
                            child: OtpTff(
                              controller: weightCont,
                              hintText: 'weight',
                            ),
                          ),
                          const Spacer(
                            flex: 4,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
                            child: OtpTff(
                              controller: repsCont,
                              hintText: 'reps',
                            ),
                          ),
                          const Spacer(
                            flex: 4,
                          ),
                          InkWell(
                            onTap: () async
                            {
                              await PlansCubit.getInstance(context).setARecordFromPlan(
                                  planExerciseRecord: SetRecordForPlanExercise(
                                      planDoc: planDoc,
                                      listIndex: listIndex + 1,
                                      exerciseDoc: exercise.id,
                                      reps: repsCont.text,
                                      weight: weightCont.text,
                                      uId: CacheHelper.uId,
                                  ),
                                  context: context,
                                  muscleName: exercise.muscleName!
                              ).then((value)
                              {
                                weightCont.clear();
                                repsCont.clear();
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Icon(
                                      Icons.add,
                                      size: 30,
                                    ))),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
