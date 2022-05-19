import 'package:flutter/material.dart';
import 'package:jt2022_app/models/user.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/services/workshops/workshops_service.dart';
import 'package:jt2022_app/widgets/shared/skeleton.dart';
import 'package:jt2022_app/widgets/workshop/workshop_item_widget.dart';
import 'package:collection/collection.dart';

class Workshops extends StatelessWidget {
  final Function emitWorkshopChange;
  final bool hasMaxAmountOfWorkshops;
  final CustomUser? user;

  const Workshops(
      {Key? key,
      required this.emitWorkshopChange,
      required this.hasMaxAmountOfWorkshops,
      required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: WorkshopsService().workshops,
      builder: (BuildContext context, AsyncSnapshot<List<Workshop>> snapshot) {
        final _width = MediaQuery.of(context).size.width;

        if (!snapshot.hasData) {
          return SkeletonLoader(
            width: _width,
            axis: Axis.vertical,
            padding: const EdgeInsets.only(top: 20),
            innerPadding:
                const EdgeInsets.only(left: 35, right: 35, bottom: 35),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 20),
          cacheExtent: 9999,
          scrollDirection: Axis.vertical,
          itemCount: snapshot.data!.length,
          itemBuilder: (BuildContext context, int index) {
            final Workshop workshop = snapshot.data![index];

            int? _index = user!.workshops
                .firstWhereOrNull((element) => element.id == workshop.id)
                ?.state
                .index;

            final state = _index != null
                ? AttendanceState.values[_index]
                : AttendanceState.wait;

            return Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, bottom: 35),
              child: WorkshopItem(
                width: _width,
                workshop: workshop,
                isUserAlreadySignedUp: workshop.attendees.contains(user!.id),
                hasMaxAmountOfWorkshops: hasMaxAmountOfWorkshops,
                emitWorkshopChange: emitWorkshopChange,
                state: state,
              ),
            );
          },
        );
      },
    );
  }
}
