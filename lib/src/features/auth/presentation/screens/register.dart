import 'package:be_fit/src/core/data_source/remote/firebase_service/auth_service/implementation.dart';
import 'package:be_fit/src/core/extensions/routes.dart';
import 'package:be_fit/src/core/helpers/base_widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../../DI/blocs.dart';
import '../../data/data_source/models/user.dart';
import '../bloc/cubit.dart';
import '../bloc/states.dart';
import '../widgets/auth_TFF.dart';
import '../widgets/auth_component.dart';
import 'login.dart';

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
    ChangeDependencies.change(FirebaseRegisterCall());
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
    return BlocBuilder<AuthCubit, AuthStates>(
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
                  BlocConsumer<AuthCubit, AuthStates>(
                    listener: (context, state) {
                      if(state is SignUpSuccessState){
                        context.removeOldRoute(const Login());
                      }else if(state is SignUpErrorState){
                        MyToast.showToast(context, msg: state.errorMsg!);
                      }
                    },
                    builder: (context, state) => AuthComponent(
                      onPressed: state is SignUpLoadingState ?
                      null : () async {
                              if (formKey.currentState!.validate()) {
                                await context.read<AuthCubit>().callFirebaseAuth(
                                    trainee: Trainee(
                                      email: emailCont.text,
                                      password: passCont.text,
                                    )
                                );
                              }
                            },
                      buttonText: 'Sign up',
                      secondText: 'Already have an account?',
                      thirdText: 'Login',
                      textButtonClick: () => Navigator.pop(context)
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
