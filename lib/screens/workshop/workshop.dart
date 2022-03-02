import 'package:flutter/material.dart';
import 'package:jt2022_app/widgets/navigation_button_widget.dart';

class Workshop extends StatelessWidget {
  const Workshop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/church.jpeg'),
              fit: BoxFit.cover),
        ),
      ),
      floatingActionButton: const NavigationButton(),
    );
  }
}
