import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/services/auth/authentication_service.dart';
import 'package:jt2022_app/widgets/avatar_widget.dart';
import 'package:jt2022_app/widgets/navigation_button_widget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    print(image);
  }

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
                      Positioned(
                        top: 55,
                        left: 50,
                        child: ElevatedButton(
                          onPressed: () => _pickImage(),
                          child: const Icon(
                            LineIcons.pen,
                            color: Colors.black,
                            size: 15,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            primary: Colors.white,
                            fixedSize: const Size(30, 30),
                          ),
                        ),
                      ),
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
              const SizedBox(height: 50),
              Container(
                height: 75,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.white, width: 5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Jugi',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
