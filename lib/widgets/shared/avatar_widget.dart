import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final double radius;
  final String image;

  const Avatar({Key? key, required this.radius, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundImage: image == '' ? null : NetworkImage(image),
        radius: radius);
  }
}
