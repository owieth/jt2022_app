import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final String userId;
  UserService({required this.userId});

  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');
}
