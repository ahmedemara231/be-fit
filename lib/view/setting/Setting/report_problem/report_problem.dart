import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view/setting/Setting/report_problem/reports.dart';
import 'package:be_fit/view_model/setting/cubit.dart';
import 'package:flutter/material.dart';
import '../../../../models/widgets/modules/textFormField.dart';

class ReportProblem extends StatelessWidget {
  ReportProblem({super.key});

  var formKey = GlobalKey<FormState>();
  final problemCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: ()
              {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Reports(),
                    ),
                );
              },
              child: MyText(text: 'Reports',fontWeight: FontWeight.bold,),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: MyText(
                text: 'What\'s your problem ?',
                fontSize: 18,
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
                    borderSide: BorderSide(color: Constants.appColor)
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: ()async
              {
                if(formKey.currentState!.validate())
                  {
                    await SettingCubit.getInstance(context).report(
                      context,
                      problem: problemCont.text,
                      uId:Constants.userId

                    );
                  }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.appColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: context.setWidth(3)
                ),
                child: FittedBox(
                    child: MyText(
                      text: 'Submit',
                      color: Colors.white,
                      fontSize: 16,
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
