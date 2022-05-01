import 'package:flutter/material.dart';

class GlobalSnackBar {
  final String message;
  final Color color;

  const GlobalSnackBar({
    required this.color,
    required this.message,
  });

  static show(
    BuildContext context,
    String message,
    Color color,
  ) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 30.0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          content: Text(message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1),
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          width: 200,
        ),
      );
  }
}
