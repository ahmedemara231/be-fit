import 'dart:developer';

import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../model/local/cache_helper/shared_prefs.dart';
import '../../models/widgets/modules/myText.dart';
import '../../models/widgets/modules/snackBar.dart';
import '../../models/widgets/records_model.dart';

class MyStream extends StatelessWidget {

  final Exercises exercise;
  const MyStream({super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: exercise.isCustom == false?
      FirebaseFirestore.instance.collection(exercise.muscleName!).doc(exercise.id).collection('records').where('uId',isEqualTo: CacheHelper.getInstance().getData('userData')[0]).orderBy('dateTime').snapshots() :
      FirebaseFirestore.instance.collection('users').doc(CacheHelper.getInstance().getData('userData')[0]).collection('customExercises').doc(exercise.id).collection('records').orderBy('dateTime').snapshots(),
      builder: (context, snapshot)
      {
        if(snapshot.hasData)
        {
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

    );
  }
}
