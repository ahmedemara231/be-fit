import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:animation_list/animation_list.dart';
import 'package:be_fit/src/core/extensions/container_decoration.dart';
import 'package:be_fit/src/core/extensions/mediaQuery.dart';
import 'package:be_fit/src/core/helpers/app_widgets/animated_snack_bar.dart';
import 'package:be_fit/src/features/exercises/presentation/blocs/exercises/cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/constants.dart';
import '../../../../data_source/local/cache_helper/shared_prefs.dart';
import '../../../../data_source/remote/firebase_service/fire_store/interface.dart';
import '../../../base_widgets/myText.dart';
import '../../../global_data_types/dialog_inputs.dart';
import '../../../global_data_types/exercises.dart';
import '../../app_dialog.dart';
import '../../records_model.dart';
import '../factory/delete_rec_factory_method.dart';

class MyStream extends StatelessWidget {
  final Exercises exercise;
  const MyStream({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: exercise.isCustom == false ?
      FirebaseFirestore.instance
          .collection(exercise.muscleName!)
          .doc(exercise.id)
          .collection('records')
          .where(
          'uId',
          isEqualTo: CacheHelper.getInstance().getData('userData')[0])
          .orderBy('dateTime')
          .snapshots() :
      FirebaseFirestore.instance
          .collection('users')
          .doc(CacheHelper.getInstance().getData('userData')[0])
          .collection('customExercises')
          .doc(exercise.id)
          .collection('records')
          .orderBy('dateTime')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: snapshot.data!.docs.isEmpty
                ? null
                : SizedBox(
                    height: context.setHeight(2.8),
                    child: Container(
                      decoration: BoxDecoration(border: context.decoration()),
                      child: Padding(
                        padding:  EdgeInsets.all(8.0.r),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: RecordsModel(),
                            ),
                            Expanded(
                              child: AnimationList(
                                  duration: 1000,
                                  reBounceDepth: 10.0,
                                  children: List.generate(
                                    snapshot.data!.docs.length,
                                    (index) => Padding(
                                      padding:  EdgeInsets.all(8.0.r),
                                      child: Row(
                                        children: [
                                          const Spacer(),
                                          SizedBox(
                                            width: 70.w,
                                            child: MyText(
                                              text: snapshot.data?.docs[index].data()['dateTime'],
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),

                                          MyText(
                                            text: snapshot.data!.docs[index].data()['weight'].toString(),
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          const Spacer(),

                                          MyText(
                                            text: snapshot.data!.docs[index].data()['reps'].toString(),
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          const Spacer(),
                                          InkWell(
                                              onTap: () {
                                                AppDialog.show(
                                                    context,
                                                    inputs: DialogInputs(
                                                      title: 'Are you sure to delete the record ?',
                                                      confirmButtonText: 'Delete',
                                                      onTapConfirm: ()async {
                                                        final ExercisesInterface type = DeleteRec.factory(
                                                            exercise: exercise,
                                                            recId: snapshot.data!.docs[index].id
                                                        );
                                                        context.read<ExercisesCubit>().deleteRecord(type);
                                                      },
                                                    )
                                                );
                                              }, child: Icon(Icons.close, color: Constants.appColor,)
                                          ),
                                        ],
                                      )
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
        } else if (snapshot.hasError) {
          AppSnackBar.show(
            context,
            msg: 'Try Again Later...',
            type: AnimatedSnackBarType.error,
          );
          return const SizedBox.shrink();
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}