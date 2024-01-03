import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/modules/snackBar.dart';
import 'package:be_fit/modules/textFormField.dart';
import 'package:be_fit/view/plans/create_plan/continue_planning.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePlan extends StatelessWidget {
   CreatePlan({super.key});

  final workOutNameCont = TextEditingController();
  final daysNumberCont = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlansCubit,PlansStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Create your plan',fontWeight: FontWeight.w500),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TFF(
                    obscureText: false,
                    controller: workOutNameCont,
                    hintText: 'Workout Name',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  TFF(
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    controller: daysNumberCont,
                    hintText: 'Days Number',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400]
                    ),
                    onPressed: ()async
                    {
                      if(formKey.currentState!.validate())
                        {
                          int? numberOfDays = int.tryParse(daysNumberCont.text);
                          if(numberOfDays! > 6)
                          {
                            MySnackBar.showSnackBar(
                              context: context,
                              message: 'Days shouldn\'t be more than 6',
                            );
                          }
                          else{
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContinuePlanning(
                                  name: workOutNameCont.text,
                                  daysNumber: numberOfDays,
                                ),
                              ),
                            );
                          }
                        }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/5),
                      child: MyText(
                        text: 'Make a Plan',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
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
