import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/screens/calendar/calendar.dart';
import 'package:jt2022_app/screens/home/home.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jt2022_app/screens/map/location.dart';
import 'package:jt2022_app/screens/profile/profile.dart';
import 'package:line_icons/line_icons.dart';

class ContainerWidget extends StatefulWidget {
  const ContainerWidget({Key? key}) : super(key: key);

  @override
  _ContainerWidgetState createState() => _ContainerWidgetState();
}

class _ContainerWidgetState extends State<ContainerWidget> {
  final List<Widget> _pages = [
    const Home(),
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
  ];

  final List<Map> _items = [
    {'text': 'Home', 'icon': LineIcons.home},
    {'text': 'Calendar', 'icon': LineIcons.calendarWithWeekFocus},
    {'text': 'Map', 'icon': LineIcons.mapMarked},
    {'text': 'Profile', 'icon': LineIcons.user},
  ];

  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTab,
        children: _pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: GNav(
          gap: 5,
          hoverColor: Colors.grey[100]!,
          activeColor: Colors.black,
          color: Colors.grey[800],
          tabBackgroundColor: Colors.white,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabs: _items.mapIndexed((index, _) => _buildItem(index)).toList(),
          selectedIndex: _currentTab,
          onTabChange: (int index) {
            setState(
              () {
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
                  }
                }

                _currentTab = index;
              },
            );
          },
        ),
      ),
    );
  }

  GButton _buildItem(int index) {
    return GButton(
      icon: _items[index]['icon'],
      text: _items[index]['text'],
    );
  }
}
