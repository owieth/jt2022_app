import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  const NavigationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 45.0, top: 100.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back))
            ],
          )
        ],
      ),
    );
  }
}
