import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/data_types/user.dart';
import 'package:be_fit/models/widgets/auth_TFF.dart';
import 'package:be_fit/view_model/sign_up/cubit.dart';
import 'package:be_fit/view_model/sign_up/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/widgets/auth_component.dart';
import '../../../models/widgets/modules/myText.dart';
import '../login/login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController emailCont;

  late TextEditingController passCont;

  late TextEditingController confirmPassCont;

  final formKey = GlobalKey<FormState>();

  late List<AuthTFF> signUpInputs;

  @override
  void initState() {
    emailCont = TextEditingController();
    passCont = TextEditingController();
    confirmPassCont = TextEditingController();

    signUpInputs = [
      AuthTFF(
        obscureText: false,
        controller: emailCont,
        keyboardType: TextInputType.emailAddress,
        hintText: 'name@example.com',
      ),
      AuthTFF(
        obscureText: false,
        controller: passCont,
        hintText: 'Password',
      ),
      AuthTFF(
        obscureText: false,
        controller: confirmPassCont,
        hintText: 'Confirm password',
      ),
    ];
    super.initState();
  }

  @override
  void dispose() {
    emailCont.dispose();
    passCont.dispose();
    confirmPassCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocBuilder<SignUpCubit, SignUpStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.all(12.0.r),
                child: Column(
                  children: [
                    Image.asset('images/be-fit_logo.png'),
                    Padding(
                      padding:  EdgeInsets.all(8.0.r),
                      child: MyText(
                        text: 'Let\'s create an account',
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: List.generate(
                            signUpInputs.length,
                            (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12.0),
                                  child: signUpInputs[index],
                                )),
                      ),
                    ),
                    BlocBuilder<SignUpCubit, SignUpStates>(
                      builder: (context, state) => AuthComponent(
                        onPressed: state is SignUpLoadingState
                            ? null
                            : () async {
                                if (formKey.currentState!.validate()) {
                                  await SignUpCubit.getInstance(context).signUp(
                                    user: Trainee(
                                      email: emailCont.text,
                                      password: passCont.text,
                                    ),
                                    context: context,
                                  );
                                }
                              },
                        buttonText: 'Sign up',
                        secondText: 'Already have an account?',
                        thirdText: 'Login',
                        textButtonClick: () =>
                            context.removeOldRoute(const Login()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
