import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/models/widgets/modules/myText.dart';
import 'package:flutter/material.dart';

class MyNetworkImage extends StatelessWidget {
  final String url;
  const MyNetworkImage({super.key,
    required this.url
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5)
      ),
      child: Image.network(
          url,
        fit: BoxFit.fill,
        loadingBuilder: (context, child, loadingProgress) {
          if(loadingProgress == null)
          {
            return child;
          }
          else{
            return SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  value: loadingProgress.cumulativeBytesLoaded /  3500000
                )
            );
          }
        },
        errorBuilder: (context, error, stackTrace) =>
            Center(
              child: MyText(
                text: 'Failed Load Image',
                color: Constants.appColor,
                fontWeight: FontWeight.w500,
              ),
            ),
      ),
    );
  }
}
