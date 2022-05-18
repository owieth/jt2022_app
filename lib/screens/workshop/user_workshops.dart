import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/constants/colors.dart';
import 'package:jt2022_app/constants/workshop.dart';
import 'package:jt2022_app/models/user.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/widgets/shared/skeleton.dart';
import 'package:jt2022_app/widgets/workshop/workshop_item_widget.dart';

class UserWorkshops extends StatelessWidget {
  final CustomUser? user;
  final Future<List<Workshop>> userWorkshops;
  final Function emitWorkshopChange;
  const UserWorkshops(
      {Key? key,
      required this.user,
      required this.userWorkshops,
      required this.emitWorkshopChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userWorkshops,
      builder: (BuildContext context, AsyncSnapshot<List<Workshop>> snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: SkeletonLoader(
              innerPadding: EdgeInsets.only(left: 35),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 20),
          scrollDirection: Axis.horizontal,
          itemCount: WorkshopConstants.maxUserWorkshops,
          itemBuilder: (BuildContext context, int index) {
            final _padding = index != WorkshopConstants.maxUserWorkshops - 1
                ? const EdgeInsets.only(left: 35)
                : const EdgeInsets.symmetric(horizontal: 35);

            final workshop = snapshot.data?.asMap()[index];
            final _icon = getIcon(workshop);

            return Stack(
              children: [
                Padding(
                  padding: _padding,
                  child: workshop != null
                      ? WorkshopItem(
                          width: 200,
                          workshop: snapshot.data![index],
                          isUserAlreadySignedUp: true,
                          hasMaxAmountOfWorkshops: false,
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
                  left: 45,
                  child: Icon(
                    _icon,
                    size: Theme.of(context).textTheme.headline1!.fontSize,
                    color: Theme.of(context).textTheme.headline1!.color,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 185,
                  child: CircleAvatar(
                    backgroundColor: CustomColors.primaryColor,
                    child: Text(
                      "#${index + 1}",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  IconData getIcon(Workshop? workshop) {
    if (workshop != null) {
      switch (user!.workshops
          .firstWhere((element) => element.id == workshop.id)
          .state) {
        case AttendanceState.approved:
          return EvaIcons.checkmarkCircle2Outline;

        case AttendanceState.refused:
          return EvaIcons.closeCircleOutline;

        default:
          return EvaIcons.clockOutline;
      }
    }

    return EvaIcons.clockOutline;
  }
}
