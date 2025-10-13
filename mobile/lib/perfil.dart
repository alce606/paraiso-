import 'package:flutter/material.dart';

class PerfilLegacyScreen extends StatelessWidget {
  const PerfilLegacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil Legacy'),
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Tela de Perfil Legacy'),
      ),
    );
  }
}