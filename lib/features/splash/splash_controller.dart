import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/login_screen.dart';
import '../home/home_screen.dart';

class SplashController {
  static Future<void> start(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    if (!context.mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    final destination = user != null
        ? const HomeScreen()
        : const LoginScreen();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => destination,
      ),
    );
  }
}
