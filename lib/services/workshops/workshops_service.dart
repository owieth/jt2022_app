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

  Future<List<Workshop>> getUserWorkshopsByDay(
      String day, String userId) async {
    List<Workshop> _events = [];
    QuerySnapshot snapshot = await eventsCollection.get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      final eventObject = doc.data() as Map;
      final workshop = await _returnEvent(doc.id, eventObject);
      if (workshop.date == day) _events.add(workshop);
    }

    List<Workshop> tempList = await workshops;
    List<Workshop> sortedEvents = tempList
        .where((workshop) => workshop.date == day)
        .where((workshop) => workshop.attendees.contains(userId))
        .toList();

    List<Workshop> events = [..._events, ...sortedEvents];
    events.sort((a, b) => a.startTime.compareTo(b.startTime));
    return events;
  }

  Future<List<Workshop>> getUserWorkshops(String userId) async {
    final workshops = await usersCollection.doc(userId).get();
    return _mapToUsersWorkshopList(workshops);
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

  void changePriorityOfUserWorkshops(
      String userId, List<String> workshops) async {
    await usersCollection.doc(userId).update({"workshops": workshops});
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
      date: workshop['date'] == null
          ? ""
          : Dates().formatDateToDay(workshop['date']?.toDate()),
      endTime: workshop['endTime'] == null
          ? ""
          : Dates().formatDateToHM(workshop['endTime']?.toDate()),
      image: image,
      startTime: workshop['startTime'] == null
          ? ""
          : Dates().formatDateToHM(workshop['startTime']?.toDate()),
      description: workshop['description'] ?? "",
    );
  }

  Future<String> _getWorkshopImage(String workshopId) async {
    String image;
    try {
      image = await FirebaseStorage.instance
          .ref('workshops/$workshopId')
          .getDownloadURL();
    } on FirebaseException catch (_) {
      image = await FirebaseStorage.instance
          .ref('workshops/placeholder')
          .getDownloadURL();
    }

    return image;
  }

  Future<Workshop> _returnEvent(
      String documentId, Map<dynamic, dynamic> workshop) async {
    return Workshop(
      id: documentId,
      name: workshop['name'] ?? "",
      attendees: [],
      date: workshop['date'] == null
          ? ""
          : Dates().formatDateToDay(workshop['date']?.toDate()),
      endTime: Dates().formatDateToHM(workshop['endTime']?.toDate()),
      image: '',
      startTime: Dates().formatDateToHM(workshop['startTime']?.toDate()),
      description: '',
    );
  }
}
