import 'package:flutter/material.dart';

class TextOverlay extends StatelessWidget {
  final String text;
  final double maxWidth;

  const TextOverlay({Key? key, required this.text, required this.maxWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 10,
      left: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 40,
          color: const Color.fromRGBO(0, 0, 0, 0.5),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: SingleChildScrollView(
                    child: Text(text,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
