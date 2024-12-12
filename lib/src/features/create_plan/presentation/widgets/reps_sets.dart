import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../../../../core/helpers/base_widgets/textFormField.dart';

class RepsAnaSets extends StatelessWidget {
  TextEditingController repsCont;
  TextEditingController setsCont;
  void Function()? cancelButtonAction;
  void Function()? conformButtonAction;

  RepsAnaSets({
    super.key,
    required this.repsCont,
    required this.setsCont,
    required this.cancelButtonAction,
    required this.conformButtonAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.all(12.0.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 70.w,
                height: 70.h,
                child: TFF(
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  controller: repsCont,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                  hintText: 'Reps',
                  labelText: 'Reps',
                ),
              ),
              Padding(
                padding:  EdgeInsets.all(16.0.r),
                child: MyText(
                  text: 'X',
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(
                width: 70.w,
                height: 70.h,
                child: TFF(
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  controller: setsCont,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                  hintText: 'Sets',
                  labelText: 'Sets',
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: cancelButtonAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.appColor,
              ),
              child: MyText(
                text: 'Cancel',
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            ElevatedButton(
              onPressed: conformButtonAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.appColor,
              ),
              child: MyText(text: 'Confirm', color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
