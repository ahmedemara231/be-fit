import 'package:be_fit/view/plans/plans/plans.dart';
import 'package:be_fit/view/setting/setting.dart';
import 'package:be_fit/view_model/bottomNavBar/cubit.dart';
import 'package:be_fit/view_model/bottomNavBar/states.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/internet_connection_check/internet_connection_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../exercises/bodyMuscles.dart';

class BottomNavBar extends StatefulWidget {
    const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> mainScreens =
  [
     const BodyMuscles(),
     const Plans(),
     Setting(),
  ];

  @override
  void initState() {
    CacheHelper.getInstance().getUserData();
    BottomNavCubit.getInstance(context).getAllPlans(
      checkMethod: FirstCheckMethod.getInstance(),
      uId: CacheHelper.getInstance().uId,
      context: context,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit,BottomNavState>(
      builder: (context, state)
      {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.red[400],
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
                  icon: Icon(Icons.person),
                  label: 'Profile'),
            ],
          ),
          body: state is FetchAllDataLoadingState?
          const Center(child: CircularProgressIndicator(),) :
          RefreshIndicator(
            backgroundColor: Colors.red[400],
            color: Colors.white,
            onRefresh: ()
            {
              BottomNavCubit.getInstance(context).getAllPlans(
                checkMethod: FirstCheckMethod.getInstance(),
                uId: CacheHelper.getInstance().uId,
                context: context,
              );
              return Future(() => null);
            }, child: mainScreens[BottomNavCubit.getInstance(context).currentIndex]),
        );
      },
    );
  }
}
