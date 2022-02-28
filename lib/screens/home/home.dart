import 'package:flutter/material.dart';
import 'package:jt2022_app/screens/workshop.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  final int _workshopCount = 4;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _workshopCount,
        itemBuilder: (BuildContext context, int index) {
          return const Workshop();
        },
      ),
    );
  }
}
