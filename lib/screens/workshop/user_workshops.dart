import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/constants/workshop.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/services/workshops/workshops_service.dart';
import 'package:jt2022_app/widgets/shared/skeleton.dart';
import 'package:jt2022_app/widgets/workshop/workshop_item_widget.dart';
import 'package:provider/provider.dart';

class UserWorkshops extends StatefulWidget {
  const UserWorkshops({Key? key}) : super(key: key);

  @override
  State<UserWorkshops> createState() => _UserWorkshopsState();
}

class _UserWorkshopsState extends State<UserWorkshops> {
  late Stream<List<Workshop>> _userWorkshopsStream;

  @override
  void initState() {
    super.initState();
    _getUsersWorkshop();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userWorkshopsStream,
      builder: (BuildContext context, AsyncSnapshot<List<Workshop>> snapshot) {
        if (!snapshot.hasData) {
          return const SkeletonLoader(
            padding: EdgeInsets.only(left: 35),
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
                          emitWorkshopChange: () => setState(
                            () => _getUsersWorkshop(),
                          ),
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

  void _getUsersWorkshop() {
    final _user = Provider.of<User?>(context, listen: false);
    _userWorkshopsStream = Stream.fromFuture(
      WorkshopsService().getUserWorkshops(_user!.uid),
    );
  }
}
