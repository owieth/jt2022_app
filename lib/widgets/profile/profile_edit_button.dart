import 'package:flutter/material.dart';

class ProfileEditButton extends StatelessWidget {
  final Function callback;
  final IconData icon;

  const ProfileEditButton(
      {Key? key, required this.callback, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 55,
      left: 50,
      child: ElevatedButton(
        onPressed: () => callback(),
        child: Icon(
          icon,
          color: Colors.black,
          size: 15,
        ),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          primary: Colors.white,
          onPrimary: Colors.black,
          fixedSize: const Size(30, 30),
        ),
      ),
    );
  }
}
