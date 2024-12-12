import 'package:be_fit/src/features/on_boarding/presentation/widgets/stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

import '../../../core/data_source/local/cache_helper/shared_prefs.dart';
import '../../auth/presentation/screens/login.dart';
import '../models/model.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<ScreenModel> onBoardingScreens = const [
    ScreenModel(image: 'onBoarding1', text: 'Create Your Custom Exercises'),
    ScreenModel(image: 'onBoarding2', text: 'Make your own plan'),
    ScreenModel(image: 'onBoarding3', text: 'Train Hard'),
  ];

  late PageController onBoardingCont;

  int pageIndex = 0;

  void moveToNextPage(int newPageIndex) {
    pageIndex = newPageIndex;
    setState(() {});
  }

  Future<void> moveToLogin(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        child: const Login(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 700),
      ),
      (route) => false,
    );

    await CacheHelper.getInstance()
        .setData(key: 'finishOnBoarding', value: true);
  }

  @override
  void initState() {
    onBoardingCont = PageController();
    super.initState();
  }

  @override
  void dispose() {
    onBoardingCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.all(12.0.r),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (newPageIndex) {
                  moveToNextPage(newPageIndex);
                },
                controller: onBoardingCont,
                itemBuilder: (context, index) => onBoardingScreens[index],
                itemCount: onBoardingScreens.length,
              ),
            ),
            MyStepper(activeStep: pageIndex),
            Row(
              children: [
                const Spacer(),
                IconButton(
                    onPressed: () {
                      if (pageIndex == 2) {
                        moveToLogin(context);
                        CacheHelper.getInstance()
                            .setData(key: 'finishOnBoarding', value: true);
                      } else {
                        onBoardingCont.nextPage(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOutCubic
                        );
                      }
                    },
                    icon: const Icon(Icons.arrow_forward_ios))
              ],
            )
          ],
        ),
      ),
    );
  }
}