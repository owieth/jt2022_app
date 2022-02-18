import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/router/routes.dart';
import 'package:jt2022_app/screens/calendar.dart';
import 'package:jt2022_app/screens/home.dart';
import 'package:jt2022_app/screens/icons.dart';
import 'package:jt2022_app/screens/location.dart';
import 'package:jt2022_app/screens/profile.dart';

import '../constants/colors.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final List<Widget> _pages = [
    const Home(),
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
  ];

  final icons = [
    CustomIcons.homeIcon,
    CustomIcons.calendarIcon,
    CustomIcons.mapIcon,
    CustomIcons.profileIcon,
  ];

  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return !await Navigator.maybePop(
            Routes.getKeys()[_currentTab].currentState!.context,
          );
        },
        child: IndexedStack(
          index: _currentTab,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        items: icons.mapIndexed((index, _) => _buildItem(index)).toList(),
        currentIndex: _currentTab,
        onTap: (index) {
          setState(() {
            if (_pages[index] is SizedBox) {
              switch (index) {
                case 0:
                  _pages[index] = const Home();
                  break;
                case 1:
                  _pages[index] = const Calendar();
                  break;
                case 2:
                  _pages[index] = const Location();
                  break;
                case 3:
                  _pages[index] = const Profile();
                  break;
                default:
              }
            }

            _currentTab = index;
          });
        },
      ),
    );
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
    return _currentTab == index
        ? CustomColors.navigationActiveColor
        : Colors.grey;
  }
}
