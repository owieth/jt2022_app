import 'package:flutter/material.dart';

class Workshops extends StatelessWidget {
  const Workshops({Key? key, required int index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/workshop'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 200,
        width: 200,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          color: Colors.black,
        ),
      ),
    );
  }
}
