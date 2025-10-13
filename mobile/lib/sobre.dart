import 'package:flutter/material.dart';

class SobreLegacyScreen extends StatelessWidget {
  const SobreLegacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre Legacy'),
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Tela Sobre Legacy'),
      ),
    );
  }
}