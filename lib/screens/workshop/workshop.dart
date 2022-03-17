import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/widgets/navigation_button_widget.dart';

class Workshop extends StatelessWidget {
  const Workshop({Key? key}) : super(key: key);

  void _signUpForWorkshop(BuildContext context, String workshopId) async {
    final _user = FirebaseAuth.instance.currentUser;

    final _collectionRef = FirebaseFirestore.instance.collection('users');

    if (await checkIfStoreExists(_collectionRef)) {
      _collectionRef.doc(_user!.uid).update({
        "workshops": FieldValue.arrayUnion([workshopId])
      });
    } else {
      _collectionRef.doc(_user!.uid).set({
        "workshops": FieldValue.arrayUnion([workshopId])
      });
    }

    // FirebaseFirestore.instance.collection('workshops').doc().set({
    //   "workshops": FieldValue.arrayUnion([workshopId])
    // });
  }

  Future<bool> checkIfStoreExists(CollectionReference collection) async {
    final documents = await collection.get();
    return documents.size > 0;
  }

  @override
  Widget build(BuildContext context) {
    Map _arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/${_arguments['image']}.jpeg"),
            fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 100,
            left: 35,
            child: NavigationButton(),
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () =>
                        _signUpForWorkshop(context, _arguments['id']),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                    child: Text("Anmelden",
                        style: Theme.of(context).textTheme.subtitle2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
