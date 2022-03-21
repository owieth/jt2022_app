import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  const NavigationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      //width: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back,
        ),
        label: const Text(''),
      ),
    );
  }
}
