import 'package:endol/providers/current_index_provider.dart';
import 'package:endol/screens/chart/chart_screen.dart';
import 'package:endol/screens/splash/screens/home_screen.dart';
import 'package:endol/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  final List<Widget> _pages = [
    const HomeScreen(),
    const ChartScreen(),
    const ProfileScreen()
  ];

  void _onTap(int index, CurrentIndexProvider currentIndexProvider) {
    currentIndexProvider.setCurrentIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndexProvider = Provider.of<CurrentIndexProvider>(context);
    return Scaffold(
      bottomNavigationBar: DotNavigationBar(
        currentIndex: currentIndexProvider.currentIndex,
        onTap: (index) {
          _onTap(index, currentIndexProvider);
        },
        borderRadius: 16,
        splashBorderRadius: 0,
        backgroundColor: AppColors.thatBrown,
        splashColor: AppColors.thatBrown,
        dotIndicatorColor: AppColors.thatBrown,
        unselectedItemColor: AppColors.unselectedBrown,
        selectedItemColor: AppColors.selectedBrown,
        paddingR: const EdgeInsets.only(bottom: 6, top: 5),
        marginR: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        items: [
          DotNavigationBarItem(
            icon: const Icon(
              FontAwesomeIcons.house,
              size: 25,
            ),
          ),
          DotNavigationBarItem(
            icon: const Icon(
              FontAwesomeIcons.chartBar,
              size: 25,
            ),
          ),
          DotNavigationBarItem(
            icon: const Icon(
              FontAwesomeIcons.user,
              size: 25,
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndexProvider.currentIndex,
        children: _pages,
      ),
    );
  }
}
