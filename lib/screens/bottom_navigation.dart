import 'package:flutter/material.dart';
import 'package:jt2022_app/constants/colors.dart';
import 'package:jt2022_app/screens/custom_icons.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation(
      {Key? key, required this.currentTab, required this.onSelectTab})
      : super(key: key);

  final int currentTab;
  final ValueChanged<int> onSelectTab;
  final icons = [
    CustomIcons.mapIcon,
    CustomIcons.calendarIcon,
    CustomIcons.profileIcon,
    CustomIcons.workshopsIcon,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        items: [
          _buildItem(0),
          _buildItem(1),
          _buildItem(2),
          _buildItem(3),
        ],
        onTap: (index) => onSelectTab(index),
        currentIndex: currentTab);
  }

  BottomNavigationBarItem _buildItem(int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        icons[index],
        color: _colorTabMatching(index),
        size: 25,
      ),
      label: '',
    );
  }

  Color _colorTabMatching(int index) {
    return currentTab == index
        ? CustomColors.navigationActiveColor
        : Colors.grey;
  }
}
