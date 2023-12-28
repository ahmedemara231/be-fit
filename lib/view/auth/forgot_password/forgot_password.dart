import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/modules/textFormField.dart';
import 'package:be_fit/view_model/login/cubit.dart';
import 'package:be_fit/view_model/login/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          appBar: AppBar(
            title: MyText(text: 'Forgot your password'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyText(text: 'Enter your email address',fontSize: 22,fontWeight: FontWeight.w500,),
                ),
                Form(
                  key: formKey,
                  child: TFF(
                    obscureText: false,
                    controller: emailCont,
                    enabledBorder: const OutlineInputBorder(),
                    hintText: 'ahmed@example.com',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                if(state is ForgotPasswordLoadingState)
                  const CircularProgressIndicator(),
                if(state is! ForgotPasswordLoadingState)
                  ElevatedButton(
                  onPressed: ()async
                  {
                    await LoginCubit.getInstance(context).forgotPassword(
                        emailCont.text,
                        context
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 50),
                    child: MyText(text: 'Send',color: Colors.white,fontSize: 18,),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
