import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/widgets/workshop/text_overlay_widget.dart';

class Workshops extends StatelessWidget {
  final double width;
  final DocumentSnapshot doc;
  final Function emitWorkshopChange;
  final bool isUserAlreadySignedUp;

  const Workshops(
      {Key? key,
      required this.width,
      required this.doc,
      required this.emitWorkshopChange,
      required this.isUserAlreadySignedUp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _imageName = doc.data()!.toString().contains('image')
        ? doc['image'].toString()
        : 'placeholder';

    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/workshop', arguments: {
        "id": doc.id,
        "title": doc['name'],
        "image": _imageName,
        "isUserAlreadySignedUp": isUserAlreadySignedUp ? "true" : ""
      }).then((_) => emitWorkshopChange()),
      child: Stack(
        children: [
          Container(
            height: 200,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              image: DecorationImage(
                image: AssetImage("assets/images/$_imageName.jpeg"),
                fit: BoxFit.cover,
              ),
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
