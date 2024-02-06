import 'package:be_fit/models/data_types/user.dart';
import 'package:be_fit/models/widgets/app_button.dart';
import 'package:be_fit/view_model/sign_up/cubit.dart';
import 'package:be_fit/view_model/sign_up/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/widgets/modules/divider.dart';
import '../../../models/widgets/modules/textFormField.dart';
import '../../../models/widgets/modules/myText.dart';
import '../login/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final nameCont = TextEditingController();

  final emailCont = TextEditingController();

  final passCont = TextEditingController();

  final phoneCont = TextEditingController();

  final formKey = GlobalKey<FormState>();

  late List<TFF> signUpInputs;

  @override
  void initState() {
    signUpInputs =
    [
      TFF(
        obscureText: false,
        controller: nameCont,
        hintText: 'name',
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white)
        ),
      ),
      TFF(
        obscureText: false,
        controller: emailCont,
        keyboardType: TextInputType.emailAddress,
        hintText: 'ahmed@example.com',
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white)
        ),
      ),
      TFF(
        obscureText: false,
        controller: phoneCont,
        hintText: 'phone',
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white)
        ),
      ),
      TFF(
        obscureText: false,
        controller: passCont,
        hintText: 'Password',
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white)
        ),
      ),
    ];
    super.initState();
  }

  @override
  void dispose() {
    nameCont.dispose();
    emailCont.dispose();
    passCont.dispose();
    phoneCont.dispose();
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
                    const CircularProgressIndicator(),
                  if(state is! SignUpLoadingState)
                    AppButton(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(text: 'Already have have an account?',),
                      TextButton(
                          onPressed: ()
                          {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ), (route) => false,
                            );
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
