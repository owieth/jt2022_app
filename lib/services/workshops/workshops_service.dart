import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkshopsService {
  Stream<QuerySnapshot> getAllWorkshops() =>
      FirebaseFirestore.instance.collection('workshops').snapshots();

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUsersWorkshop(User _user) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .get()
          .asStream();
}
