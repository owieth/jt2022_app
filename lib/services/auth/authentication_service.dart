import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/constants/colors.dart';
import 'package:jt2022_app/services/users/users_service.dart';
import 'package:jt2022_app/util/snackbar.dart';

enum AuthStatus {
  signedIn,
  unauthorized,
  error,
}

class AuthenticationState {
  final AuthStatus authStatus;
  final String authError;

  AuthenticationState(this.authStatus, this.authError);
}

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<AuthenticationState> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return AuthenticationState(AuthStatus.signedIn, '');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return AuthenticationState(AuthStatus.error, 'Account nicht gefunden!');
      } else if (e.code == 'wrong-password') {
        return AuthenticationState(AuthStatus.error, 'Falsches Passwort!');
      }

      return AuthenticationState(AuthStatus.error, e.code);
    }
  }

  Future<AuthenticationState> signUp(
      String email, String password, String name) async {
    try {
      UserCredential newUser = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await UserService().createUser(newUser.user!.uid, email, name);
      return AuthenticationState(AuthStatus.signedIn, '');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return AuthenticationState(AuthStatus.error, 'Email bereits vergeben!');
      }

      return AuthenticationState(AuthStatus.error, e.code);
    }
  }

  Future<void> changeEmail(BuildContext context, String credential) async {
    try {
      await _firebaseAuth.currentUser!.updateEmail(credential);
      await UserService()
          .updateEmail(credential, FirebaseAuth.instance.currentUser!.uid);
      GlobalSnackBar.show(context, 'Deine Email wurde ge??ndert!',
          CustomColors.successSnackBarColor);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        GlobalSnackBar.show(
            context,
            'Du musst dich neu einloggen um ??nderungen an deinem Profil machen zu k??nnen!',
            CustomColors.errorSnackBarColor);
        AuthenticationService(FirebaseAuth.instance).signOut();
      } else if (e.code == 'invalid-email') {
        GlobalSnackBar.show(context, 'Diese Email ist nicht g??ltig!',
            CustomColors.errorSnackBarColor);
      } else if (e.code == 'email-already-in-use') {
        GlobalSnackBar.show(
            context,
            'Diese Email wird bereits von einem anderen User benutzt!',
            CustomColors.errorSnackBarColor);
      }
    }
  }

  Future<void> changePassword(BuildContext context, String credential) async {
    try {
      await _firebaseAuth.currentUser!.updatePassword(credential);
      GlobalSnackBar.show(context, 'Dein Passwort wurde ge??ndert!',
          CustomColors.successSnackBarColor);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        GlobalSnackBar.show(
            context,
            'Du musst dich neu einloggen um ??nderungen an deinem Profil machen zu k??nnen!',
            CustomColors.errorSnackBarColor);
        AuthenticationService(FirebaseAuth.instance).signOut();
      }

      if (e.code == 'weak-password') {
        GlobalSnackBar.show(context, 'Das eingegebene Passwort ist zu schwach!',
            CustomColors.errorSnackBarColor);
      }
    }
  }
}
