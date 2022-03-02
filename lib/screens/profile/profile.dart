import 'package:flutter/material.dart';
import 'package:jt2022_app/widgets/avatar_widget.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Avatar(radius: 75),
          Text(
            'Nina',
            style: Theme.of(context).textTheme.headline1,
          ),
          Text(
            'Bümpliz',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
