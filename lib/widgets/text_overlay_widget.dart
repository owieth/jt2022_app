import 'package:flutter/material.dart';

class TextOverlay extends StatelessWidget {
  const TextOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 145,
      left: 20,
      child: Container(
        height: 40,
        width: 180,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ),
        child: Center(
          child: Text(
            'Gottesdienst',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }
}
