import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:jt2022_app/constants/colors.dart';
import 'package:jt2022_app/services/auth/authentication_service.dart';
import 'package:jt2022_app/widgets/shared/action_button.dart';
import 'package:jt2022_app/widgets/shared/navigation_button_widget.dart';
import 'package:provider/provider.dart';

enum ChangeUserCredentials { email, password }

class ChangeCredentials extends StatefulWidget {
  final ChangeUserCredentials changeUserCredentials;

  const ChangeCredentials({Key? key, required this.changeUserCredentials})
      : super(key: key);

  @override
  State<ChangeCredentials> createState() => _ChangeCredentialsState();
}

class _ChangeCredentialsState extends State<ChangeCredentials> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();

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
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.changeUserCredentials ==
                          ChangeUserCredentials.password) ...{
                        ..._buildFormTextField('Neues Passwort', 'password'),
                        ..._buildFormTextField(
                            'Passwort wiederholen', 'confirmPassword'),
                        ActionButton(
                          buttonText: "Passwort speichern",
                          callback: () async {
                            _formKey.currentState!.save();
                            await context
                                .read<AuthenticationService>()
                                .changePassword(context,
                                    _formKey.currentState!.value['password']);
                          },
                        ),
                      } else ...{
                        ..._buildFormTextField('Neue Email', 'email'),
                        ..._buildFormTextField(
                            'Email wiederholen', 'confirmEmail'),
                        ActionButton(
                          buttonText: "Email speichern",
                          callback: () async {
                            _formKey.currentState!.save();
                            await context
                                .read<AuthenticationService>()
                                .changeEmail(context,
                                    _formKey.currentState!.value['email']);
                          },
                        ),
                      },
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormTextField(String fieldName, String userAttribute) {
    return [
      Text(
        fieldName,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      const SizedBox(height: 8),
      FormBuilderTextField(
        name: userAttribute,
        initialValue: '',
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
}
