import 'package:be_fit/src/features/exercises/presentation/blocs/exercises/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/helpers/base_widgets/myText.dart';

class ChooseImageSource extends StatelessWidget {
  const ChooseImageSource({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height/4,
      width: double.infinity,
      child: FittedBox(
        child: AlertDialog(
          title: MyText(text: 'Choose image from?'),
          actions: [
            ElevatedButton(
              onPressed: ()async {
                await context.read<ExercisesCubit>().pickImageForCustomExercise(
                  context,
                  source: ImageSource.gallery,
                ).then((value)
                {
                  Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.appColor
              ),
              child: MyText(text: 'Gallery', color: Colors.white),

            ),
            ElevatedButton(
              onPressed: ()async
              {
                await context.read<ExercisesCubit>().pickImageForCustomExercise(
                    context,
                    source: ImageSource.camera
                ).then((value)
                {
                  Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.appColor
              ),
              child: MyText(text: 'Camera', color: Colors.white,),

            ),
          ],
        ),
      ),
    );
  }
}
