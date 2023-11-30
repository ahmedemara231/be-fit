import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/modules/snackBar.dart';
import 'package:be_fit/modules/textFormField.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:be_fit/view_model/exercises/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            title: MyText(text: 'Add Exercise'),
            actions: [
              TextButton(
                onPressed: () async
                {
                  if(formKey.currentState!.validate())
                    {
                      if(ExercisesCubit.getInstance(context).selectedExerciseImage == null)
                        {
                          MySnackBar.showSnackBar(
                              context: context,
                              message: 'please select image',
                          );
                        }
                      else{
                        await ExercisesCubit.getInstance(context).uploadPickedImageAndAddCustomExercise(
                          uId: 'uId',
                          muscle: muscleName,
                          name: nameCont.text,
                          description: descriptionCont.text,
                          context: context,
                        );
                      }
                    }
                },
                child: MyText(
                  text: 'Save',
                  fontSize: 20,
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
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
                    const Icon(
                      Icons.photo,
                      color: Colors.red,
                      size: 80,
                    ):
                    SizedBox(
                      width: MediaQuery.of(context).size.width/1.2,
                      height: MediaQuery.of(context).size.height/2,
                        child: Image.file(ExercisesCubit.getInstance(context).selectedExerciseImage!)),
                  ),
                  TFF(
                    obscureText: false,
                    controller: nameCont,
                    hintText: 'Name',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          width: 1.5,
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
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          width: 1.5,
                        )
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
