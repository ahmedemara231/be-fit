import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../base_widgets/image.dart';

class MyCarousel extends StatefulWidget {
  final List images;
  const MyCarousel({super.key, required this.images});

  @override
  State<MyCarousel> createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarousel> {
  int currentDot = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.images.map((e) => Padding(
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
              setState(() => currentDot = newDot);
            },
            disableCenter: false,
            enableInfiniteScroll: false,
            autoPlay: false,
          ),
        ),
        Padding(
          padding:  EdgeInsets.all(8.0.r),
          child: DotsIndicator(
            dotsCount: widget.images.length,
            position: currentDot,
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
