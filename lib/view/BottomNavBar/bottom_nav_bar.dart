import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/models/widgets/modules/myText.dart';
import 'package:be_fit/view/cardio/cardio_exercise.dart';
import 'package:be_fit/view/plans/plans/plans.dart';
import 'package:be_fit/view/setting/setting.dart';
import 'package:be_fit/view_model/bottomNavBar/cubit.dart';
import 'package:be_fit/view_model/bottomNavBar/states.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/data_types/bottom_nav_bar_item.dart';
import '../body_muscles/body_muscles.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  final List<Widget> mainScreens =
   const [
     BodyMuscles(),
     Plans(),
     Cardio(),
     Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    final List<BottomNavBarItem> items =
    [
      BottomNavBarItem(icon: const Icon(Icons.home_filled), title: 'Muscles', selectedColor: Colors.white),
      BottomNavBarItem(icon: const Icon(Icons.notes), title: 'Plans', selectedColor: Colors.orange),
      BottomNavBarItem(icon: const Icon(Icons.directions_run), title: 'Cardio', selectedColor: Colors.orange),
      BottomNavBarItem(icon: const Icon(Icons.settings_suggest), title: 'Settings', selectedColor: Colors.grey[350]!),
    ];

    return BlocBuilder<BottomNavCubit,BottomNavState>(
      builder: (context, state)
      {
        return Scaffold(
          bottomNavigationBar: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))
            ),
            child: BottomNavyBar(
              backgroundColor: Constants.appColor,
              items: List.generate(
                  items.length, (index) => BottomNavyBarItem(
                  icon: items[index].icon,
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