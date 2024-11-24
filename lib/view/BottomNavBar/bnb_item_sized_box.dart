import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemSizedBox extends StatelessWidget {

  final String image;
  const ItemSizedBox({super.key,
    required this.image
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20.w,
      height: 20.h,
      child: Image.asset(image, color: Colors.white),
    );
  }
}
