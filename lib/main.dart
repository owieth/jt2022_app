import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:jt2022_app/screens/auth/login.dart';
import 'package:jt2022_app/screens/members/members.dart';
import 'package:jt2022_app/screens/onboarding/onboarding.dart';
import 'package:jt2022_app/screens/profile/change_credentials.dart';
import 'package:jt2022_app/screens/profile/edit_profile.dart';
import 'package:jt2022_app/screens/profile/profile.dart';
import 'package:jt2022_app/screens/workshop/workshop.dart';
import 'package:jt2022_app/services/auth/authentication_service.dart';
import 'package:jt2022_app/services/users/users_service.dart';
import 'package:jt2022_app/services/workshops/workshops_service.dart';
import 'package:jt2022_app/widgets/container_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'screens/workshop/workshop_priority.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp();

  /*
    For Debugpurposes :D
  
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);
  */

  FirebaseMessaging.onMessage.listen((_) => {});

  FirebaseInAppMessaging.instance.triggerEvent('');

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(App()));
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _authenticationService = AuthenticationService(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark);
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black);

    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(create: (_) => _authenticationService),
        Provider<UserService>(create: (_) => UserService()),
        Provider<WorkshopsService>(create: (_) => WorkshopsService()),
        StreamProvider<User?>(
          create: (_) => _authenticationService.authStateChanges,
          initialData: null,
        ),
      ],
      child: Sizer(builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            primaryColor: Colors.black,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            fontFamily: 'Lufga',
            textTheme: TextTheme(
              headline1: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              headline2: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              subtitle1: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              subtitle2: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              headline6: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w100,
                color: Colors.white,
              ),
              bodyText1: TextStyle(fontSize: 10.sp, color: Colors.white),
              bodyText2: TextStyle(fontSize: 10.sp, color: Colors.black),
            ),
          ),
          routes: {
            "": (_) => const ContainerWidget(),
            "/login": (_) => const Login(),
            "/members": (_) => const Members(),
            "/profile": (_) => const Profile(),
            "/workshop": (_) => const Workshop(),
            "/workshop/priority": (_) => const WorkshopPriority(),
            "/onboarding": (_) => const Onboarding(),
            "/profile/edit": (_) => const EditProfile(),
            "/profile/changeEmail": (_) => const ChangeCredentials(
                changeUserCredentials: ChangeUserCredentials.email),
            "/profile/changePw": (_) => const ChangeCredentials(
                changeUserCredentials: ChangeUserCredentials.password),
          },
          localizationsDelegates: const [FormBuilderLocalizations.delegate],
          home: const AuthenticationWrapper(),
        );
      }),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser == null) {
      return const Login();
    }

    return const ContainerWidget();
  }
}
