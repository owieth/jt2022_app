import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/constants/colors.dart';
import 'package:jt2022_app/constants/workshop.dart';
import 'package:jt2022_app/models/workshop.dart';
import 'package:jt2022_app/screens/workshop/user_workshops.dart';
import 'package:jt2022_app/screens/workshop/workshops.dart';
import 'package:jt2022_app/services/workshops/workshops_service.dart';
import 'package:jt2022_app/util/snackbar.dart';
import 'package:jt2022_app/widgets/shared/avatar_widget.dart';
import 'package:line_icons/line_icons.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final User _user = FirebaseAuth.instance.currentUser!;
  late Future<List<Workshop>> _userWorkshops;
  int amountOfUserWorkshops = 0;

  @override
  void initState() {
    super.initState();
    _userWorkshops = WorkshopsService().getUserWorkshops(_user.uid);
    _setAmountOfUserWorkshops();
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) => GlobalSnackBar.show(
          context,
          '👋 Eingeloggt als ${_user.displayName}',
          CustomColors.successSnackBarColor),
    );
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
              Avatar(
                radius: _user.photoURL != null ? 30 : 28,
                image: _user.photoURL,
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
                      _user.displayName ?? "",
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  ],
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
                  LineIcons.pen,
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
          amountOfUserWorkshops >= WorkshopConstants.maxUserWorkshops,
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
      _userWorkshops = WorkshopsService().getUserWorkshops(_user.uid);
    });

    _setAmountOfUserWorkshops();

    GlobalSnackBar.show(context, snackBarText, snackBarColor);
  }

  _setAmountOfUserWorkshops() async {
    List<Workshop> workshops =
        await WorkshopsService().getUserWorkshops(_user.uid);
    setState(() {
      amountOfUserWorkshops = workshops.length;
    });
  }
}
