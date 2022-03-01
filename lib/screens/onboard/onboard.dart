import 'package:flutter/material.dart';

class Onboard extends StatelessWidget {
  const Onboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/onboard.jpeg'),
              fit: BoxFit.cover),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Container(
          width: 60,
          height: 60,
          child: const Icon(Icons.add),
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 224, 175, 165),
                Color.fromARGB(255, 144, 132, 140)
              ])),
        ),
        onPressed: () => Navigator.pushReplacementNamed(context, ''),
      ),
    );
  }
}
