import 'package:be_fit/src/core/constants/constants.dart';
import 'package:be_fit/src/core/extensions/mediaQuery.dart';
import 'package:be_fit/src/core/extensions/routes.dart';
import 'package:be_fit/src/core/helpers/base_widgets/toast.dart';
import 'package:be_fit/src/features/auth/presentation/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/app_widgets/app_button.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../bloc/cubit.dart';
import '../bloc/states.dart';
import '../widgets/auth_TFF.dart';

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
            BlocConsumer<AuthCubit, AuthStates>(
              listener: (context, state) {
                if(state is ForgotPasswordSuccessState){
                  context.removeOldRoute(const Login());
                }
                else if(state is ForgotPasswordErrorState){
                  MyToast.showToast(context, msg: state.errorMsg, color: Constants.appColor);
                }
              },
              builder: (context, state) => AppButton(
                  text: 'Send',
                  onPressed: state is ForgotPasswordLoadingState ?
                  null : () async {
                          await context.read<AuthCubit>().forgotPassword(
                              emailCont.text
                          );
                        },
              ),
            )
          ],
        ),
      ),
    );
  }
}
