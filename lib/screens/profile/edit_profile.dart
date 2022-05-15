import 'dart:io';

import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jt2022_app/constants/churches.dart';
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
    String region = _user.region;
    String muncipality = _user.muncipality;
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
                            radius: _user.photoUrl != '' ? 48 : 50,
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
                        Text(
                          'Name',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(height: 8),
                        FormBuilderTextField(
                          name: 'name',
                          initialValue: _user.name,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: CustomColors.primaryColor, width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Bezirk',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(height: 8),
                        CoolDropdown(
                          resultHeight: 65,
                          resultWidth: MediaQuery.of(context).size.width,
                          resultBD: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          resultTS: Theme.of(context).textTheme.subtitle1,
                          placeholderTS: Theme.of(context).textTheme.subtitle1,
                          placeholder: 'Bezirk auswählen',
                          dropdownList: Churches().regions,
                          dropdownHeight: 200,
                          dropdownWidth:
                              MediaQuery.of(context).size.width - 100,
                          selectedItemTS: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          unselectedItemTS: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          selectedItemBD: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: CustomColors.primaryColor,
                          ),
                          defaultValue: Churches()
                              .regions
                              .where(
                                  (element) => element['value'] == _user.region)
                              .toList()[0],
                          isTriangle: false,
                          gap: 5.0,
                          onChange: (attribute) => region = attribute['value'],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Gemeinde',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(height: 8),
                        CoolDropdown(
                          resultHeight: 65,
                          resultWidth: MediaQuery.of(context).size.width,
                          resultBD: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          resultTS: Theme.of(context).textTheme.subtitle1,
                          placeholderTS: Theme.of(context).textTheme.subtitle1,
                          placeholder: 'Gemeinde auswählen',
                          dropdownList: Churches().municipalities,
                          dropdownHeight: 200,
                          dropdownWidth:
                              MediaQuery.of(context).size.width - 100,
                          selectedItemTS: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          unselectedItemTS: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          selectedItemBD: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: CustomColors.primaryColor,
                          ),
                          defaultValue: Churches()
                              .municipalities
                              .where((element) =>
                                  element['value'] == _user.muncipality)
                              .toList()[0],
                          isTriangle: false,
                          gap: 5.0,
                          onChange: (attribute) =>
                              muncipality = attribute['value'],
                        ),
                        const SizedBox(height: 24),
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
                                  'region': region,
                                  'muncipality': muncipality,
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
