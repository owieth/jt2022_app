import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  const NavigationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pop(context),
      child: const SizedBox(
        width: 60,
        height: 60,
        child: Icon(Icons.arrow_back_ios),
      ),
    );
  }
}
