import 'package:flutter/material.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/widgets/workshop/text_overlay_widget.dart';

class WorkshopItem extends StatelessWidget {
  final double width;
  final Workshop workshop;
  final bool isUserAlreadySignedUp;
  final Function emitWorkshopChange;

  const WorkshopItem(
      {Key? key,
      required this.width,
      required this.workshop,
      required this.isUserAlreadySignedUp,
      required this.emitWorkshopChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '/workshop',
        arguments: {
          "workshop": workshop,
          "isUserAlreadySignedUp": isUserAlreadySignedUp
        },
      ).then((_) => emitWorkshopChange()),
      child: Stack(
        children: [
          Container(
            height: 200,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              image: DecorationImage(
                image: AssetImage("assets/images/${workshop.image}.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          TextOverlay(
            text: workshop.name,
            maxWidth: width == 200 ? 150 : 250,
          ),
        ],
      ),
    );
  }
}
