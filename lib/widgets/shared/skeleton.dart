import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonLoader extends StatelessWidget {
  final EdgeInsets padding;
  final EdgeInsets innerPadding;
  final Axis axis;
  final double width;

  const SkeletonLoader({
    Key? key,
    required this.innerPadding,
    this.padding = EdgeInsets.zero,
    this.width = 200,
    this.axis = Axis.horizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      scrollDirection: axis,
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: innerPadding,
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
