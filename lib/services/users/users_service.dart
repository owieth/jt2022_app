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

  Future<CustomUser> getCurrentUser() async {
    final User _user = FirebaseAuth.instance.currentUser!;
    final _userAttributes = await usersCollection.doc(_user.uid).get();
    return CustomUser(
      id: _user.uid,
      email: _user.email!,
      displayName: _user.displayName!,
      photoUrl: _user.photoURL!,
      muncipality: _userAttributes['muncipality'],
      region: _userAttributes['region'],
    );
  }

  Future<void> updateUser(BuildContext context, Map<String, dynamic> userData,
      User user, File? image) async {
    try {
      await user.updateEmail(userData['email']);
    } on FirebaseAuthException {
      GlobalSnackBar.show(
          context,
          'Du musst dich neu einloggen um Änderungen an deinem Profil machen zu können!',
          CustomColors.errorSnackBarColor);
      AuthenticationService(FirebaseAuth.instance).signOut();
      return;
    }

    await user.updateDisplayName(userData['displayName']);

    if (image != null) {
      TaskSnapshot uploadTask = await FirebaseStorage.instance
          .ref('users/${user.uid}')
          .putFile(image);
      String profileImageUrl = await uploadTask.ref.getDownloadURL();
      await user.updatePhotoURL(profileImageUrl);
    }

    await usersCollection.doc(user.uid).update({
      "region": userData['region'],
      "muncipality": userData['muncipality'],
    });

    Navigator.pop(context);
  }
}
