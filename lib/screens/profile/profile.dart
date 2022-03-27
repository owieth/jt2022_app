import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/services/auth/authentication_service.dart';
import 'package:jt2022_app/widgets/avatar_widget.dart';
import 'package:jt2022_app/widgets/navigation_button_widget.dart';
import 'package:jt2022_app/widgets/profile/profile_edit_button.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);

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
                      const Avatar(radius: 50),
                      ProfileEditButton(
                        icon: LineIcons.pen,
                        callback: () =>
                            Navigator.pushNamed(context, '/profile/edit'),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _user!.displayName as String,
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
