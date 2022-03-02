import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final double radius;

  const Avatar({Key? key, required this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundImage: const AssetImage('assets/images/profile.jpeg'),
        radius: radius);
  }
}
