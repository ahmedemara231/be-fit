import 'package:be_fit/constants.dart';
import 'package:flutter/material.dart';
import '../../../../models/widgets/modules/myText.dart';
import '../../../../models/widgets/modules/textFormField.dart';

class RepsAnaSets extends StatelessWidget {

  TextEditingController repsCont;
  TextEditingController setsCont;
  void Function()? cancelButtonAction;
  void Function()? conformButtonAction;

  RepsAnaSets({super.key,
    required this.repsCont,
    required this.setsCont,
    required this.cancelButtonAction,
    required this.conformButtonAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: TFF(
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  controller: repsCont,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  hintText: 'Reps',
                  labelText: 'Reps',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MyText(text: 'X',fontWeight: FontWeight.w500,fontSize: 20,),
              ),
              SizedBox(
                width: 70,
                height: 70,
                child: TFF(
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  controller: setsCont,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)
                  ),
                  hintText: 'Sets',
                  labelText: 'Sets',
                ),
              ),
            ],
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: cancelButtonAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.appColor,
              ),
              child: MyText(text: 'Cancel',color: Colors.white,),
            ),
            const SizedBox(width: 20,),
            ElevatedButton(
              onPressed: conformButtonAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.appColor,
              ),
              child: MyText(text: 'Conform',color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
