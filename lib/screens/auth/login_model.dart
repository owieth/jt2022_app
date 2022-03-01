import 'package:flutter/material.dart';
import 'package:jt2022_app/services/auth/authentication_service.dart';

class LoginModel extends ChangeNotifier {
  final AuthenticationService _authenticationService;

  LoginModel({required AuthenticationService authenticationService})
      : _authenticationService = authenticationService;

  String _email = "";
  String _password = "";
  // AuthState _state;

  // AuthState get state {
  //   return _state;
  // }

  set email(String email) {
    this._email = email;
  }

  set password(String password) {
    this._password = password;
  }

  // void resetState() {
  //   _state = AuthState(AuthStatus.unuathed, null);
  // }

  // void loginUser() async {
  //   this._state = await _authenticationService.logIn(email: _email, password: _password);

  //   if (this._state.authStatus == AuthStatus.authed) {
  //     _email = "";
  //     _password = "";
  //   }

  //   notifyListeners();
  // }
}
