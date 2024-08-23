import 'dart:developer';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:animation_list/animation_list.dart';
import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../model/local/cache_helper/shared_prefs.dart';
import '../../models/widgets/modules/myText.dart';
import '../../models/widgets/modules/snackBar.dart';
import '../../models/widgets/records_model.dart';

class MyStream extends StatelessWidget {

  final Exercises exercise;
   MyStream({super.key,
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
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: RecordsModel(),
                      ),
                      Expanded(
                        child:  AnimationList(
                            duration: 1000,
                            reBounceDepth: 10.0,
                            children: List.generate(
                              snapshot.data!.docs.length, (index) => Padding(
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
                            )
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
          AnimatedSnackBar.material(
              'Try Again Later',
              type: AnimatedSnackBarType.error,
              mobileSnackBarPosition: MobileSnackBarPosition.bottom
          ).show(context);
          return MyText(text: '');
        }
        else {return MyText(text: '');}
      },

    );
  }
}
