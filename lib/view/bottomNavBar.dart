import 'package:be_fit/view/log/chart_screen.dart';
import 'package:be_fit/view/plans/plans.dart';
import 'package:be_fit/view/profile/profile.dart';
import 'package:be_fit/view_model/bottomNavBar/cubit.dart';
import 'package:be_fit/view_model/bottomNavBar/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'exercises/bodyMuscles.dart';
import 'log/Log.dart';

class BottomNavBar extends StatelessWidget {
    BottomNavBar({super.key});

  final List<Widget> mainScreens =
   [
     BodyMuscles(),
     const Plans(),
     // const Log(),
     const Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit,BottomNavState>(
      builder: (context, state) 
      {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.blue,
            selectedIconTheme: const IconThemeData(
              color: Colors.red,
              size: 30,
            ),
            // selectedLabelStyle: const TextStyle(
            //   color: Colors.red,
            // ),
            unselectedIconTheme: const IconThemeData(
              color: Colors.grey,
              size: 30,
            ),
            onTap: (newTap)
            {
              BottomNavCubit.getInstance(context).changeScreen(
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
                  icon: Icon(Icons.timelapse),
                  label: 'Log'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile'),
            ],
          ),
          body: mainScreens[BottomNavCubit.getInstance(context).currentIndex],
        );
      },
    );
  }
}
