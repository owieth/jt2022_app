import 'package:flutter/material.dart';

class Workshops extends StatelessWidget {
  final int index;

  const Workshops({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/workshop'),
      child: Container(
        height: 200,
        width: 200,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage('assets/images/speeddating.jpeg'),
                fit: BoxFit.cover)),
      ),
    );
  }
}
