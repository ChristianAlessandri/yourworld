import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:yourworld/core/constants/app_colors.dart';

import 'package:yourworld/presentation/screens/map_screen.dart';
import 'package:yourworld/presentation/screens/travels_screen.dart';
import 'package:yourworld/presentation/screens/passport_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> widgetOptions = const [
    MapScreen(),
    TravelsScreen(),
    PassportScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary,
        unselectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Icon(FluentIcons.map_20_filled)
                : Icon(FluentIcons.map_20_regular),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Icon(FluentIcons.airplane_20_filled)
                : Icon(FluentIcons.airplane_20_regular),
            label: 'Travels',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? Icon(FluentIcons.person_20_filled)
                : Icon(FluentIcons.person_20_regular),
            label: 'Passport',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
