import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/base_widgets/myText.dart';

class CreateExercise extends StatelessWidget {
  final String muscleName;
  CreateExercise({
    super.key,
    required this.muscleName,
  });

  final nameCont = TextEditingController();
  final descriptionCont = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: MyText(
          text: 'Add Exercise',
          fontSize: 25.sp,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      // body:
      // Padding(
      //   padding: EdgeInsets.all(8.0.r),
      //   child: Form(
      //     key: formKey,
      //     child: SingleChildScrollView(
      //       child: Column(
      //         children: [
      //           if (state is CreateCustomExerciseLoadingState)
      //             Padding(
      //               padding: const EdgeInsets.symmetric(vertical: 16.0),
      //               child: LinearProgressIndicator(
      //                 color: Constants.appColor,
      //               ),
      //             ),
      //           if (ExercisesCubit.getInstance(context).selectedExerciseImage == null)
      //             IconButton(
      //               onPressed: () {
      //                 scaffoldKey.currentState?.showBottomSheet(
      //                     (context) => const ChooseImageSource());
      //               },
      //               icon: Padding(
      //                 padding: EdgeInsets.all(12.0.r),
      //                 child: Container(
      //                   decoration: BoxDecoration(
      //                     border: context.decoration(),
      //                     shape: BoxShape.circle,
      //                   ),
      //                   child: Padding(
      //                     padding: EdgeInsets.all(35.0.r),
      //                     child: Icon(
      //                       Icons.fitness_center,
      //                       color: Constants.appColor,
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           if (ExercisesCubit.getInstance(context).selectedExerciseImage != null)
      //             Stack(
      //               alignment: Alignment.topRight,
      //               children: [
      //                 Padding(
      //                   padding: EdgeInsets.all(12.0.r),
      //                   child: SizedBox(
      //                       width: context.setWidth(1.2),
      //                       height: context.setHeight(2.2),
      //                       child: Image.file(ExercisesCubit.getInstance(context).selectedExerciseImage!)),
      //                 ),
      //                 InkWell(
      //                   onTap: state is CreateCustomExerciseLoadingState ? null : () {
      //                       ExercisesCubit.getInstance(context).removeSelectedImage();
      //                     },
      //                   child: CircleAvatar(
      //                     radius: 14,
      //                     backgroundColor: Constants.appColor,
      //                     child: const Icon(
      //                       Icons.close,
      //                       size: 16,
      //                     ),
      //                   ),
      //                 )
      //               ],
      //             ),
      //           TFF(
      //             obscureText: false,
      //             controller: nameCont,
      //             hintText: 'Name',
      //             enabledBorder: OutlineInputBorder(
      //                 borderRadius: BorderRadius.circular(16),
      //                 borderSide: BorderSide(
      //                   color: Constants.appColor,
      //                 )),
      //           ),
      //           SizedBox(
      //             height: 16.h,
      //           ),
      //           TFF(
      //             obscureText: false,
      //             controller: descriptionCont,
      //             hintText: 'Description',
      //             enabledBorder: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(16),
      //               borderSide: BorderSide(
      //                 color: Constants.appColor,
      //               ),
      //             ),
      //           ),
      //           SizedBox(
      //             height: 16.h,
      //           ),
      //           Align(
      //             alignment: Alignment.bottomLeft,
      //             child: Padding(
      //               padding: EdgeInsets.all(8.0.r),
      //               child: MyText(
      //                 text: 'Category : $muscleName',
      //                 fontSize: 25.sp,
      //                 fontWeight: FontWeight.w500,
      //               ),
      //             ),
      //           ),
      //           AppButton(
      //             onPressed: state is CreateCustomExerciseLoadingState ? null
      //                 : () async {
      //                     if (formKey.currentState!.validate()) {
      //                       if (ExercisesCubit.getInstance(context).selectedExerciseImage == null) {
      //                         AnimatedSnackBar.material(
      //                                 'Please select exercise photo',
      //                                 type: AnimatedSnackBarType.warning,
      //                                 mobileSnackBarPosition: MobileSnackBarPosition.bottom).show(context);
      //                       } else {
      //                         await ExercisesCubit.getInstance(context).uploadPickedImageAndAddCustomExercise(
      //                           context: context,
      //                           addCustomExerciseModel:
      //                               AddCustomExerciseModel(
      //                             muscle: muscleName,
      //                             name: nameCont.text,
      //                             description: descriptionCont.text,
      //                           ),
      //                         );
      //                       }
      //                     }
      //                   },
      //             text: 'Add',
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
