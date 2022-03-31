import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/screens/workshop/workshops.dart';
import 'package:jt2022_app/widgets/shared/avatar_widget.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _userWorkshopsStream;
  late final User _user;

  @override
  void initState() {
    _user = Provider.of<User?>(context, listen: false)!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(35, 70, 35, 0),
          child: Row(
            children: [
              const Avatar(radius: 30),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi 👋,',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      _user.displayName ?? "",
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 50.0),
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Text(
            'Meine Workshops',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        // SizedBox(
        //   height: 200,
        //   child: _buildUsersWorkshopsStreamBuilder(),
        // ),
        const SizedBox(height: 50.0),
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Text(
            'Workshops',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        const Expanded(
          child: Workshops(),
        ),
      ],
    );
  }

  // StreamBuilder _buildUsersWorkshopsStreamBuilder() {
  //   return StreamBuilder<DocumentSnapshot>(
  //     stream: _userWorkshopsStream,
  //     builder: (BuildContext context,
  //         AsyncSnapshot<DocumentSnapshot> usersWorkshops) {
  //       if (!usersWorkshops.hasData) {
  //         return const SkeletonLoader(
  //           padding: EdgeInsets.symmetric(horizontal: 35),
  //         );
  //       }

  //       // List _usersWorkshops = List<String>.filled(6, '');

  //       // if (usersWorkshops.data!.exists) {
  //       //   final List<String> workshops =
  //       //       List<String>.from(usersWorkshops.data?.get('workshops'));
  //       //   workshops.forEachIndexed((index, workshop) {
  //       //     _usersWorkshops[index] = workshop;
  //       //   });
  //       // }

  //       final _workshops = workshops.data!.docs
  //           .where((element) => _usersWorkshops.contains(element.id));
  //       final _workshopCount = _workshops.length;

  //       return ListView.builder(
  //         padding: const EdgeInsets.only(top: 20),
  //         scrollDirection: Axis.horizontal,
  //         itemCount: Workshop.maxUserWorkshops,
  //         itemBuilder: (BuildContext context, int index) {
  //           final _padding = index != _workshopCount - 1
  //               ? const EdgeInsets.only(left: 35)
  //               : const EdgeInsets.symmetric(horizontal: 35);

  //           print(_workshops);

  //           final _workshop = _workshops.elementAt(index);

  //           return Stack(
  //             children: [
  //               if (_workshop != '') ...{
  //                 _buildWorkshopItem(
  //                     index, _workshop, _workshopCount, _padding),
  //               } else ...{
  //                 Padding(
  //                   padding: _padding,
  //                   child: Container(
  //                     height: 200,
  //                     width: 200,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(25.0),
  //                       border: Border.all(
  //                         color: Colors.white,
  //                         width: 2,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               },
  //               Positioned(
  //                 top: 10,
  //                 left: 185,
  //                 child: CircleAvatar(
  //                   child: Text("#${index + 1}"),
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // Widget _buildWorkshopItem(
  //     int index, DocumentSnapshot doc, int workshopCount, EdgeInsets padding,
  //     [double width = 200, bool isVertical = false]) {
  //   return Padding(
  //     padding: padding,
  //     child: WorkshopItem(
  //       width: width,
  //       doc: doc,
  //       isUserAlreadySignedUp: !isVertical,
  //       emitWorkshopClick: () => setState(() =>
  //           _userWorkshopsStream = WorkshopsService().getUsersWorkshop(_user)),
  //     ),
  //   );
  // }
}
