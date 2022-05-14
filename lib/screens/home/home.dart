import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/constants/colors.dart';
import 'package:jt2022_app/constants/workshop.dart';
import 'package:jt2022_app/models/user.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/screens/workshop/user_workshops.dart';
import 'package:jt2022_app/screens/workshop/workshops.dart';
import 'package:jt2022_app/services/users/users_service.dart';
import 'package:jt2022_app/services/workshops/workshops_service.dart';
import 'package:jt2022_app/util/snackbar.dart';
import 'package:jt2022_app/widgets/shared/avatar_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Uri _url = Uri.parse(
      'https://drive.google.com/drive/folders/1-2ayAxNqYfBqq__AYPZR3xNl-in_FZ6E?usp=sharing');
  final User _firebaseUser = FirebaseAuth.instance.currentUser!;
  late Future<List<Workshop>> _userWorkshops;
  CustomUser? _user;
  int _amountOfUserWorkshops = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _userWorkshops = WorkshopsService().getUserWorkshops(_firebaseUser.uid);
    _setAmountOfUserWorkshops();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(35, 70, 35, 0),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Row(
                  children: [
                    Avatar(
                      radius: _user?.photoUrl != '' ? 30 : 28,
                      image: _user?.photoUrl != '' ? _user?.photoUrl : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi 👋,',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            _user?.name ?? '',
                            style: Theme.of(context).textTheme.subtitle1,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/members'),
                  icon: const Icon(
                    Icons.group_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () => _launchLink(),
                  icon: const Icon(
                    Icons.upload_outlined,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 50.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Meine Workshops',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/workshop/priority')
                        .then((dynamic value) => {
                              if (value != null)
                                {
                                  _getUsersWorkshop(
                                    '🔃 Priorität der Workshops geändert!',
                                    CustomColors.infoSnackBarColor,
                                  )
                                }
                            }),
                icon: const Icon(
                  EvaIcons.flip,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: _buildUserWorkshops(),
        ),
        const SizedBox(height: 30.0),
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Text(
            'Workshops',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Expanded(
          child: _buildWorkshops(),
        ),
      ],
    );
  }

  Workshops _buildWorkshops() {
    return Workshops(
      hasMaxAmountOfWorkshops:
          _amountOfUserWorkshops >= WorkshopConstants.maxUserWorkshops,
      emitWorkshopChange: () => _getUsersWorkshop(
          '🎫  Meine Workshops geändert!', CustomColors.infoSnackBarColor),
    );
  }

  Widget _buildUserWorkshops() {
    return UserWorkshops(
      userWorkshops: _userWorkshops,
      emitWorkshopChange: () => _getUsersWorkshop(
          '🎫  Meine Workshops geändert!', CustomColors.infoSnackBarColor),
    );
  }

  void _getUsersWorkshop(String snackBarText, Color snackBarColor) {
    setState(() {
      _userWorkshops = WorkshopsService().getUserWorkshops(_firebaseUser.uid);
    });

    _setAmountOfUserWorkshops();

    GlobalSnackBar.show(context, snackBarText, snackBarColor);
  }

  void _getCurrentUser() async {
    CustomUser user = await UserService().getCurrentUser();
    setState(() => _user = user);
  }

  void _setAmountOfUserWorkshops() async {
    List<Workshop> workshops =
        await WorkshopsService().getUserWorkshops(_firebaseUser.uid);
    setState(() => _amountOfUserWorkshops = workshops.length);
  }

  void _launchLink() async {
    if (!await launchUrl(_url)) {
      GlobalSnackBar.show(
          context,
          '🚫 Google Drive Ordner konnte nicht geöffnet werden!',
          CustomColors.errorSnackBarColor);
    }
  }
}
