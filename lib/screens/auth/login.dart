import 'package:animated_login/animated_login.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/services/auth/authentication_service.dart';
import 'package:provider/provider.dart';

enum ButtonEvent { login, signUp, forgotPassword }

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  AuthMode currentMode = AuthMode.login;

  Future<String> _onButtonClick(
      BuildContext context, dynamic data, ButtonEvent event) async {
    switch (event) {
      case ButtonEvent.login:
        await context
            .read<AuthenticationService>()
            .signIn(data.email, data.password);
        break;

      case ButtonEvent.signUp:
        await context
            .read<AuthenticationService>()
            .signUp(data.email, data.password, data.name);
        break;

      case ButtonEvent.forgotPassword:
        break;
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedLogin(
          onLogin: (LoginData data) async =>
              _onButtonClick(context, data, ButtonEvent.login),
          onSignup: (SignUpData data) async =>
              _onButtonClick(context, data, ButtonEvent.signUp),
          onForgotPassword: (String data) async =>
              _onButtonClick(context, data, ButtonEvent.forgotPassword),
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
    );
  }
}
