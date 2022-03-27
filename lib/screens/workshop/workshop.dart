import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/widgets/action_button.dart';
import 'package:jt2022_app/widgets/navigation_button_widget.dart';
import 'package:provider/provider.dart';

class Workshop extends StatefulWidget {
  const Workshop({Key? key}) : super(key: key);

  @override
  State<Workshop> createState() => _WorkshopState();
}

class _WorkshopState extends State<Workshop> {
  late final CollectionReference<Map<String, dynamic>> _usersCollection;
  bool isUserAlreadySignedUp = false;

  @override
  Widget build(BuildContext context) {
    Map _arguments = ModalRoute.of(context)!.settings.arguments as Map;

    setState(() {
      isUserAlreadySignedUp =
          _arguments['isUserAlreadySignedUp'].toString().isNotEmpty;
    });

    final String _buttonText = isUserAlreadySignedUp ? "Abmelden" : "Anmelden";

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/${_arguments['image']}.jpeg"),
            fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 100,
            left: 35,
            child: NavigationButton(
              icon: Icons.arrow_back_ios_new,
              onPressedButton: () => Navigator.pop(context),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black.withAlpha(0),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_arguments['title'],
                    style: Theme.of(context).textTheme.headline1),
                const SizedBox(
                  height: 20.0,
                ),
                Text("Lorem isdmfölkasdjf ölkjasdföl jasdöfl jkasdöflj as",
                    style: Theme.of(context).textTheme.headline6),
                const SizedBox(
                  height: 35.0,
                ),
                ActionButton(
                  buttonText: _buttonText,
                  callback: () => _changeWorkshopAttendance(
                    context,
                    _arguments['id'],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _signUpForWorkshop(BuildContext context, User user, usersCollection,
      workshopsCollection, String _workshopId) async {
    await usersCollection.doc(user.uid).update({
      "workshops": FieldValue.arrayUnion([_workshopId])
    });

    await workshopsCollection.doc(_workshopId).update({
      "attendees": FieldValue.arrayUnion([user.uid])
    });
  }

  void _dropOutOfWorkshop(BuildContext context, User user, usersCollection,
      workshopsCollection, String _workshopId) async {
    await usersCollection.doc(user.uid).update({
      "workshops": FieldValue.arrayRemove([_workshopId])
    });

    await workshopsCollection.doc(_workshopId).update({
      "attendees": FieldValue.arrayRemove([user.uid])
    });
  }

  void _changeWorkshopAttendance(BuildContext context, String _workshopId) {
    final _user = Provider.of<User?>(context, listen: false);

    _usersCollection = FirebaseFirestore.instance.collection('users');

    final _workshopsCollection =
        FirebaseFirestore.instance.collection('workshops');

    if (isUserAlreadySignedUp) {
      _dropOutOfWorkshop(
          context, _user!, _usersCollection, _workshopsCollection, _workshopId);
    } else {
      _signUpForWorkshop(
          context, _user!, _usersCollection, _workshopsCollection, _workshopId);
    }
    Navigator.pop(context);
  }
}
