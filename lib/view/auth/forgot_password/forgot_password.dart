import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/models/widgets/app_button.dart';
import 'package:be_fit/models/widgets/auth_TFF.dart';
import 'package:be_fit/view_model/login/cubit.dart';
import 'package:be_fit/view_model/login/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/widgets/modules/myText.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController emailCont;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.all(8.0.r),
        child: Column(
          children: [
            MyText(
              text: 'Forgot password?',
              fontSize: 25.sp,
              fontWeight: FontWeight.w500,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0, top: 10),
              child: MyText(
                text: 'Enter your email to send you the code',
                fontSize: 18.sp,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Form(
              key: formKey,
              child: SizedBox(
                height: context.setHeight(10),
                child: AuthTFF(
                  obscureText: false,
                  controller: emailCont,
                  hintText: 'ahmed@example.com',
                ),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            BlocBuilder<LoginCubit, LoginStates>(
              builder: (context, state) => AppButton(
                  onPressed: state is ForgotPasswordLoadingState
                      ? null
                      : () async {
                          await LoginCubit.getInstance(context)
                              .forgotPassword(emailCont.text, context);
                        },
                  text: 'Send'),
            )
          ],
        ),
      ),
    );
  }
}
