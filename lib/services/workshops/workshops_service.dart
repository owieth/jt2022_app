import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/util/dates.dart';

class WorkshopsService {
  final CollectionReference workshopsCollection =
      FirebaseFirestore.instance.collection('workshops');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<List<Workshop>> get workshops {
    return workshopsCollection.snapshots().map(_mapToWorkshopList);
  }

  Future<List<Workshop>> getUserWorkshops(String userId) async {
    final workshops = await usersCollection.doc(userId).get();
    return _mapToUsersWorkshopList(workshops);
  }

  Stream<List<Workshop>> getUserWorkshopsByDay(DateTime day, String userId) {
    return workshopsCollection
        .where('date', isEqualTo: day)
        .where('attendees', arrayContains: userId)
        .orderBy('startTime')
        .get()
        .asStream()
        .map(_mapToWorkshopList);
  }

  void dropOutOfWorkshop(String userId, String _workshopId) async {
    await usersCollection.doc(userId).update({
      "workshops": FieldValue.arrayRemove([_workshopId])
    });

    await workshopsCollection.doc(_workshopId).update({
      "attendees": FieldValue.arrayRemove([userId])
    });
  }

  void signUpForWorkshop(String userId, String _workshopId) async {
    await usersCollection.doc(userId).update({
      "workshops": FieldValue.arrayUnion([_workshopId])
    });

    await workshopsCollection.doc(_workshopId).update({
      "attendees": FieldValue.arrayUnion([userId])
    });
  }

  Future<List<Workshop>> _mapToUsersWorkshopList(
      DocumentSnapshot snapshot) async {
    final List<String> _workshops =
        List<String>.from((snapshot.data() as Map)['workshops'] as List);

    List<Workshop> s = [];

    for (var workshopId in _workshops) {
      final workshop = workshopsCollection
          .where(FieldPath.documentId, isEqualTo: workshopId)
          .snapshots()
          .first;

      Workshop workshop2 = _mapToWorkshop(await workshop, workshopId);
      s.add(workshop2);
    }

    return s;
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
        endTime: workshop['endTime'] == null
            ? ""
            : Dates().formatDate(workshop['endTime']?.toDate()),
        image: workshop['image'] ?? 'placeholder',
        startTime: workshop['startTime'] == null
            ? ""
            : Dates().formatDate(workshop['startTime']?.toDate()),
        description: workshop['description'],
      );
    }).toList();
  }

  Workshop _mapToWorkshop(QuerySnapshot snapshot, String documentId) {
    final workshop = snapshot.docs[0].data() as Map;
    return Workshop(
      id: documentId,
      name: workshop['name'],
      attendees: workshop["attendees"] == null
          ? []
          : workshop["attendees"].cast<String>(),
      date: workshop['date'].toString(),
      endTime: workshop['endTime'].toString(),
      image: workshop['image'] ?? 'placeholder',
      startTime: workshop['starTime'].toString(),
      description: workshop['description'],
    );
  }
}
