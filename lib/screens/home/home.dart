import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/screens/workshop/workshops.dart';
import 'package:jt2022_app/widgets/avatar_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
    final _user = Provider.of<User?>(context, listen: false);

    _userWorkshopsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .get()
        .asStream();

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
                      _user!.displayName as String,
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
            'My Workshops',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        const SizedBox(height: 20.0),
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

  StreamBuilder _buildUsersWorkshopsStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      stream: _workshopsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> workshops) {
        return StreamBuilder<DocumentSnapshot>(
          stream: _userWorkshopsStream,
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> usersWorkshops) {
            if (!usersWorkshops.hasData) {
              return Lottie.asset('assets/lottie/loading.json');
            }

            List _usersWorkshops = usersWorkshops.data!.get('workshops');

            final _workshops = workshops.data!.docs
                .where((element) => _usersWorkshops.contains(element.id));

            final _workshopCount = _usersWorkshops.length;

            if (_usersWorkshops.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _workshopCount,
                itemBuilder: (BuildContext context, int index) {
                  return _buildWorkshopItem(
                    index,
                    _workshops.elementAt(index),
                    _workshopCount,
                    MediaQuery.of(context).size.width,
                  );
                },
              );
            }

            return const Text('Workshops konnten nicht geladen werden!');
          },
        );
      },
    );
  }

  StreamBuilder _buildWorkshopsStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      stream: _workshopsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Lottie.asset('assets/lottie/loading.json');
        }

        List<QueryDocumentSnapshot> _workshops = snapshot.data!.docs;
        final _workshopCount = _workshops.length;

        if (_workshops.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            scrollDirection: Axis.vertical,
            itemCount: _workshopCount,
            itemBuilder: (BuildContext context, int index) {
              return _buildWorkshopItem(index, snapshot.data!.docs[index],
                  _workshopCount, MediaQuery.of(context).size.width, true);
            },
          );
        }

        return const Text('Workshops konnten nicht geladen werden!');
      },
    );
  }

  Widget _buildWorkshopItem(
      int index, DocumentSnapshot doc, int workshopCount, double width,
      [bool isVertical = false]) {
    EdgeInsets _padding;

    if (isVertical) {
      _padding = const EdgeInsets.only(left: 35, right: 35, bottom: 35);
    } else {
      width = 200;
      _padding = index != workshopCount - 1
          ? const EdgeInsets.only(left: 35)
          : const EdgeInsets.symmetric(horizontal: 35);
    }

    return Padding(
      padding: _padding,
      child: Workshops(width: width, doc: doc),
    );
  }
}
