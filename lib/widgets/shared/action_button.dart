import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback callback;

  const ActionButton(
      {Key? key, required this.buttonText, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: ElevatedButton(
        onPressed: callback,
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        child: Text(buttonText, style: Theme.of(context).textTheme.subtitle2),
      ),
    );
  }
}
