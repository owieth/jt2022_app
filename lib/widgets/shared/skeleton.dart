import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonLoader extends StatelessWidget {
  final EdgeInsets padding;
  final Axis axis;
  final double width;

  const SkeletonLoader({
    Key? key,
    required this.padding,
    this.width = 200,
    this.axis = Axis.horizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: axis,
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: padding,
          child: SkeletonLine(
            style: SkeletonLineStyle(
              height: 200,
              width: width,
              borderRadius: const BorderRadius.all(Radius.circular(25)),
            ),
          ),
        );
      },
    );
  }
}
