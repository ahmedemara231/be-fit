import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/extensions/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../model/local/cache_helper/shared_prefs.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view/setting/Setting/report_problem/reports.dart';
import 'package:be_fit/view_model/setting/cubit.dart';
import 'package:flutter/material.dart';
import '../../../../models/widgets/modules/textFormField.dart';

class ReportProblem extends StatelessWidget {
  ReportProblem({super.key});

  final formKey = GlobalKey<FormState>();
  final problemCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              context.normalNewRoute(const Reports());
            },
            child: MyText(
              text: 'Reports',
              fontWeight: FontWeight.bold,
              color: Constants.appColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.all(12.0.r),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: MyText(
                text: 'What\'s your problem ?',
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Form(
                key: formKey,
                child: TFF(
                  obscureText: false,
                  controller: problemCont,
                  hintText: 'Write your problem',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Constants.appColor)),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await SettingCubit.getInstance(context).report(context,
                      problem: problemCont.text,
                      uId: CacheHelper.getInstance().getData('userData')[0]);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.appColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 12, horizontal: context.setWidth(3)),
                child: FittedBox(
                    child: MyText(
                  text: 'Submit',
                  color: Colors.white,
                  fontSize: 16.sp,
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
