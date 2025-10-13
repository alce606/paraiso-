import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tcc/models/usuario_model.dart';

class UsuarioService {
  static final UsuarioService _instance = UsuarioService._internal();
  factory UsuarioService() => _instance;
  UsuarioService._internal();

  final String baseUrl = 'http://localhost:8080/usuario';

  Future<Usuario> fetchUsuario(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/findById/$id'));

    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao buscar usuário');
    }
  }

  Future<bool> atualizarUsuario(Usuario usuario) async {
    final response = await http.put(
      Uri.parse('$baseUrl/editar/${usuario.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<bool> alterarSenha(int id, String senhaAtual, String novaSenha) async {
    final response = await http.put(
      Uri.parse('$baseUrl/alterarSenha/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'senhaAtual': senhaAtual,
        'novaSenha': novaSenha
      }),
    );

    print('Status alterarSenha: ${response.statusCode}');
    print('Response: ${response.body}');
    return response.statusCode == 200;
  }

  Future<bool> cadastrarUsuario(Usuario usuario) async {
    final url = 'http://localhost:8080/usuario/save';
    print('Chamando URL: $url');
    
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario.toJson()),
    );

    print('Status: ${response.statusCode}');
    return response.statusCode == 200;
  }
}
