import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jt2022_app/models/user.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/widgets/workshop/text_overlay_widget.dart';

class WorkshopItem extends StatelessWidget {
  final double width;
  final Workshop workshop;
  final bool isUserAlreadySignedUp;
  final bool hasMaxAmountOfWorkshops;
  final Function emitWorkshopChange;
  final AttendanceState state;

  const WorkshopItem({
    Key? key,
    required this.width,
    required this.workshop,
    required this.isUserAlreadySignedUp,
    required this.emitWorkshopChange,
    required this.hasMaxAmountOfWorkshops,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '/workshop',
        arguments: {
          "workshop": workshop,
          "isUserAlreadySignedUp": isUserAlreadySignedUp,
          "hasMaxAmountOfWorkshops": hasMaxAmountOfWorkshops,
          "state": state
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
              placeholder: (_, __) => _returnLoadingIndicator(),
              errorWidget: (_, __, ___) => _returnLoadingIndicator(),
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

  Widget _returnLoadingIndicator() {
    return const SpinKitFadingCircle(
      color: Colors.white,
      size: 50.0,
    );
  }
}
