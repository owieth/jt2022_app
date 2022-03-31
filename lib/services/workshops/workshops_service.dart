import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jt2022_app/models/workshop.dart';

// class WorkshopsService {
//   Stream<DocumentSnapshot> getAllWorkshops() => FirebaseFirestore.instance
//       .collection('workshops')
//       .snapshots()
//       .map((docSnapshot) => Workshop.fromQuerySnapshot(docSnapshot));

//   Stream<DocumentSnapshot<Map<String, dynamic>>> getUsersWorkshopAsStream(
//           User _user) =>
//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(_user.uid)
//           .get()
//           .asStream();
// }

class WorkshopsService {
  final CollectionReference workshopsCollection =
      FirebaseFirestore.instance.collection('workshops');

  Stream<List<Workshop>> get workshops {
    return workshopsCollection.snapshots().map(_mapToWorkshopList);
  }

  List<Workshop> _mapToWorkshopList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final workshop = doc.data() as Map;
      return Workshop(
        id: doc.id,
        name: workshop['name'],
        attendees: workshop["attendees"] == null
            ? []
            : workshop["attendees"].cast<String>(),
        date: workshop['date'].toString(),
        endTime: workshop['endTime'].toString(),
        image: workshop['image'],
        starTime: workshop['starTime'].toString(),
      );
    }).toList();
  }
}
