import 'package:be_fit/constants.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/widgets/app_button.dart';
import 'package:be_fit/models/widgets/modules/snackBar.dart';
import 'package:be_fit/view_model/plan_creation/cubit.dart';
import '../../../models/widgets/modules/textFormField.dart';
import '../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:be_fit/view_model/exercises/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/data_types/add_custom_exercise.dart';

class CreateExercise extends StatelessWidget {

  String muscleName;
   CreateExercise({super.key,
     required this.muscleName,
   });

  final nameCont = TextEditingController();
  final descriptionCont = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisesCubit,ExercisesStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Add Exercise',fontSize: 25,fontWeight: FontWeight.bold,),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if(state is CreateCustomExerciseLoadingState)
                      const LinearProgressIndicator(),
                    IconButton(
                      onPressed: ()async
                      {
                        await ExercisesCubit.getInstance(context).pickImageForCustomExercise();
                      },
                      icon: ExercisesCubit.getInstance(context).selectedExerciseImage == null ?
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.photo,
                          color: Constants.appColor,
                          size: 80,
                        ),
                      ):
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: context.setWidth(1.2),
                          height: context.setHeight(2.2),
                            child: Image.file(ExercisesCubit.getInstance(context).selectedExerciseImage!)),
                      ),
                    ),
                    TFF(
                      obscureText: false,
                      controller: nameCont,
                      hintText: 'Name',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Constants.appColor,
                          )
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TFF(
                      obscureText: false,
                      controller: descriptionCont,
                      hintText: 'Description',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Constants.appColor,
                          ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyText(
                          text: 'Category : $muscleName',
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    AppButton(
                      onPressed: state is CreateCustomExerciseLoadingState?
                      null : () async
                      {
                        if(formKey.currentState!.validate())
                        {
                          if(ExercisesCubit.getInstance(context).selectedExerciseImage == null)
                            {
                              MySnackBar.showSnackBar(
                                  context: context,
                                  message: 'Please select exercise photo',
                              );
                            }
                          else{
                            await ExercisesCubit.getInstance(context).uploadPickedImageAndAddCustomExercise(
                              context: context,
                              addCustomExerciseModel: AddCustomExerciseModel(
                                uId: CacheHelper.getInstance().uId,
                                muscle: muscleName,
                                name: nameCont.text,
                                description: descriptionCont.text,
                              ),
                            );
                          }
                        }
                    }, text: 'Add',
                    )
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
