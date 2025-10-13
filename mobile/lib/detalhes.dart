import 'package:flutter/material.dart';

class DetalhesScreen extends StatelessWidget {
  const DetalhesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Tela de Detalhes'),
      ),
    );
  }
}