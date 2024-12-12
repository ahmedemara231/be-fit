import 'dart:developer';
import 'package:be_fit/src/features/plans/presentation/screens/plans.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../core/constants/constants.dart';
import '../../../core/data_source/local/cache_helper/shared_prefs.dart';
import '../../../core/helpers/base_widgets/myText.dart';
import '../../cardio/presentation/screens/cardio_exercise.dart';
import '../../exercises/presentation/screens/body_muscles.dart';
import '../models/bottom_nav_bar_item.dart';
import 'bloc/cubit.dart';
import 'bloc/states.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> mainScreens =
   const [
     BodyMuscles(),
     Plans(),
     Cardio(),
     Cardio(),
     // Setting(),
  ];

  List<String> titles = [
    'Default and Custom exercises',
    'Create your own plan',
    'Play Cardio',
    'Your Settings',
  ];


  List<Widget> icons = const [
    Icon(Icons.home_filled),
    Icon(Icons.notes),
    Icon(Icons.directions_run),
    Icon(Icons.settings_suggest)
  ];

  late List<BottomNavBarItem> items;

  final GlobalKey key1 = GlobalKey();
  final GlobalKey key2 = GlobalKey();
  final GlobalKey key3 = GlobalKey();
  final GlobalKey key4 = GlobalKey();

  List<GlobalKey> keys = [];
  @override
  void initState() {
    if(!CacheHelper.getInstance().getData('showCaseDone'))
      {
        WidgetsBinding.instance.addPostFrameCallback(
                (_) => ShowCaseWidget.of(context).startShowCase([key1, key2, key3, key4]));
      }

    keys = [key1, key2, key3, key4];
    items =
    [
      BottomNavBarItem(icon: const Icon(Icons.home_filled), title: 'Muscles', selectedColor: Colors.white),
      BottomNavBarItem(icon: const Icon(Icons.notes), title: 'Plans', selectedColor: Colors.orange),
      BottomNavBarItem(icon: const Icon(Icons.directions_run), title: 'Cardio', selectedColor: Colors.orange),
      BottomNavBarItem(icon: const Icon(Icons.settings_suggest), title: 'Settings', selectedColor: Colors.grey[350]!),
    ];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit,BottomNavState>(
      builder: (context, state)
      {
        log(CacheHelper.getInstance().getData('showCaseDone').toString());
        return Scaffold(
          bottomNavigationBar: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))
            ),
            child: BottomNavyBar(
              backgroundColor: Constants.appColor,
              items:
              List.generate(
                  items.length, (index) =>
              BottomNavyBarItem(
                icon: CacheHelper.getInstance().getData('showCaseDone')?
                items[index].icon :
                Showcase(
                    key: keys[index],
                    description: titles[index],
                    descTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.appColor
                    ),
                    child: icons[index]
                ),
                title: MyText(text: items[index].title),
                activeColor: items[index].selectedColor,
              )),
              selectedIndex: BottomNavCubit.getInstance(context).currentIndex,
              onItemSelected: (newTap)async =>  await BottomNavCubit.getInstance(context).changeScreen(
                context,
                newIndex: newTap,
              ),
            )
          ),
          body: mainScreens[BottomNavCubit.getInstance(context).currentIndex],
        );
      },
    );
  }
}