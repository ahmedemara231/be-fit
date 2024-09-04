import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import 'modules/textFormField.dart';

class AppSearchBar extends StatelessWidget {

  final void Function(String)? onChanged;
  final TextEditingController controller;

  const AppSearchBar({super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10),
      child: TFF(
        obscureText: false,
        controller: controller,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Constants.appColor),
            borderRadius: BorderRadius.circular(25)
        ),
        hintText: 'Search for Exercise',
        prefixIcon: const Icon(Icons.search),
        onChanged: onChanged,
      ),
    );
  }
}
