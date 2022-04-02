import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/screens/workshop/user_workshops.dart';
import 'package:jt2022_app/screens/workshop/workshops.dart';
import 'package:jt2022_app/widgets/shared/avatar_widget.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final User _user;

  @override
  void initState() {
    _user = Provider.of<User?>(context, listen: false)!;
    super.initState();
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
              const Avatar(radius: 30),
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
        const SizedBox(
          height: 200,
          child: UserWorkshops(),
        ),
        const SizedBox(height: 50.0),
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Text(
            'Workshops',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        const Expanded(
          child: Workshops(),
        ),
      ],
    );
  }
}
