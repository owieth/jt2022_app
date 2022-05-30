import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jt2022_app/models/user.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/services/users/users_service.dart';
import 'package:jt2022_app/util/dates.dart';
import 'package:collection/collection.dart';

/*
  Workshop Placeholder
  1. YaxflPKreihbjTjA273N
  2. l40wEgRQDUwRs0NoJ021
  3. xACJjltu3dwRYzKxXGca
  4. 7YJwDyXwnJgjE1eMbeOK
*/
const List<String> placeholders = [
  'YaxflPKreihbjTjA273N',
  'l40wEgRQDUwRs0NoJ021',
  'xACJjltu3dwRYzKxXGca',
  '7YJwDyXwnJgjE1eMbeOK'
];

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
    List<CustomUser> users = await UserService().getAllUsers();
    List<Workshop> userWorkshops = await getUserWorkshops(userId);
    CustomUser user = await UserService().getCurrentUser();

    List<Workshop> sortedWorkshops =
        userWorkshops.where((workshop) => workshop.date == day).toList();

    final workshopsWithStateWait = sortedWorkshops.where((workshop) =>
        user.workshops.firstWhere((v) => v.id == workshop.id).state ==
        AttendanceState.wait);

    final workshopsWithStateRefused = sortedWorkshops
        .where((workshop) =>
            user.workshops.firstWhere((v) => v.id == workshop.id).state ==
            AttendanceState.refused)
        .toList();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      final eventObject = doc.data() as Map;
      final workshop = await _returnEvent(
          doc.id, eventObject, users.map((user) => user.id).toList());
      if (workshopsWithStateWait.isEmpty && workshop.date == day) {
        if (!placeholders.contains(workshop.id)) _events.add(workshop);
      } else if (workshop.date == day) {
        _events.add(workshop);
      }
    }

    if (workshopsWithStateWait.isNotEmpty) sortedWorkshops = [];

    List<Workshop> events = [..._events, ...sortedWorkshops];
    events.sort((a, b) => a.startTime.compareTo(b.startTime));

    for (Workshop workshop in workshopsWithStateRefused) {
      events.removeAt(events.indexOf(workshop));
    }
    return events;
  }

  Future<List<Workshop>> getEventsAndWorkshops() async {
    List<Workshop> _events = [];
    QuerySnapshot snapshot = await eventsCollection.get();
    List<CustomUser> users = await UserService().getAllUsers();
    List<Workshop> userWorkshops = await workshops;

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      final eventObject = doc.data() as Map;
      final workshop = await _returnEvent(
          doc.id, eventObject, users.map((user) => user.id).toList());
      if (![...placeholders, 'sMsdg17BvwPM8muCbzmf'].contains(workshop.id)) {
        _events.add(workshop);
      }
    }

    return [..._events, ...userWorkshops];
  }

  Future<List<Workshop>> getUserWorkshops(String userId) async {
    final user = await usersCollection.doc(userId).get();
    return _mapToUsersWorkshopList(user);
  }

  void dropOutOfWorkshop(String userId, String _workshopId) async {
    await usersCollection.doc(userId).update({
      "workshops": FieldValue.arrayRemove([
        {'id': _workshopId, 'state': AttendanceState.wait.index}
      ])
    });

    await workshopsCollection.doc(_workshopId).update({
      "attendees": FieldValue.arrayRemove([userId])
    });
  }

  void signUpForWorkshop(String userId, String _workshopId) async {
    await usersCollection.doc(userId).update({
      "workshops": FieldValue.arrayUnion([
        {'id': _workshopId, 'state': AttendanceState.wait.index}
      ])
    });

    await workshopsCollection.doc(_workshopId).update({
      "attendees": FieldValue.arrayUnion([userId])
    });
  }

  void changePriorityOfUserWorkshops(
      String userId, List<Workshop> workshops, List<int> workshopState) async {
    await usersCollection.doc(userId).update({
      "workshops": workshops
          .mapIndexed((index, workshop) =>
              {'id': workshop.id, 'state': workshopState[index]})
          .toList()
    });
  }

  Future<List<Workshop>> _mapToUsersWorkshopList(
      DocumentSnapshot snapshot) async {
    List<WorkshopAttendee> _workshops = [];

    if (snapshot.data() != null) {
      final workshops = (snapshot.data() as Map)['workshops'] as List;
      const DeepCollectionEquality().equals(workshops, [])
          ? []
          : _workshops = workshops
              .map((workshop) => WorkshopAttendee(
                  id: workshop['id'], state: AttendanceState.wait))
              .toList();
    }

    List<Workshop> workshopDtos = [];

    for (WorkshopAttendee workshopAttendance in _workshops) {
      final workshop = workshopsCollection
          .where(FieldPath.documentId, isEqualTo: workshopAttendance.id)
          .snapshots()
          .first;

      Future<Workshop> _workshop =
          _mapToWorkshop(await workshop, workshopAttendance.id);
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
    return Workshop(
        id: documentId,
        name: workshop['name'] ?? "",
        attendees: workshop["attendees"].cast<String>(),
        date: Dates().formatDateToDay(
            DateTime.fromMicrosecondsSinceEpoch(workshop['date'] * 1000)),
        startTime: Dates().formatDateToHM(
            DateTime.fromMicrosecondsSinceEpoch(workshop['startTime'] * 1000)),
        endTime: Dates().formatDateToHM(
            DateTime.fromMicrosecondsSinceEpoch(workshop['endTime'] * 1000)),
        image: workshop['image'],
        description: workshop['description'] ?? "",
        house: workshop['house']);
  }

  Future<Workshop> _returnEvent(String documentId,
      Map<dynamic, dynamic> workshop, List<String> attendees) async {
    return Workshop(
      id: documentId,
      name: workshop['name'] ?? "",
      date: Dates().formatDateToDay(
          DateTime.fromMicrosecondsSinceEpoch(workshop['date'] * 1000)),
      startTime: Dates().formatDateToHM(
          DateTime.fromMicrosecondsSinceEpoch(workshop['startTime'] * 1000)),
      endTime: Dates().formatDateToHM(
          DateTime.fromMicrosecondsSinceEpoch(workshop['endTime'] * 1000)),
      house: workshop['house'],
      attendees: attendees,
      image: workshop['image'],
      // These Properties are not needed for an event
      description: '',
    );
  }
}
