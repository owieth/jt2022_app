import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/services/workshops/workshops_service.dart';
import 'package:jt2022_app/widgets/shared/skeleton.dart';
import 'package:jt2022_app/widgets/workshop/workshop_item_widget.dart';
import 'package:provider/provider.dart';

class Workshops extends StatefulWidget {
  final Function emitWorkshopChange;
  final bool hasMaxAmountOfWorkshops;

  const Workshops(
      {Key? key,
      required this.emitWorkshopChange,
      required this.hasMaxAmountOfWorkshops})
      : super(key: key);

  @override
  State<Workshops> createState() => _WorkshopsState();
}

class _WorkshopsState extends State<Workshops> {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context, listen: false);

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

            return Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, bottom: 35),
              child: WorkshopItem(
                width: _width,
                workshop: workshop,
                isUserAlreadySignedUp: workshop.attendees.contains(_user!.uid),
                hasMaxAmountOfWorkshops: widget.hasMaxAmountOfWorkshops,
                emitWorkshopChange: widget.emitWorkshopChange,
              ),
            );
          },
        );
      },
    );
  }
}
