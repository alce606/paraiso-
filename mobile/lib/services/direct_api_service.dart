import 'dart:convert';
import 'package:http/http.dart' as http;

class DirectApiService {
  static const String baseUrl = 'http://localhost:8080';
  
  static Future<List<dynamic>> getEventos() async {
    try {
      print('Buscando eventos em: $baseUrl/evento/findAll');
      
      final response = await http.get(
        Uri.parse('$baseUrl/evento/findAll'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      
      throw Exception('Erro ${response.statusCode}: ${response.body}');
    } catch (e) {
      print('Erro na requisição: $e');
      throw e;
    }
  }
}