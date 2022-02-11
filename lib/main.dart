import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jt2022_app/screens/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const JT2022App()));
}

class JT2022App extends StatelessWidget {
  const JT2022App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.black,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent),
      home: const App(),
    );
  }
}
