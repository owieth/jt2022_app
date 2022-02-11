import 'package:flutter/material.dart';
import 'package:jt2022_app/screens/calendar.dart';
import 'package:jt2022_app/screens/map.dart';
import 'package:jt2022_app/screens/profile.dart';
import 'package:jt2022_app/screens/workshops.dart';

class Routes {
  static const String map = '/map';
  static const String calendar = '/calendar';
  static const String profile = '/profile';
  static const String workshops = '/workshops';
}

class CustomRouter extends StatelessWidget {
  const CustomRouter(
      {Key? key, required this.navigatorKey, required this.tabItem})
      : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;
  final int tabItem;

  // void _push(BuildContext context) {
  //   var routeBuilders = _routeBuilders(context);

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => routeBuilders[Routes.detail]!(context),
  //     ),
  //   );
  // }

  Map<String, StatelessWidget> _routeBuilders(BuildContext context) {
    return {
      Routes.map: const Location(),
      Routes.calendar: const Calendar(),
      Routes.profile: const Profile(),
      Routes.workshops: const Workshops(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);

    return Navigator(
      key: navigatorKey,
      initialRoute: Routes.profile,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[tabItem]!,
        );
      },
    );
  }
}
