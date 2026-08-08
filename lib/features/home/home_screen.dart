import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DisstApp',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: const Center(
        child: Text(
          'Barka da zuwa DisstApp',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
