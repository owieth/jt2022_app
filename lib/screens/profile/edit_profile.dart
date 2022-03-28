import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jt2022_app/widgets/shared/action_button.dart';
import 'package:jt2022_app/widgets/shared/avatar_widget.dart';
import 'package:jt2022_app/widgets/shared/navigation_button_widget.dart';
import 'package:jt2022_app/widgets/profile/profile_edit_button.dart';
import 'package:jt2022_app/widgets/shared/textfield_widget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);

    return Stack(
      children: [
        Positioned(
          top: 35,
          left: 35,
          child: NavigationButton(
            icon: Icons.arrow_back_ios_new,
            onPressedButton: () => Navigator.pop(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  const Avatar(radius: 50),
                  ProfileEditButton(
                    icon: LineIcons.photoVideo,
                    callback: () => _pickImage(),
                  )
                ],
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                label: 'Name',
                text: _user!.displayName ?? '',
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                label: 'Email',
                text: _user.email ?? '',
              ),
              const SizedBox(height: 24),
              const TextFieldWidget(
                label: 'Bezirk',
                text: 'Bern Süd',
              ),
              const SizedBox(height: 24),
              const TextFieldWidget(
                label: 'Gemeinde',
                text: 'Bümpliz',
              ),
              ActionButton(
                buttonText: "Profil speichern",
                callback: () => {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
