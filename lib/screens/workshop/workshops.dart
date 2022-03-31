import 'package:flutter/material.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/services/workshops/workshops_service.dart';
import 'package:jt2022_app/widgets/shared/skeleton.dart';
import 'package:jt2022_app/widgets/workshop/workshop_item_widget.dart';

class Workshops extends StatelessWidget {
  const Workshops({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: WorkshopsService().workshops,
      builder: (BuildContext context, AsyncSnapshot<List<Workshop>> snapshot) {
        final _width = MediaQuery.of(context).size.width;

        if (!snapshot.hasData) {
          return SkeletonLoader(
            width: _width,
            axis: Axis.vertical,
            padding: const EdgeInsets.only(left: 35, right: 35, bottom: 35),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 20),
          scrollDirection: Axis.vertical,
          itemCount: snapshot.data!.length,
          itemBuilder: (BuildContext context, int index) {
            const _padding = EdgeInsets.only(left: 35, right: 35, bottom: 35);
            final workshop = snapshot.data![index];

            return Padding(
              padding: _padding,
              child: WorkshopItem(
                width: _width,
                workshop: workshop,
                isUserAlreadySignedUp: true,
              ),
            );
          },
        );
      },
    );
  }
}
