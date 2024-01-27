import '../../../models/widgets/modules/myText.dart';
import 'package:flutter/material.dart';

class InvalidConnectionScreen extends StatelessWidget {
  const InvalidConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 70,
            ),
            MyText(
              text: 'Check your internet connection and try again',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            )
          ],
        ),
      ),
    );
  }
}
