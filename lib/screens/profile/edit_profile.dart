import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jt2022_app/constants/colors.dart';
import 'package:jt2022_app/models/user.dart';
import 'package:jt2022_app/services/users/users_service.dart';
import 'package:jt2022_app/widgets/profile/profile_edit_button.dart';
import 'package:jt2022_app/widgets/shared/action_button.dart';
import 'package:jt2022_app/widgets/shared/avatar_widget.dart';
import 'package:jt2022_app/widgets/shared/navigation_button_widget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:switcher_button/switcher_button.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormBuilderState>();
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    Map _arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final CustomUser _user = _arguments['user'];
    bool isVolunteer = _user.isVolunteer;

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
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
            padding: const EdgeInsets.fromLTRB(35, 100, 35, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    imageFile == null
                        ? Avatar(
                            radius: _user.photoUrl != '' ? 50 : 48,
                            image: _user.photoUrl != '' ? _user.photoUrl : null,
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(
                              imageFile!,
                            ),
                          ),
                    ProfileEditButton(
                      icon: LineIcons.photoVideo,
                      callback: () => _pickImage(),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._buildFormTextField('Name', 'name', _user.name),
                        ..._buildFormTextField(
                            'Bezirk', 'region', _user.region),
                        ..._buildFormTextField(
                            'Gemeinde', 'muncipality', _user.muncipality),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ich möchte mithelfen',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            SwitcherButton(
                              onColor: CustomColors.primaryColor,
                              offColor: Colors.white,
                              value: _user.isVolunteer,
                              onChange: (value) => isVolunteer = value,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ActionButton(
                          buttonText: "Profil speichern",
                          callback: () async {
                            _formKey.currentState!.save();
                            SVProgressHUD.show();
                            await context.read<UserService>().updateUser(
                                context,
                                {
                                  ..._formKey.currentState!.value,
                                  'isVolunteer': isVolunteer
                                },
                                FirebaseAuth.instance.currentUser!.uid,
                                imageFile);
                            SVProgressHUD.dismiss();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormTextField(
      String fieldName, String userAttribute, String value) {
    return [
      Text(
        fieldName,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      const SizedBox(height: 8),
      FormBuilderTextField(
        name: userAttribute,
        initialValue: value,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: CustomColors.primaryColor, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      const SizedBox(height: 24),
    ];
  }

  Future _pickImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
    );

    if (pickedFile == null) return;

    setState(() => imageFile = File(pickedFile.path));
  }
}
