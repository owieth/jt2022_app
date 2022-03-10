import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/screens/workshop/workshops.dart';
import 'package:jt2022_app/widgets/avatar_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final Query<Map<String, dynamic>> _usersWorkshopsStream = FirebaseFirestore
      .instance
      .collection('users')
      .where('users', isEqualTo: '1cl8WviSqSONhAckmlMT1NWameL2');

  final Stream<QuerySnapshot> _workshopsStream =
      FirebaseFirestore.instance.collection('workshops').snapshots();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

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
                      'Hello there,',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      user?.displayName ?? 'Nina',
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
          child: _buildStreamBuilder(stream: _workshopsStream),
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
          child:
              _buildStreamBuilder(stream: _workshopsStream, isVertical: true),
        ),
      ],
    );
  }

  StreamBuilder _buildStreamBuilder(
      {required Stream<QuerySnapshot> stream, bool isVertical = false}) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Lottie.asset('assets/lottie/loading.json');
        }

        if (snapshot.hasData) {
          final _workshopCount = snapshot.data!.docs.length;

          return ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
            itemCount: _workshopCount,
            itemBuilder: (BuildContext context, int index) {
              return _buildWorkshopItem(
                index,
                snapshot.data!.docs[index],
                _workshopCount,
                isVertical,
                MediaQuery.of(context).size.width,
              );
            },
          );
        }

        return const Text('Something went wrong');
      },
    );
  }

  Widget _buildWorkshopItem(
    int index,
    DocumentSnapshot doc,
    int workshopCount,
    bool isVertical,
    double width,
  ) {
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
