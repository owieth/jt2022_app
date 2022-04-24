import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/constants/colors.dart';
import 'package:jt2022_app/models/user.dart';
import 'package:jt2022_app/services/auth/authentication_service.dart';
import 'package:jt2022_app/services/users/users_service.dart';
import 'package:jt2022_app/util/snackbar.dart';
import 'package:jt2022_app/widgets/shared/avatar_widget.dart';
import 'package:jt2022_app/widgets/profile/profile_edit_button.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  CustomUser? _user;
  String userId = '';

  final List<Map> _settings = [
    {'text': 'Ausloggen', 'icon': Icons.logout},
    {'text': 'Email ändern', 'icon': Icons.change_circle_outlined},
    {'text': 'Passwort ändern', 'icon': Icons.change_circle_outlined},
    {'text': 'Account löschen', 'icon': LineIcons.trash},
  ];

  _getCurrentUser() async {
    userId = Provider.of<User?>(context, listen: false)!.uid;
    CustomUser _user = await UserService().getCurrentUser();
    setState(() => this._user = _user);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  //   Positioned(
  //   top: 35,
  //   right: 35,
  //   child: NavigationButton(
  //     icon: Icons.logout,
  //     onPressedButton: () {
  //       context.read<AuthenticationService>().signOut();
  //       Navigator.pushReplacementNamed(context, '/login');
  //     },
  //   ),
  // ),

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 100, 35, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(
                children: [
                  Avatar(
                    radius: _user?.photoUrl != '' ? 50 : 48,
                    image: _user?.photoUrl,
                  ),
                  ProfileEditButton(
                    icon: LineIcons.pen,
                    callback: () =>
                        Navigator.pushNamed(context, '/profile/edit')
                            .then((_) => _getCurrentUser()),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _user?.displayName ?? '',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Row(
                    children: [
                      Text(
                        _user?.region ?? '',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        _user?.muncipality ?? '',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 45),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (_, __) => Container(
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.pending_actions,
                  color: Colors.white,
                ),
              ),
              separatorBuilder: (_, __) => const SizedBox(width: 20),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.separated(
              itemBuilder: (_, index) => Container(
                child: _buildSettingsCard(index),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemCount: 4,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSettingsCard(int index) {
    VoidCallback onTap = () {};
    switch (index) {
      case 0:
        onTap = () {
          context.read<AuthenticationService>().signOut();
          Navigator.pushReplacementNamed(context, '/login');
          GlobalSnackBar.show(
              context, '👋 Tschüss!', CustomColors.infoSnackBarColor);
        };
        break;
      case 1:
        onTap = () {
          Navigator.pushNamed(context, '/profile/changeEmail');
        };
        break;
      case 2:
        onTap = () {
          Navigator.pushNamed(context, '/profile/changePw');
        };
        break;
      case 3:
        onTap = () {
          print('delete account');
        };
        break;
    }

    return ListTile(
      onTap: onTap,
      leading: Icon(_settings[index]['icon']),
      title: Text(
        _settings[index]['text'],
        style: index == _settings.length - 1
            ? const TextStyle(color: CustomColors.errorSnackBarColor)
            : const TextStyle(),
      ),
      trailing: const RotatedBox(
        quarterTurns: 2,
        child: Icon(
          Icons.arrow_back_ios_new,
          size: 15,
        ),
      ),
      iconColor: index == _settings.length - 1
          ? CustomColors.errorSnackBarColor
          : Colors.white,
    );
  }
}
