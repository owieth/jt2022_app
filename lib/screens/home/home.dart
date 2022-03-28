import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/screens/workshop/workshops.dart';
import 'package:jt2022_app/widgets/shared/avatar_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> _workshopsStream =
      FirebaseFirestore.instance.collection('workshops').snapshots();

  late Stream<DocumentSnapshot<Map<String, dynamic>>> _userWorkshopsStream;

  @override
  void initState() {
    _userWorkshopsStream = _getUsersWorkshop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);

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
                      _user?.displayName ?? "",
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
        SizedBox(
          height: 200,
          child: _buildUsersWorkshopsStreamBuilder(),
        ),
        const SizedBox(height: 50.0),
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Text(
            'Workshops',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Expanded(
          child: _buildWorkshopsStreamBuilder(),
        ),
      ],
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _getUsersWorkshop() {
    final _user = Provider.of<User?>(context, listen: false);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .get()
        .asStream();
  }

  StreamBuilder _buildUsersWorkshopsStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      stream: _workshopsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> workshops) {
        return StreamBuilder<DocumentSnapshot>(
          stream: _userWorkshopsStream,
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> usersWorkshops) {
            if (!usersWorkshops.hasData) {
              return const SkeletonLoader(
                padding: EdgeInsets.symmetric(horizontal: 35),
              );
            }

            List _usersWorkshops;
            if (usersWorkshops.data!.exists) {
              _usersWorkshops = usersWorkshops.data?.get('workshops');
            } else {
              _usersWorkshops = List.of(const Iterable.empty());
            }

            final _workshops = workshops.data!.docs
                .where((element) => _usersWorkshops.contains(element.id));
            final _workshopCount = _usersWorkshops.length;

            return ListView.builder(
              padding: const EdgeInsets.only(top: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _workshopCount,
              itemBuilder: (BuildContext context, int index) {
                final _padding = index != _workshopCount - 1
                    ? const EdgeInsets.only(left: 35)
                    : const EdgeInsets.symmetric(horizontal: 35);

                return _buildWorkshopItem(index, _workshops.elementAt(index),
                    _workshopCount, _padding);
              },
            );
          },
        );
      },
    );
  }

  StreamBuilder _buildWorkshopsStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      stream: _workshopsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        final _width = MediaQuery.of(context).size.width;

        if (!snapshot.hasData) {
          return SkeletonLoader(
            width: _width,
            padding: const EdgeInsets.only(left: 35, right: 35, bottom: 35),
          );
        }

        List<QueryDocumentSnapshot> _workshops = snapshot.data!.docs;
        final _workshopCount = _workshops.length;

        if (_workshops.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            scrollDirection: Axis.vertical,
            itemCount: _workshopCount,
            itemBuilder: (BuildContext context, int index) {
              const _padding = EdgeInsets.only(left: 35, right: 35, bottom: 35);

              return _buildWorkshopItem(index, snapshot.data!.docs[index],
                  _workshopCount, _padding, _width, true);
            },
          );
        }

        return const Text('Workshops konnten nicht geladen werden!');
      },
    );
  }

  Widget _buildWorkshopItem(
      int index, DocumentSnapshot doc, int workshopCount, EdgeInsets padding,
      [double width = 200, bool isVertical = false]) {
    return Padding(
      padding: padding,
      child: Workshops(
        width: width,
        doc: doc,
        isUserAlreadySignedUp: !isVertical,
        emitWorkshopChange: () =>
            setState(() => _userWorkshopsStream = _getUsersWorkshop()),
      ),
    );
  }
}

class SkeletonLoader extends StatelessWidget {
  final EdgeInsets padding;
  final double width;

  const SkeletonLoader({
    Key? key,
    required this.padding,
    this.width = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20),
      scrollDirection: Axis.horizontal,
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: padding,
          child: SkeletonLine(
            style: SkeletonLineStyle(
              height: 200,
              width: width,
              borderRadius: const BorderRadius.all(Radius.circular(25)),
            ),
          ),
        );
      },
    );
  }
}
