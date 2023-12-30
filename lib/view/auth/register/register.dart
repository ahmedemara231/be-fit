import 'package:be_fit/models/data_types/user.dart';
import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view_model/sign_up/cubit.dart';
import 'package:be_fit/view_model/sign_up/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../modules/textFormField.dart';

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
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      TFF(
        obscureText: false,
        controller: emailCont,
        keyboardType: TextInputType.emailAddress,
        hintText: 'ahmed@example.com',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      TFF(
        obscureText: false,
        controller: phoneCont,
        hintText: 'phone',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      TFF(
        obscureText: false,
        controller: passCont,
        hintText: 'Password',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit,SignUpStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Stack(
              children: [
                SizedBox(
                    width: double.infinity,
                    child: Image.network(fit:BoxFit.fill,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSD4kN_9TODip-tmg7yQF6zizDOMNwFsquoiw&usqp=CAU')),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height/1.5,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.separated(
                      itemBuilder: (context, index) => signUpInputs[index],
                      separatorBuilder: (context, index) => const SizedBox(height: 16,),
                      itemCount: signUpInputs.length,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                      onPressed: ()async
                      {
                        await SignUpCubit.getInstance(context).signUp(
                            user: Trainee(
                              name: nameCont.text,
                              email: emailCont.text,
                              phone: phoneCont.text,
                              password: passCont.text,
                            ),
                            context: context
                        );
                      }, child: MyText(text: 'Sign Up')),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
