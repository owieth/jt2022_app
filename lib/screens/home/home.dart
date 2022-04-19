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
import 'package:jt2022_app/util/snackbar.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final User _user;
  late Future<List<Workshop>> _userWorkshops;
  int amountOfUserWorkshops = 0;

  _setAmountOfUsers() async {
    List<Workshop> workshops =
        await WorkshopsService().getUserWorkshops(_user.uid);
    setState(() {
      amountOfUserWorkshops = workshops.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _user = Provider.of<User?>(context, listen: false)!;
    _userWorkshops = WorkshopsService().getUserWorkshops(_user.uid);
    _setAmountOfUsers();
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
                image: _user.photoURL ?? '',
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
          padding: const EdgeInsets.only(left: 35),
          child: Text(
            'Meine Workshops',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        SizedBox(
          height: 200,
          child: _buildUserWorkshops(),
        ),
        const SizedBox(height: 50.0),
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
      emitWorkshopChange: () => _getUsersWorkshop(),
    );
  }

  Widget _buildUserWorkshops() {
    return UserWorkshops(
      userWorkshops: _userWorkshops,
      emitWorkshopChange: () => _getUsersWorkshop(),
    );
  }

  void _getUsersWorkshop() {
    setState(() {
      _userWorkshops = WorkshopsService().getUserWorkshops(_user.uid);
    });

    GlobalSnackBar.show(context, '🎫  Meine Workshops geändert!',
        CustomColors.infoSnackBarColor);
  }
}
