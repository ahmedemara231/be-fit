import 'package:be_fit/models/widgets/modules/myText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Test2 extends StatefulWidget {
  const Test2({super.key});

  @override
  State<Test2> createState() => _Test2State();
}

class _Test2State extends State<Test2> {

  @override
  void initState() {
    EasyLoading.show(status: 'loading...');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InkWell(
          onTap: () {

          },
          child: Center(child: MyText(text: 'Ahmed',fontSize: 50,))),
    );
  }
}
