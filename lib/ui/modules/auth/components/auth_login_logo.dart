import 'package:flutter/material.dart';

class AuthLoginLogo extends StatelessWidget {
  const AuthLoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'lib/ui/assets/images/logo.png',
        height: 100,
        errorBuilder: (_, __, ___) => const Icon(Icons.school, size: 80),
      ),
    );
  }
}
