import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoritosService {
  static Future<bool> adicionarFavorito(int eventoId, int usuarioId) async {
    final url = Uri.parse('http://localhost:8080/favoritos/save');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario': {'id': usuarioId},
        'evento': {'id': eventoId},
        'dataCadastro': DateTime.now().toIso8601String(),
      }),
    );
    
    return response.statusCode == 200;
  }
  
  static Future<bool> avaliarEvento(int eventoId, int usuarioId, int nota) async {
    final url = Uri.parse('http://localhost:8080/avaliacoes/save');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario': {'id': usuarioId},
        'evento': {'id': eventoId},
        'nota': nota,
        'dataAvaliacao': DateTime.now().toIso8601String(),
      }),
    );
    
    if (response.statusCode == 200) {
      // Adiciona automaticamente aos favoritos após avaliar
      await adicionarFavorito(eventoId, usuarioId);
      return true;
    }
    return false;
  }
}