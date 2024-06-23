import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/data_types/user.dart';
import 'package:be_fit/models/widgets/app_button.dart';
import 'package:be_fit/models/widgets/modules/auth_TFF.dart';
import 'package:be_fit/view_model/sign_up/cubit.dart';
import 'package:be_fit/view_model/sign_up/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/widgets/modules/myText.dart';
import '../login/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final emailCont = TextEditingController();

  final passCont = TextEditingController();

  final confirmPassCont = TextEditingController();

  final formKey = GlobalKey<FormState>();

  late List<AuthTFF> signUpInputs;

  @override
  void initState() {
    signUpInputs =
    [
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
    return BlocBuilder<SignUpCubit,SignUpStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Image.asset('images/be-fit_logo.png'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyText(
                      text: 'Let\'s create an account',
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Form(
                    key: formKey,
                    child: Column(
                      children: List.generate(signUpInputs.length, (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: signUpInputs[index],
                      )),
                    ),
                  ),
                  if(state is SignUpLoadingState)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: CircularProgressIndicator(),
                    ),
                  if(state is! SignUpLoadingState)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: AppButton(
                        onPressed: ()async
                      {
                        if(formKey.currentState!.validate())
                        {
                          await SignUpCubit.getInstance(context).signUp(
                            user: Trainee(
                              email: emailCont.text,
                              password: passCont.text,
                            ),
                            context: context,
                          );
                        }
                      }, text: 'Sign up',
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(text: 'Already have have an account?',),
                      TextButton(
                          onPressed: ()
                          {
                            context.removeOldRoute(Login());
                          }, child: MyText(text: 'sign in')),
                    ],
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
