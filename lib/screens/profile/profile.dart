import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:jt2022_app/constants/colors.dart';
import 'package:jt2022_app/models/user.dart';
import 'package:jt2022_app/services/auth/authentication_service.dart';
import 'package:jt2022_app/services/users/users_service.dart';
import 'package:jt2022_app/services/workshops/workshops_service.dart';
import 'package:jt2022_app/util/snackbar.dart';
import 'package:jt2022_app/widgets/profile/profile_edit_button.dart';
import 'package:jt2022_app/widgets/shared/avatar_widget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  CustomUser? _user;

  final List<Map> _settings = [
    {'text': 'Einführung starten', 'icon': LineIcons.lightbulb},
    {'text': 'Ausloggen', 'icon': Icons.logout},
    {'text': 'Email ändern', 'icon': Icons.change_circle_outlined},
    {'text': 'Passwort ändern', 'icon': Icons.change_circle_outlined},
    {'text': 'Account löschen', 'icon': LineIcons.trash},
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  Avatar(
                    radius: 50,
                    image: _user?.photoUrl != '' ? _user?.photoUrl : null,
                  ),
                  ProfileEditButton(
                    icon: LineIcons.pen,
                    callback: () => Navigator.pushNamed(
                      context,
                      '/profile/edit',
                      arguments: {
                        "user": _user,
                      },
                    ).then((_) => _getCurrentUser()),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: SingleChildScrollView(
                      child: Text(
                        _user?.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: SingleChildScrollView(
                      child: Text(
                        _user?.region ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: SingleChildScrollView(
                      child: Text(
                        _user?.muncipality ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: ListView.separated(
              itemCount: 5,
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
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSettingsCard(int index) {
    VoidCallback onTap = () {};
    switch (index) {
      case 0:
        onTap = () {
          Navigator.pushReplacementNamed(context, '/onboarding');
        };
        break;
      case 1:
        onTap = () {
          context.read<AuthenticationService>().signOut();
          Navigator.pushReplacementNamed(context, '/login');
          GlobalSnackBar.show(
              context, '👋 Tschüss!', CustomColors.infoSnackBarColor);
        };
        break;
      case 2:
        onTap = () {
          Navigator.pushNamed(context, '/profile/changeEmail');
        };
        break;
      case 3:
        onTap = () {
          Navigator.pushNamed(context, '/profile/changePw');
        };
        break;
      case 4:
        onTap = () async {
          final result = await showOkCancelAlertDialog(
              context: context,
              style: AdaptiveStyle.iOS,
              title: 'Account löschen?',
              cancelLabel: 'Abbrechen',
              message: 'Möchtest du wirklich deinen Account löschen?',
              isDestructiveAction: true,
              defaultType: OkCancelAlertDefaultType.cancel);
          if (result == OkCancelResult.ok) {
            SVProgressHUD.show();
            for (WorkshopAttendee workshop in _user!.workshops) {
              context
                  .read<WorkshopsService>()
                  .dropOutOfWorkshop(_user!.id, workshop.id);
            }

            await context.read<UserService>().deleteUser(context, _user!.id);
            SVProgressHUD.dismiss();

            Navigator.pushReplacementNamed(context, '/login');
          }
        };
        break;
    }

    return ListTile(
      onTap: () => onTap(),
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

  _getCurrentUser() async {
    CustomUser user = await UserService().getCurrentUser();
    setState(() => _user = user);
  }
}
