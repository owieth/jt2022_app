import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class Avatar extends StatelessWidget {
  final double radius;
  final String? image;

  const Avatar({Key? key, required this.radius, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return image == null
        ? Container(
            child: CircleAvatar(
              child: const Icon(
                LineIcons.user,
                color: Colors.white,
              ),
              radius: radius,
              backgroundColor: Colors.black,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
            ),
          )
        : CircleAvatar(
            backgroundImage: NetworkImage(image!),
            radius: radius,
          );
  }
}
