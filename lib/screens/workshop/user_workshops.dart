import 'package:flutter/material.dart';
import 'package:jt2022_app/constants/workshop.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/widgets/shared/skeleton.dart';
import 'package:jt2022_app/widgets/workshop/workshop_item_widget.dart';

class UserWorkshops extends StatelessWidget {
  final Future<List<Workshop>> userWorkshops;
  final Function emitWorkshopChange;
  const UserWorkshops(
      {Key? key, required this.userWorkshops, required this.emitWorkshopChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userWorkshops,
      builder: (BuildContext context, AsyncSnapshot<List<Workshop>> snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.only(top: 20),
            child: SkeletonLoader(
              innerPadding: EdgeInsets.only(left: 35),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 20),
          scrollDirection: Axis.horizontal,
          itemCount: WorkshopConstants.maxUserWorkshops,
          itemBuilder: (BuildContext context, int index) {
            final _padding = index != WorkshopConstants.maxUserWorkshops - 1
                ? const EdgeInsets.only(left: 35)
                : const EdgeInsets.symmetric(horizontal: 35);

            return Stack(
              children: [
                Padding(
                  padding: _padding,
                  child: snapshot.data?.asMap()[index] != null
                      ? WorkshopItem(
                          width: 200,
                          workshop: snapshot.data![index],
                          isUserAlreadySignedUp: true,
                          emitWorkshopChange: () => emitWorkshopChange(),
                        )
                      : Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                ),
                Positioned(
                  top: 10,
                  left: 185,
                  child: CircleAvatar(
                    child: Text("#${index + 1}"),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
