import 'package:carbon_icons/carbon_icons.dart';
import 'package:expense_tracker/src/styles/color_styles.dart';
import 'package:expense_tracker/src/views/goals_page.dart';
import 'package:expense_tracker/src/views/home_screen.dart';
import 'package:expense_tracker/src/views/report_screen.dart';
import 'package:expense_tracker/src/views/trend_analysis_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => CustomNavBarState();
}

class CustomNavBarState extends State<CustomNavBar> {
  int _currentIndex = 0;

  void changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = <Widget>[
    const HomePage(),
    const ReportPage(),
    const TrendAnalysisScreen(),
    GoalsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey.shade100,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: ColorStyles.primaryColor,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, // Add this to support 4 items
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              CarbonIcons.home,
              size: 28.0,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FeatherIcons.barChart2,
              size: 28.0,
            ),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FeatherIcons.trendingUp,
              size: 28.0,
            ),
            label: 'Trends',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CarbonIcons.task,
              size: 28.0,
            ),
            label: 'Goals',
          ),
        ],
      ),
    );
  }
}
