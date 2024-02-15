import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/models/widgets/app_button.dart';
import 'package:be_fit/models/widgets/modules/auth_TFF.dart';
import 'package:be_fit/view_model/login/cubit.dart';
import 'package:be_fit/view_model/login/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/widgets/modules/myText.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final emailCont = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit,LoginStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MyText(text: 'Forgot password?',fontSize: 25,fontWeight: FontWeight.w500,),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0,top: 10),
                  child: MyText(text: 'Enter your email to send you the code',fontSize: 18,color: Colors.grey,fontWeight: FontWeight.bold,),
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
                const SizedBox(
                  height: 16,
                ),
                if(state is ForgotPasswordLoadingState)
                  const CircularProgressIndicator(),
                if(state is! ForgotPasswordLoadingState)
                 AppButton(
                     onPressed: () async
                 {
                   await LoginCubit.getInstance(context).forgotPassword(
                       emailCont.text,
                       context
                   );
                 }, text: 'Send')
              ],
            ),
          ),
        );
      },
    );
  }
}
