import 'package:be_fit/src/core/extensions/container_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/app_widgets/app_dialog.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../../../../core/helpers/global_data_types/dialog_inputs.dart';

class PlanWidget extends StatelessWidget {
  const PlanWidget({Key? key,
    required this.planName,
    required this.inputs,
  }) : super(key: key);

  final String planName;

  final DialogInputs inputs;
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
          border: context.decoration()),
      child: ListTile(
        title: MyText(
          text: planName,
          fontSize: 20.sp,
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
    );
  }
}
