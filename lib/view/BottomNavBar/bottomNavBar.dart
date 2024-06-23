import 'package:be_fit/constants/constants.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/view/plans/plans/plans.dart';
import 'package:be_fit/view/setting/setting.dart';
import 'package:be_fit/view_model/bottomNavBar/cubit.dart';
import 'package:be_fit/view_model/bottomNavBar/states.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/plan_creation/cubit.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../exercises/body_muscles.dart';

class BottomNavBar extends StatefulWidget {
    const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> mainScreens =
   [
     BodyMuscles(),
     const Plans(),
     const Setting(),
  ];

  @override
  void initState() {
    CacheHelper.getInstance().getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit,BottomNavState>(
      builder: (context, state)
      {
        return Scaffold(
          bottomNavigationBar: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))
            ),
            height: context.setHeight(9),
            child: BottomNavigationBar(
              backgroundColor: Constants.appColor,
              selectedIconTheme: const IconThemeData(
                color: Colors.white,
                size: 30,
              ),
              unselectedIconTheme: const IconThemeData(
                color: Colors.white70,
                size: 30,
              ),
              selectedLabelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70
              ),
              onTap: (newTap)async
              {
                await BottomNavCubit.getInstance(context).changeScreen(
                  context,
                  uId: CacheHelper.getInstance().uId,
                  planCreationCubit: PlanCreationCubit.getInstance(context),
                  plansCubit: PlansCubit.getInstance(context),
                  newIndex: newTap,
                );
              },
              currentIndex: BottomNavCubit.getInstance(context).currentIndex,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.fitness_center),
                    label: 'Exercises'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.notes),
                    label: 'Plans'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings_suggest),
                    label: 'Settings'),
              ],
            ),
          ),
          body: mainScreens[BottomNavCubit.getInstance(context).currentIndex],
        );
      },
    );
  }
}
