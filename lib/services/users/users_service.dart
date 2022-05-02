import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/constants/colors.dart';
import 'package:jt2022_app/models/user.dart';
import 'package:jt2022_app/services/auth/authentication_service.dart';
import 'package:jt2022_app/util/snackbar.dart';

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
      muncipality: _userAttributes['muncipality'] ?? '',
      region: _userAttributes['region'] ?? '',
      isVolunteer: _userAttributes['isVolunteer'] ?? '',
      workshops: _userAttributes['workshops'].cast<String>() ?? [],
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

  Future<void> deleteUser(BuildContext context, String userId) async {
    try {
      await FirebaseStorage.instance.ref('users/$userId').delete();
    } catch (_) {}

    await usersCollection.doc(userId).delete();

    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        GlobalSnackBar.show(
            context,
            'Du musst dich neu einloggen um Änderungen an deinem Profil machen zu können!',
            CustomColors.errorSnackBarColor);
        AuthenticationService(FirebaseAuth.instance).signOut();
      }
    }
  }
}
