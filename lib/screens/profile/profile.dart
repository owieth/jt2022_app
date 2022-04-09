import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/services/auth/authentication_service.dart';
import 'package:jt2022_app/widgets/shared/avatar_widget.dart';
import 'package:jt2022_app/widgets/shared/navigation_button_widget.dart';
import 'package:jt2022_app/widgets/profile/profile_edit_button.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User _user = _getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 35,
          right: 35,
          child: NavigationButton(
            icon: Icons.logout,
            onPressedButton: () {
              context.read<AuthenticationService>().signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    children: [
                      Avatar(
                        radius: 50,
                        image: _user.photoURL ?? '',
                      ),
                      ProfileEditButton(
                        icon: LineIcons.pen,
                        callback: () =>
                            Navigator.pushNamed(context, '/profile/edit').then(
                                (_) =>
                                    setState(() => _user = _getCurrentUser())),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _user.displayName as String,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Row(
                        children: [
                          Text(
                            'Bern Süd',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            'Bümpliz',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

User _getCurrentUser() {
  return FirebaseAuth.instance.currentUser!;
}
