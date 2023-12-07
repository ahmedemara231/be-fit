import 'package:be_fit/modules/myText.dart';
import 'package:flutter/material.dart';

class Begainner extends StatelessWidget {
  const Begainner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        title: MyText(text: 'Welcome'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: MediaQuery.of(context).size.height/3,
                width: double.infinity,
                child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOH0ymGUS8YYBZpeczsyHjCubwtXKDo11g0Q&usqp=CAU',fit: BoxFit.fill,)),
          ),
          MyText(text: 'IPhone 13 pro',fontSize: 25,fontWeight: FontWeight.w500,),
          MyText(text: '40000',fontSize: 25,fontWeight: FontWeight.w500,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                  child: MyText(text: 'Buy Now',color: Colors.white,),
                )),
          )
        ],
      ),
    );
  }
}
