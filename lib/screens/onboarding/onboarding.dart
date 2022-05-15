import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:jt2022_app/services/users/users_service.dart';
import 'package:provider/provider.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _titleTextStyle = Theme.of(context).textTheme;
    final _bodyTextStyle = Theme.of(context).textTheme;

    final pageDecoration = PageDecoration(
      titleTextStyle: _titleTextStyle.headline1!,
      bodyTextStyle: _bodyTextStyle.headline6!,
      bodyPadding: const EdgeInsets.all(35.0),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      globalBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      pages: [
        PageViewModel(
          title: "Auswahl Workshops",
          body:
              "Du kannst bis zu 6 Workshops auswählen. Am Jugendtag wirst du 4 besuchen können, priorisiere also richtig 😉",
          image: _buildImage('church.jpeg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Priorisierung deiner Workshops",
          body: "Stelle ein welche Workshops du umbedingt besuchen möchtest",
          image: _buildImage('church.jpeg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Behalte den Überblick über das Programm",
          body: "Hier kannst du alle Programmpunkte & deine Workshops einsehen",
          image: _buildImage('church.jpeg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Sehe den Standort deiner Aktivitäten ein",
          body: "Behalte den Überblick über die Standorte der Aktivitäten",
          image: _buildImage('church.jpeg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Gestalte dein Profil",
          body:
              "Hier kannst du dein Profil ergänzen und Einstellungen vornehmen. Du siehst hier zu welchen Workshops du definitiv ausgewählt wurdest. Du wirst benachrichtigt, wenn ein Workshop dir bestätigt wird",
          image: _buildImage('church.jpeg'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      skip: Text('Skip', style: _titleTextStyle.subtitle1),
      next: const Icon(
        Icons.arrow_forward_ios_sharp,
        color: Colors.white,
      ),
      done: Text('Fertig', style: _titleTextStyle.subtitle1),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
        activeColor: Colors.white,
      ),
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  void _onIntroEnd(context) async {
    await UserService()
        .setOnboarding(Provider.of<User?>(context, listen: false)!.uid);
    Navigator.pushReplacementNamed(context, '');
  }
}
