import 'package:be_fit/view/auth/login/login.dart';
import 'package:be_fit/view/onBoarding/model.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../constants/constants.dart';
import '../../model/local/cache_helper/shared_prefs.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<ScreenModel> onBoardingScreens =
  const [
    ScreenModel(image: 'onBoarding1', text: 'Search for Plants'),
    ScreenModel(image: 'onBoarding2', text: 'Save your Plants'),
    ScreenModel(image: 'onBoarding3', text: 'Share your Plants'),
  ];

  late PageController onBoardingCont;

  int pageIndex = 0;

  void moveToNextPage(int newPageIndex)
  {
    pageIndex = newPageIndex;
    setState(() {});
  }

  Future<void> moveToLogin(context)async
  {
    Navigator.pushAndRemoveUntil(
      context, PageTransition(
      child: Login(),
      type: PageTransitionType.fade,
      duration: const Duration(milliseconds: 700),
    ), (route) => false,
    );

    await CacheHelper.getInstance().setData(
        key: 'finishOnBoarding', value: true
    ).then((value) => debugPrint('finish onBoarding'));
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (newPageIndex)
                {
                  moveToNextPage(newPageIndex);
                },
                controller: onBoardingCont,
                itemBuilder: (context, index) => onBoardingScreens[index],
                itemCount: onBoardingScreens.length,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: DotsIndicator(
                dotsCount: onBoardingScreens.length,
                position: pageIndex,
                decorator: DotsDecorator(
                  size: const Size(10, 10),
                  color: Constants.appColor, // Inactive color
                  activeColor: Colors.grey,
                ),
              ),
            ),
            Row(
              children: [
                const Spacer(),
                IconButton(
                    onPressed: () {
                      if(pageIndex == 2)
                      {
                        moveToLogin(context);
                        CacheHelper.getInstance().setData(key: 'finishOnBoarding', value: true);
                      }
                      else{
                        onBoardingCont.nextPage(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOutCubic
                          // curve: Curves.easeOutQuad
                        );
                      }
                    },
                    icon: const Icon(Icons.arrow_forward_ios)
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
