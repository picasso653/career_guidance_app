// widgets/logo_appbar.dart
import 'package:flutter/material.dart';

AppBar buildLogoAppBar(String title) {
  return AppBar(
    title: Row(
      children: [
        Image.asset(
          'assets/images/logo_0.png',
          height: 28,
        ),
        const SizedBox(width: 8),
        Text(title),
      ],
    ),
    backgroundColor: Colors.white,
    foregroundColor: Colors.black87,
    elevation: 0.5,
  );
}
