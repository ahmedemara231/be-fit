import 'package:be_fit/models/widgets/modules/image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../view_model/exercises/cubit.dart';

class MyCarousel extends StatelessWidget {
  final List images;
  const MyCarousel({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: images
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16)),
                      child: MyNetworkImage(url: e),
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
            onPageChanged: (newDot, reason) {
              ExercisesCubit.getInstance(context).changeDot(newDot);
            },
            disableCenter: false,
            enableInfiniteScroll: false,
            autoPlay: false,
          ),
        ),
        Padding(
          padding:  EdgeInsets.all(8.0.r),
          child: DotsIndicator(
            dotsCount: images.length,
            position: ExercisesCubit.getInstance(context).dot,
            decorator: const DotsDecorator(
              color: Colors.black87, // Inactive color
              activeColor: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }
}
