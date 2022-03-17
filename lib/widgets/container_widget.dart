import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/constants/colors.dart';
import 'package:jt2022_app/constants/custom_icons.dart';
import 'package:jt2022_app/router/routes.dart';
import 'package:jt2022_app/screens/calendar/calendar.dart';
import 'package:jt2022_app/screens/home/home.dart';
import 'package:jt2022_app/screens/map/location.dart';
import 'package:jt2022_app/screens/profile/profile.dart';

class ContainerWidget extends StatefulWidget {
  const ContainerWidget({Key? key}) : super(key: key);

  @override
  _ContainerWidgetState createState() => _ContainerWidgetState();
}

class _ContainerWidgetState extends State<ContainerWidget> {
  final List<Widget> _pages = [
    Home(),
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
  ];

  final _icons = [
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
      bottomNavigationBar: SizedBox(
        height: 75,
        child: BottomNavigationBar(
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 20,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          type: BottomNavigationBarType.fixed,
          items: _icons.mapIndexed((index, _) => _buildItem(index)).toList(),
          currentIndex: _currentTab,
          elevation: 0,
          onTap: (index) {
            setState(() {
              if (_pages[index] is SizedBox) {
                switch (index) {
                  case 0:
                    _pages[index] = Home();
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
                }
              }

              _currentTab = index;
            });
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildItem(int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        _icons[index],
        color: _colorTabMatching(index),
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
