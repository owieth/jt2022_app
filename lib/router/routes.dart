import 'package:flutter/material.dart';

class Routes {
  static final home = GlobalKey(debugLabel: 'home');
  static final calendar = GlobalKey(debugLabel: 'calendar');
  static final location = GlobalKey(debugLabel: 'location');
  static final profile = GlobalKey(debugLabel: 'profile');

  static List<GlobalKey> getKeys() => [home, calendar, location, profile];
}
