import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/widgets/text_overlay_widget.dart';

class Workshops extends StatelessWidget {
  final int index;
  final double width;
  final DocumentSnapshot doc;

  const Workshops(
      {Key? key, required this.index, required this.width, required this.doc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _imageName = doc['image'].toString();

    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/workshop'),
      child: Stack(
        children: [
          Container(
            height: 200,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              image: DecorationImage(
                  image: AssetImage("assets/images/$_imageName.jpeg"),
                  fit: BoxFit.cover),
            ),
          ),
          TextOverlay(
            text: doc['name'],
          )
        ],
      ),
    );
  }
}
