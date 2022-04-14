import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUser(
      Map<String, dynamic> userData, User user, File? image) async {
    if (image != null) {
      TaskSnapshot uploadTask = await FirebaseStorage.instance
          .ref('users/${user.uid}')
          .putFile(image);
      String profileImageUrl = await uploadTask.ref.getDownloadURL();
      await user.updatePhotoURL(profileImageUrl);
    }

    await user.updateDisplayName(userData['displayName']);
    await user.updateEmail(userData['email']);

    await usersCollection.doc(user.uid).update({
      "region": userData['region'],
      "muncipality": userData['muncipality'],
    });
  }
}
