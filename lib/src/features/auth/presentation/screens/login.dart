import 'package:be_fit/src/core/extensions/routes.dart';
import 'package:be_fit/src/features/auth/presentation/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/data_source/local/cache_helper/shared_prefs.dart';
import '../../../../core/data_source/remote/firebase_service/auth_service/implementation.dart';
import '../../../../core/helpers/base_widgets/divider.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../../../../core/helpers/base_widgets/toast.dart';
import '../../../bottom_bar/presentation/bottom_nav_bar.dart';
import '../../DI/blocs.dart';
import '../../data/data_source/models/user.dart';
import '../bloc/cubit.dart';
import '../bloc/states.dart';
import '../widgets/auth_TFF.dart';
import '../widgets/auth_component.dart';
import 'forgot_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController emailCont;

  late TextEditingController passCont;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    ChangeDependencies.change(FirebaseLoginCall());
    emailCont = TextEditingController();
    passCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailCont.dispose();
    passCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: Padding(
          padding:  EdgeInsets.all(12.0.r),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('images/be-fit_logo.png'),
                Padding(
                  padding:  EdgeInsets.all(8.0.r),
                  child: MyText(
                    text: 'Hi, Welcome Back',
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: AuthTFF(
                    obscureText: false,
                    controller: emailCont,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'ahmed@example.com',
                  ),
                ),
                BlocBuilder<AuthCubit, AuthStates>(
                  buildWhen: (previous, current) => current is SetPasswordVisibility,
                  builder: (context, state) => AuthTFF(
                    obscureText: AuthCubit.getInstance(context).isVisible,
                    controller: passCont,
                    suffixIcon: IconButton(
                      onPressed: () {
                        AuthCubit.getInstance(context).setPasswordVisibility();
                      },
                      icon: AuthCubit.getInstance(context).isVisible
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                    hintText: 'Password',
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding:  EdgeInsets.all(5.0.r),
                    child: TextButton(
                        onPressed: () => context.normalNewRoute(
                            const ForgotPassword()
                        ), child: MyText(
                          text: 'forget password?',
                          color: Constants.appColor,
                        )
                    ),
                  ),
                ),
                BlocConsumer<AuthCubit, AuthStates>(
                  listener: (context, state) {
                    if(state is LoginSuccessState){
                      context.removeOldRoute(const BottomNavBar());
                        MyToast.showToast(
                          context,
                          msg: 'Welcome Coach!',
                          color: Constants.appColor,
                        );
                    }else if(state is LoginErrorState){
                      MyToast.showToast(
                          context,
                          msg: state.errorMsg!,
                          color: Constants.appColor,
                          duration: const Duration(seconds: 3)
                      );
                    }
                  },
                  builder: (context, state) => AuthComponent(
                    onPressed: state is LoginLoadingState ?
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
                    buttonText: 'Login',
                    secondText: 'Don\'t have an account?',
                    thirdText: 'Sign up',
                    textButtonClick: () =>
                        context.normalNewRoute(const SignUp()),
                  ),
                ),
                Row(
                  children: [
                    const Expanded(child: MyDivider()),
                    Padding(
                      padding:  EdgeInsets.all(12.0.r),
                      child: MyText(text: 'OR'),
                    ),
                    const Expanded(child: MyDivider()),
                  ],
                ),
                Padding(
                  padding:  EdgeInsets.all(16.0.r),
                  child: InkWell(
                    onTap: () async {
                      await AuthCubit.getInstance(context)
                          .signInWithGoogle(GoogleSignInCall());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: CacheHelper.getInstance().shared.getBool('appTheme') == false
                            ? Colors.grey[200]
                            : HexColor('#333333'),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 50.w,
                                height: 50.h,
                                child: Image.asset('images/google.png')),
                            MyText(
                              text: 'Sign in with Google',
                              fontWeight: FontWeight.bold,
                            )
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
  }
}