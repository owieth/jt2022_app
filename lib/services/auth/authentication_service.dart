import 'package:firebase_auth/firebase_auth.dart';

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

  Future<AuthenticationState> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return AuthenticationState(AuthStatus.signedIn, '');
    } on FirebaseAuthException catch (e) {
      return AuthenticationState(AuthStatus.error, e.message!);
    }
  }

  Future<AuthenticationState> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return AuthenticationState(AuthStatus.signedIn, '');
    } on FirebaseAuthException catch (e) {
      return AuthenticationState(AuthStatus.error, e.message!);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    //Navigator.of(context).pushAndRemoveUntil(, (route) => false)
  }
}
