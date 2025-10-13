import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/usuario_model.dart';  // Se o modelo Usuario estiver em um arquivo separado

class AuthProvider with ChangeNotifier {
  String? error;
  Usuario? usuarioLogado;

  Future<bool> login(String email, String senha) async {
    final url = Uri.parse('http://localhost:8080/usuario/login'); // URL da sua API
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'senha': senha,
      }),
    );

    if (response.statusCode == 200) {
      // Se o login for bem-sucedido, parse a resposta e crie um usuário
      final Map<String, dynamic> data = jsonDecode(response.body);
      usuarioLogado = Usuario.fromJson(data);  // Supondo que o usuário retornado seja no formato esperado
      notifyListeners();
      return true;
    } else {
      // Se ocorrer um erro, mostre a mensagem de erro
      final Map<String, dynamic> data = jsonDecode(response.body);
      error = data['message'] ?? 'Erro no login';
      notifyListeners();
      return false;
    }
  }
}

