import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:animated_login/animated_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/constants/colors.dart';
import 'package:jt2022_app/services/auth/authentication_service.dart';
import 'package:jt2022_app/util/snackbar.dart';
import 'package:provider/provider.dart';

enum ButtonEvent { login, signUp, forgotPassword }

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthMode currentMode = AuthMode.login;

  Future<String> _onButtonClick(
      BuildContext context, dynamic data, ButtonEvent event) async {
    switch (event) {
      case ButtonEvent.login:
        AuthenticationState onSignIn = await context
            .read<AuthenticationService>()
            .signIn(data.email, data.password);
        if (onSignIn.authStatus == AuthStatus.error) {
          GlobalSnackBar.show(
              context,
              'Fehler bei der Anmeldung: ${onSignIn.authError}',
              CustomColors.errorSnackBarColor);
        } else {
          Navigator.pushReplacementNamed(context, "");
        }
        break;

      case ButtonEvent.signUp:
        AuthenticationState onSignUp =
            await AuthenticationService(FirebaseAuth.instance)
                .signUp(data.email, data.password, data.name);
        if (onSignUp.authStatus == AuthStatus.error) {
          GlobalSnackBar.show(
              context,
              'Fehler bei der Registrierung: ${onSignUp.authError}',
              CustomColors.errorSnackBarColor);
        } else {
          Navigator.pushReplacementNamed(context, "");
        }
        break;

      case ButtonEvent.forgotPassword:
        await showOkCancelAlertDialog(
          context: context,
          title: 'Passwort vergessen?',
          message:
              'Melde dich beim Administrator (region4jugendtag2022@gmail.com) um das Passwort zurückzusetzen',
          cancelLabel: "Abbrechen",
          defaultType: OkCancelAlertDefaultType.ok,
        );
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
            passwordMatchingError: "Passwörter stimmen nicht überein!",
          ),
          loginMobileTheme: LoginViewTheme(
            formPadding: const EdgeInsets.symmetric(vertical: 50),
            formElementsSpacing: 30,
            formTitleStyle: Theme.of(context).textTheme.headline1,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            formFieldBackgroundColor: Colors.white,
            errorTextStyle: const TextStyle(color: Colors.white),
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
          onAuthModeChange: (AuthMode newMode) =>
              setState(() => currentMode = newMode),
        ),
      ),
    );
  }
}
