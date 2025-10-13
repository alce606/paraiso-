import 'package:flutter/material.dart';

class SuporteLegacyScreen extends StatelessWidget {
  const SuporteLegacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suporte Legacy'),
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Tela de Suporte Legacy'),
      ),
    );
  }
}