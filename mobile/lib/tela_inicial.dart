import 'package:flutter/material.dart';

class TelaInicialLegacy extends StatelessWidget {
  const TelaInicialLegacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Inicial Legacy'),
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Tela Inicial Legacy'),
      ),
    );
  }
}