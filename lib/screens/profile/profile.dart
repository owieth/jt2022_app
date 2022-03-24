import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/services/auth/authentication_service.dart';
import 'package:jt2022_app/widgets/avatar_widget.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Avatar(radius: 50),
          Text(
            _user!.displayName as String,
            style: Theme.of(context).textTheme.headline1,
          ),
          Text(
            'Bümpliz',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text("Sign Out"),
          ),
        ],
      ),
    );
  }
}
