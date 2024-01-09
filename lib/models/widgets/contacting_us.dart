import 'package:be_fit/modules/myText.dart';
import 'package:flutter/material.dart';

class ContactingUsModel extends StatelessWidget {

  final Widget icon;
  final String title;
  final String value;

  const ContactingUsModel({super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
          child: Container(child: icon,),
      ),
      title: MyText(text: title,color: Colors.grey,fontWeight: FontWeight.bold,),
      subtitle: MyText(text: value,fontWeight: FontWeight.w500,fontSize: 16,),
    );
  }
}