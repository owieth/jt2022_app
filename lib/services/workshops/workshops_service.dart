import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/util/dates.dart';
import 'package:rxdart/rxdart.dart';

class WorkshopsService {
  final CollectionReference workshopsCollection =
      FirebaseFirestore.instance.collection('workshops');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  Stream<List<Workshop>> get workshops {
    return workshopsCollection.snapshots().map(_mapToWorkshopList);
  }

  Future<List<Workshop>> getUserWorkshops(String userId) async {
    final workshops = await usersCollection.doc(userId).get();
    return _mapToUsersWorkshopList(workshops);
  }

  Stream<List<Workshop>> getUserWorkshopsByDay(DateTime day, String userId) {
    Stream<List<Workshop>> _workshops = workshopsCollection
        .where('date', isEqualTo: day)
        .where('attendees', arrayContains: userId)
        .orderBy('startTime')
        .get()
        .asStream()
        .map(_mapToWorkshopList);

    Stream<List<Workshop>> _events = eventsCollection
        .where('date', isEqualTo: day)
        .get()
        .asStream()
        .map(_mapToWorkshopList);

    return Rx.merge([_workshops, _events]);
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

    List<Workshop> workshopDtos = [];

    for (var workshopId in _workshops) {
      final workshop = workshopsCollection
          .where(FieldPath.documentId, isEqualTo: workshopId)
          .snapshots()
          .first;

      Workshop _workshop = _mapToWorkshop(await workshop, workshopId);
      workshopDtos.add(_workshop);
    }

    return workshopDtos;
  }

  List<Workshop> _mapToWorkshopList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final workshop = doc.data() as Map;
      return _returnWorkshop(doc.id, workshop);
    }).toList();
  }

  Workshop _mapToWorkshop(QuerySnapshot snapshot, String documentId) {
    final workshop = snapshot.docs[0].data() as Map;
    return _returnWorkshop(documentId, workshop);
  }

  Workshop _returnWorkshop(String documentId, Map<dynamic, dynamic> workshop) {
    return Workshop(
      id: documentId,
      name: workshop['name'] ?? "",
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
      description: workshop['description'] ?? "",
    );
  }
}
