import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/util/dates.dart';

class WorkshopsService {
  final CollectionReference workshopsCollection =
      FirebaseFirestore.instance.collection('workshops');

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  Future<List<Workshop>> get workshops async {
    return await _mapToWorkshopList();
  }

  Future<List<Workshop>> getUserWorkshops(String userId) async {
    final workshops = await usersCollection.doc(userId).get();
    return _mapToUsersWorkshopList(workshops);
  }

  // Stream<List<Workshop>> getUserWorkshopsByDay(DateTime day, String userId) {
  //   Stream<List<Workshop>> _workshops = workshopsCollection
  //       .where('date', isEqualTo: day)
  //       .where('attendees', arrayContains: userId)
  //       .orderBy('startTime')
  //       .get()
  //       .asStream()
  //       .map(_mapToWorkshopList);

  //   Stream<List<Workshop>> _events = eventsCollection
  //       .where('date', isEqualTo: day)
  //       .get()
  //       .asStream()
  //       .map(_mapToWorkshopList);

  //   return Rx.merge([_workshops, _events]);
  // }

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

      Future<Workshop> _workshop = _mapToWorkshop(await workshop, workshopId);
      workshopDtos.add(await _workshop);
    }

    return workshopDtos;
  }

  Future<List<Workshop>> _mapToWorkshopList() async {
    List<Workshop> workshops = [];
    QuerySnapshot snapshot = await workshopsCollection.get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      final workshop = doc.data() as Map;
      workshops.add(await _returnWorkshop(doc.id, workshop));
    }

    return workshops;
  }

  Future<Workshop> _mapToWorkshop(
      QuerySnapshot snapshot, String documentId) async {
    final workshop = snapshot.docs[0].data() as Map;
    return _returnWorkshop(documentId, workshop);
  }

  Future<Workshop> _returnWorkshop(
      String documentId, Map<dynamic, dynamic> workshop) async {
    String image = await _getWorkshopImage(documentId);
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
      image: image,
      startTime: workshop['startTime'] == null
          ? ""
          : Dates().formatDate(workshop['startTime']?.toDate()),
      description: workshop['description'] ?? "",
    );
  }

  Future<String> _getWorkshopImage(String workshopId) async {
    String image = await FirebaseStorage.instance
        .ref('workshops/$workshopId')
        .getDownloadURL();

    return image;
  }
}
