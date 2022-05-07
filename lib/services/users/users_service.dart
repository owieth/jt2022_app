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

  Future createUser(String userId, String email, String name) async {
    await usersCollection.doc(userId).set({
      'id': userId,
      'email': email,
      'name': name,
      'photoUrl': '',
      'muncipality': '',
      'region': '',
      'isVolunteer': false,
      'isOnboarded': false,
      'workshops': [],
    });
  }

  Future<CustomUser> getCurrentUser() async {
    final User? _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      final _userAttributes = await usersCollection.doc(_user.uid).get();

      return CustomUser(
        id: _userAttributes['id'],
        email: _userAttributes['email'],
        name: _userAttributes['name'],
        photoUrl: _userAttributes['photoUrl'],
        muncipality: _userAttributes['muncipality'],
        region: _userAttributes['region'],
        isVolunteer: _userAttributes['isVolunteer'],
        isOnboarded: _userAttributes['isOnboarded'],
        workshops: _userAttributes['workshops'].cast<String>(),
      );
    }

    return CustomUser(
      id: '',
      email: '',
      name: '',
      photoUrl: '',
      region: '',
      muncipality: '',
      isVolunteer: false,
      isOnboarded: false,
      workshops: [],
    );
  }

  Future<void> updateUser(BuildContext context, Map<String, dynamic> userData,
      String userId, File? image) async {
    String photoUrl = '';

    if (image != null) {
      TaskSnapshot uploadTask =
          await FirebaseStorage.instance.ref('users/$userId').putFile(image);
      photoUrl = await uploadTask.ref.getDownloadURL();
    }

    await usersCollection.doc(userId).update({
      'name': userData['name'],
      'photoUrl': photoUrl,
      "muncipality": userData['muncipality'],
      "region": userData['region'],
      "isVolunteer": userData['isVolunteer'],
    });

    Navigator.pop(context);
  }

  Future<void> deleteUser(BuildContext context, String userId) async {
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

    try {
      await FirebaseStorage.instance.ref('users/$userId').delete();
    } catch (_) {}

    await usersCollection.doc(userId).delete();
  }

  Future<List<CustomUser>> getAllUsers() async {
    List<CustomUser> users = [];
    QuerySnapshot snapshot = await usersCollection.get();
    for (QueryDocumentSnapshot _userAttributes in snapshot.docs) {
      {
        CustomUser _user = CustomUser(
          id: _userAttributes['id'],
          email: _userAttributes['email'],
          name: _userAttributes['name'],
          photoUrl: _userAttributes['photoUrl'],
          muncipality: _userAttributes['muncipality'],
          region: _userAttributes['region'],
          isVolunteer: _userAttributes['isVolunteer'],
          isOnboarded: _userAttributes['isOnboarded'],
          workshops: _userAttributes['workshops'].cast<String>(),
        );
        users.add(_user);
      }
    }

    return users;
  }

  Future setOnboarding(String userId) async {
    await usersCollection.doc(userId).update({
      "isOnboarded": true,
    });
  }
}
