import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../../models/widgets/modules/myText.dart';
import '../../view_model/exercises/cubit.dart';

class MyCarousel extends StatelessWidget {

  final List images;
  const MyCarousel({super.key,
    required this.images
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: images.map((e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Image.network(
                e,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => MyText(
                  text: 'Failed to load image',
                  fontWeight: FontWeight.bold,
                ),),
            ),
          )).toList(),
          options: CarouselOptions(
            onPageChanged: (newDot, reason)
            {
              ExercisesCubit.getInstance(context).changeDot(newDot);
            },
            disableCenter: false,
            enableInfiniteScroll: false,
            autoPlay: false,
          ),
        ),
        DotsIndicator(
          dotsCount: images.length,
          position: ExercisesCubit.getInstance(context).dot,
          decorator: const DotsDecorator(
            color: Colors.black87, // Inactive color
            activeColor: Colors.redAccent,
          ),
        ),
      ],
    );
  }
}
