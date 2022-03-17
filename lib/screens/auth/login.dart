import 'package:animated_login/animated_login.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/services/auth/authentication_service.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthMode currentMode = AuthMode.login;

  String _onButtonClick(dynamic data) {
    if (currentMode == AuthMode.login) {
      context.read<AuthenticationService>().signIn(data.email, data.password);
    } else {
      context
          .read<AuthenticationService>()
          .signUp(data.email, data.password, data.name);
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: AnimatedLogin(
            onLogin: (LoginData data) async => _onButtonClick(data),
            onSignup: (SignUpData data) async => _onButtonClick(data),
            onForgotPassword: (String data) async => _onButtonClick(data),
            initialMode: currentMode,
            validatePassword: false,
            loginTexts: LoginTexts(
              welcome: "Hallo 👋",
              welcomeDescription: "Willkommen im C4MP",
              welcomeBack: "Hallo 👋",
              welcomeBackDescription: "Willkommen im C4MP",
              signUp: "Registrieren",
              forgotPassword: "Passwort vergessen?",
              notHaveAnAccount: "Noch kein Account?",
              alreadyHaveAnAccount: "Schon ein Account?",
              passwordHint: "Passwort",
              confirmPasswordHint: "Passwort bestätigen",
              login: "Anmelden",
            ),
            loginMobileTheme: LoginViewTheme(
              formPadding: const EdgeInsets.symmetric(vertical: 50),
              formElementsSpacing: 30,
              formTitleStyle: Theme.of(context).textTheme.headline1,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              formFieldBackgroundColor: Colors.white,
              animationDuration: const Duration(seconds: 1),
              animationCurve: Curves.easeInOut,
              actionButtonStyle: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.all(20),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            onAuthModeChange: (AuthMode newMode) => currentMode = newMode,
          ),
        ),
      ),
    );
  }
}
