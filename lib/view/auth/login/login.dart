import 'package:be_fit/models/data_types/user.dart';
import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/modules/textFormField.dart';
import 'package:be_fit/view/auth/forgot_password/forgot_password.dart';
import 'package:be_fit/view_model/login/cubit.dart';
import 'package:be_fit/view_model/login/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../register/register.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final emailCont = TextEditingController();
  final passCont = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit,LoginStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: Column(
              children: [
                TFF(
                  obscureText: false,
                  controller: emailCont,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'ahmed@example.com',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TFF(
                  obscureText: false,
                  controller: passCont,
                  hintText: 'Password',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                if(state is LoginLoadingState)
                  const CircularProgressIndicator(),
                if(state is! LoginLoadingState)
                  ElevatedButton(
                    onPressed: () async
                    {
                      if(formKey.currentState!.validate())
                        {
                          await LoginCubit.getInstance(context).login(
                              user: Trainee(
                                email: emailCont.text,
                                password: passCont.text,
                              ),
                              context: context,
                          );
                        }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 10),
                      child: MyText(text: 'Login',color: Colors.white,fontSize: 18,),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      onPressed: ()
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPassword(),
                          ),
                        );
                      }, child: MyText(text: 'forget password?')),
                ),
                TextButton(
                    onPressed: ()
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ),
                      );
                    }, child: MyText(text: 'sign up'))
              ],
            ),
          ),
        );
      },
    );
  }
}
