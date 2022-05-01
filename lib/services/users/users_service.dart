import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/models/user.dart';

class UserService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future createUser(String userId) async {
    await usersCollection.doc(userId).set({
      'muncipality': '',
      'region': '',
      'workshops': [],
      'isVolunteer': false
    });
  }

  Future<CustomUser> getCurrentUser() async {
    final User _user = FirebaseAuth.instance.currentUser!;
    final _userAttributes = await usersCollection.doc(_user.uid).get();
    return CustomUser(
      id: _user.uid,
      email: _user.email!,
      displayName: _user.displayName!,
      photoUrl: _user.photoURL,
      muncipality: _userAttributes['muncipality'],
      region: _userAttributes['region'],
      isVolunteer: _userAttributes['isVolunteer'],
    );
  }

  Future<void> updateUser(BuildContext context, Map<String, dynamic> userData,
      User user, File? image) async {
    await user.updateDisplayName(userData['displayName']);

    if (image != null) {
      TaskSnapshot uploadTask = await FirebaseStorage.instance
          .ref('users/${user.uid}')
          .putFile(image);
      String profileImageUrl = await uploadTask.ref.getDownloadURL();
      await user.updatePhotoURL(profileImageUrl);
    }

    await usersCollection.doc(user.uid).update({
      "muncipality": userData['muncipality'],
      "region": userData['region'],
      "isVolunteer": userData['isVolunteer'],
    });

    Navigator.pop(context);
  }
}
