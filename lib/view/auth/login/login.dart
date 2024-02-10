import 'package:be_fit/constants.dart';
import 'package:be_fit/models/data_types/user.dart';
import 'package:be_fit/models/widgets/app_button.dart';
import 'package:be_fit/models/widgets/modules/auth_TFF.dart';
import 'package:be_fit/models/widgets/modules/divider.dart';
import 'package:be_fit/view/auth/forgot_password/forgot_password.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/login/cubit.dart';
import 'package:be_fit/view_model/login/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../models/widgets/modules/myText.dart';
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
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('images/be-fit_logo.png'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyText(
                        text: 'Hi, Welcome Back',
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30,),
                    AuthTFF(
                      obscureText: false,
                      controller: emailCont,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'ahmed@example.com',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AuthTFF(
                      obscureText: LoginCubit.getInstance(context).isVisible,
                      controller: passCont,
                      suffixIcon: IconButton(
                          onPressed: ()
                          {
                            LoginCubit.getInstance(context).setPasswordVisibility();
                          },
                          icon: LoginCubit.getInstance(context).isVisible == true?
                          const Icon(Icons.visibility_off):
                          const Icon(Icons.visibility),
                      ),
                      hintText: 'Password',
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextButton(
                            onPressed: ()
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPassword(),
                                ),
                              );
                            }, child: MyText(
                          text: 'forget password?',
                          color: Constants.appColor,
                        )),
                      ),
                    ),
                    if(state is LoginLoadingState)
                      const CircularProgressIndicator(),
                    if(state is! LoginLoadingState)
                      AppButton(onPressed: ()async
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
                      }, text: 'Login',
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(text: 'Don\'t have an account?',),
                        TextButton(
                            onPressed: ()
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUp(),
                                ),
                              );
                            }, child: MyText(text: 'sign up',)),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(child: MyDivider()),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: MyText(text: 'OR'),
                        ),
                        const Expanded(child: MyDivider()),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        onTap: () async
                        {
                          await LoginCubit.getInstance(context).signInWithGoogle(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: CacheHelper.getInstance().sharedPreferences.getBool('appTheme') == false?
                            Colors.grey[200]:
                            HexColor('#333333'),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Image.asset('images/google.png')
                                ),
                                MyText(text: 'Sign in with Google',fontWeight: FontWeight.bold,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
