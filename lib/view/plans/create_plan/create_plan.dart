import 'package:be_fit/constants.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/plan_creation/cubit.dart';
import 'package:be_fit/view_model/plan_creation/states.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view/plans/create_plan/continue_planning.dart';
import 'package:be_fit/view/plans/create_plan/number_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/widgets/modules/snackBar.dart';
import '../../../models/widgets/modules/textFormField.dart';

class CreatePlan extends StatelessWidget {
   CreatePlan({super.key});

  final workOutNameCont = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanCreationCubit,PlanCreationStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Create your plan',fontWeight: FontWeight.w500),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10),
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
                      borderSide: BorderSide(color: Constants.appColor)
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 28),
                    child: Row(
                      children: [
                        MyText(
                          text: 'Training Days',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: CacheHelper.getInstance().sharedPreferences.getBool('appTheme') == false ?
                              Colors.grey[300] :
                              Colors.grey[700]
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyText(
                                text: '${PlanCreationCubit.getInstance(context).currentIndex}',
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const NumberSelection(),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.appColor,
                    ),
                    onPressed: ()async
                    {
                      if(formKey.currentState!.validate())
                        {
                          if(PlanCreationCubit.getInstance(context).currentIndex == 0)
                          {
                            MySnackBar.showSnackBar(
                              context: context,
                              message: 'Days must be more than 0',
                            );
                          }
                          else{
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContinuePlanning(
                                  name: workOutNameCont.text,
                                  daysNumber: PlanCreationCubit.getInstance(context).currentIndex,
                                ),
                              ),
                            );
                          }
                        }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.setWidth(5),
                      ),
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
