import 'package:flutter/material.dart';

/// App Main Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arena')),
      body: const Center(child: Text('Nothing here yet.')),
    );
  }
}
