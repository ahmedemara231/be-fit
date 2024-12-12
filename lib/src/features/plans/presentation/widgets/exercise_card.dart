import 'package:be_fit/src/core/extensions/container_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/app_widgets/app_dialog.dart';
import '../../../../core/helpers/base_widgets/image.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../../../../core/helpers/global_data_types/dialog_inputs.dart';

class ExerciseCard extends StatelessWidget {

  final String imgUrl;
  final String exerciseName;
  final DialogInputs inputs;
  const ExerciseCard({super.key,
    required this.imgUrl,
    required this.exerciseName,
    required this.inputs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: context.decoration()),
      child: Padding(
        padding:  EdgeInsets.all(12.0.r),
        child: ListTile(
          leading: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5)),
              child: MyNetworkImage(
                url: imgUrl
              )),
          title: MyText(
            text: exerciseName,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
          trailing: PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: MyText(text: 'Delete'),
                  onTap: () async {
                    await AppDialog.show(
                        context,
                        inputs: inputs
                    );
                  },
                )
              ];
            },
            icon: const Icon(Icons.menu),
          ),
        ),
      ),
    );
  }
}
