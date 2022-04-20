import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jt2022_app/services/users/users_service.dart';
import 'package:jt2022_app/widgets/profile/profile_edit_button.dart';
import 'package:jt2022_app/widgets/shared/action_button.dart';
import 'package:jt2022_app/widgets/shared/avatar_widget.dart';
import 'package:jt2022_app/widgets/shared/navigation_button_widget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

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
    final User user = Provider.of<User>(context);

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
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    imageFile == null
                        ? Avatar(
                            radius: user.photoURL != null ? 50 : 48,
                            image: user.photoURL)
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
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Name',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        name: 'displayName',
                        initialValue: user.displayName ?? '',
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        name: 'email',
                        initialValue: user.email ?? '',
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Bezirk',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        name: 'region',
                        initialValue: 'Bern Süd',
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Gemeinde',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        name: 'muncipality',
                        initialValue: 'Bümpliz',
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                        ),
                      ),
                    ],
                  ),
                ),
                ActionButton(
                  buttonText: "Profil speichern",
                  callback: () async {
                    _formKey.currentState!.save();
                    await context.read<UserService>().updateUser(
                        _formKey.currentState!.value, user, imageFile);
                    Navigator.maybePop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
