import 'dart:developer';
import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../model/local/cache_helper/shared_prefs.dart';
import '../../../../models/widgets/modules/myText.dart';
import '../../../../models/widgets/modules/snackBar.dart';
import '../../../../models/widgets/records_model.dart';

class MyPlanStream extends StatelessWidget {

  final Exercises exercise;
  final String planDoc;
  final int listIndex;

  const MyPlanStream({super.key,
    required this.exercise,
    required this.planDoc,
    required this.listIndex,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(CacheHelper.getInstance().getData('userData')[0])
            .collection('plans')
            .doc(planDoc)
            .collection('list$listIndex')
            .doc(exercise.id)
            .collection('records')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: snapshot.data!.docs.isEmpty?
              null : SizedBox(
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
            log('idk : $snapshot');
            return MyText(text: '');
          }
        });
  }
}
