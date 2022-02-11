import 'package:flutter/material.dart';
import 'package:jt2022_app/router/router.dart';

import 'bottom_navigation.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentTab = 0;

  final _pages = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _selectTab(int tabIndex) {
    if (tabIndex == _currentTab) {
      _pages[tabIndex].currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _pages[_currentTab].currentState!.maybePop();

        if (isFirstRouteInCurrentTab) {
          if (_currentTab != 0) {
            _selectTab(0);
            return false;
          }
        }

        return isFirstRouteInCurrentTab;
      },
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Scaffold(
          body: Stack(children: <Widget>[
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
            _buildOffstageNavigator(3),
          ]),
          bottomNavigationBar: BottomNavigation(
            currentTab: _currentTab,
            onSelectTab: _selectTab,
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _currentTab != index,
      child: CustomRouter(
        navigatorKey: _pages[index],
        tabItem: index,
      ),
    );
  }
}
