import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/widgets/shared/skeleton.dart';
import 'package:jt2022_app/widgets/workshop/text_overlay_widget.dart';

class WorkshopItem extends StatelessWidget {
  final double width;
  final Workshop workshop;
  final bool isUserAlreadySignedUp;
  final bool hasMaxAmountOfWorkshops;
  final Function emitWorkshopChange;

  const WorkshopItem(
      {Key? key,
      required this.width,
      required this.workshop,
      required this.isUserAlreadySignedUp,
      required this.emitWorkshopChange,
      required this.hasMaxAmountOfWorkshops})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '/workshop',
        arguments: {
          "workshop": workshop,
          "isUserAlreadySignedUp": isUserAlreadySignedUp,
          "hasMaxAmountOfWorkshops": hasMaxAmountOfWorkshops
        },
      ).then((dynamic value) => {
            if (value != null) {emitWorkshopChange()}
          }),
      child: Stack(
        children: [
          SizedBox(
            height: 200,
            width: width,
            child: CachedNetworkImage(
              imageUrl: workshop.image,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (_, __) => _returnSkeletonLoader(),
              errorWidget: (_, __, ___) => _returnSkeletonLoader(),
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

  Widget _returnSkeletonLoader() {
    return SkeletonLoader(
      width: width,
      axis: width > 200 ? Axis.vertical : Axis.horizontal,
      innerPadding: EdgeInsets.zero,
    );
  }
}
