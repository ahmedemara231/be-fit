import 'package:flutter/material.dart';

class OtpTff extends StatelessWidget {

  var controller;
  String hintText;

   OtpTff({super.key,
     required this.controller,
     required this.hintText,
   });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      controller: controller,
      validator: (value)
      {
        if(value!.isEmpty)
          {
            return '';
          }
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
