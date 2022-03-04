import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jt2022_app/screens/auth/login.dart';
import 'package:jt2022_app/screens/onboard/onboard.dart';
import 'package:jt2022_app/screens/profile/profile.dart';
import 'package:jt2022_app/screens/workshop/workshop.dart';
import 'package:jt2022_app/widgets/container_widget.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  GestureBinding.instance?.resamplingEnabled = true;

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // final _authenticationService = AuthenticationService(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: const [
        // Provider<AuthenticationService>(
        //   create: (_) => _authenticationService,
        // ),
        // ChangeNotifierProvider<LoginModel>(
        //     create: (_) =>
        //         LoginModel(authenticationService: _authenticationService)),
        // StreamProvider(
        //   create: (context) =>
        //       context.read<AuthenticationService>().authStateChanges,
        //   initialData: null,
        // )
      ],
      child: MaterialApp(
        theme: ThemeData(
            //scaffoldBackgroundColor: Colors.black,
            primaryColor: Colors.black,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            fontFamily: 'Lufga',
            textTheme: const TextTheme(
              headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              subtitle1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              bodyText1: TextStyle(fontSize: 12.0),
            )),
        routes: {
          "": (_) => const ContainerWidget(),
          "/login": (_) => Login(),
          "/profile": (_) => const Profile(),
          "/workshop": (_) => const Workshop()
        },
        home: const AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final firebaseUser = context.watch<User>();

    // if (firebaseUser != null) {
    //   return const App();
    // }

    return const Onboard();
  }
}
