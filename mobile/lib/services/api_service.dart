import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080'; // Sincronizado com React
  
  // Endpoints específicos
  static String get eventosUrl => '$baseUrl/evento/findAll';
  static String get loginUrl => '$baseUrl/auth/login';
  static String get usuariosUrl => '$baseUrl/usuarios';
  
  static Future<List<dynamic>> getEventos() async {
    final response = await http.get(Uri.parse('$baseUrl/eventos'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Erro ao carregar eventos');
  }
  
  static Future<Map<String, dynamic>> login(String email, String senha) async {
    print('Tentando login com: $email');
    print('URL: $baseUrl/auth/login');
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'senha': senha}),
      );
      
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Login falhou - Status: ${response.statusCode}, Body: ${response.body}');
    } catch (e) {
      print('Erro na requisição: $e');
      throw Exception('Erro de conexão: $e');
    }
  }
  
  static Future<Map<String, dynamic>> cadastrarUsuario(Map<String, dynamic> usuario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(usuario),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception('Erro no cadastro');
  }

static Future<Map<String, dynamic>> getUsuarioPorId(int id) async {
  final response = await http.get(Uri.parse('http://localhost:8080/usuario/findById/$id'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  }
  throw Exception('Erro ao buscar usuário');
}

static Future<bool> atualizarUsuario(int id, Map<String, dynamic> dadosAtualizados) async {
  try {
    print('Atualizando usuário ID: $id');
    
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('http://localhost:8080/usuario/editar/$id'),
    );
    
    // Adiciona campos como form-data
    if (dadosAtualizados.containsKey('nome')) {
      request.fields['nome'] = dadosAtualizados['nome'];
    }
    
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    
    print('Status Code: ${response.statusCode}');
    print('Response Body: $responseBody');
    
    return response.statusCode == 200;
  } catch (e) {
    print('Erro ao atualizar usuário: $e');
    return false;
  }
 }

 static Future<List<dynamic>> getPresencasUsuario(int usuarioId) async {
   // Tenta buscar todas as presenças e filtrar pelo usuário
   try {
     final response = await http.get(
       Uri.parse('http://localhost:8080/presenca/findAll')
     );
     if (response.statusCode == 200) {
       final todasPresencas = json.decode(response.body) as List;
       // Filtra presenças do usuário
       return todasPresencas.where((presenca) => 
         presenca['usuario']?['id'] == usuarioId
       ).toList();
     }
   } catch (e) {
     print('Erro ao buscar presenças: $e');
   }
   
   // Se não funcionar, tenta endpoint específico
   try {
     final response = await http.get(
       Uri.parse('http://localhost:8080/presenca/usuario/$usuarioId')
     );
     if (response.statusCode == 200) {
       return json.decode(response.body);
     }
   } catch (e) {
     print('Endpoint específico também falhou: $e');
   }
   
   return []; // Retorna lista vazia se nada funcionar
 }

 static Future<List<dynamic>> getTodosEventos() async {
   try {
     final response = await http.get(
       Uri.parse('http://localhost:8080/evento/findAll'),
       headers: {'Content-Type': 'application/json'},
     );
     
     if (response.statusCode == 200) {
       return json.decode(response.body);
     }
     throw Exception('Erro ao carregar eventos');
   } catch (e) {
     print('Erro ao buscar todos os eventos: $e');
     return [];
   }
 }

 static Future<bool> alterarSenha(int userId, String novaSenha) async {
   try {
     final usuarioData = await getUsuarioPorId(userId);
     final email = usuarioData['email'];
     
     print('Email: $email');
     
     final response = await http.put(
       Uri.parse('http://localhost:8080/usuario/alterarSenha/$email'),
       headers: {'Content-Type': 'application/json'},
       body: json.encode({
         'email': email,
         'senha': novaSenha
       }),
     );
     
     print('Status: ${response.statusCode}');
     print('Response: ${response.body}');
     return response.statusCode == 200;
   } catch (e) {
     print('Erro: $e');
     return false;
   }
 }

 static Future<bool> deletarPresencaPorId(int presencaId) async {
   try {
     final response = await http.delete(
       Uri.parse('$baseUrl/presenca/$presencaId')
     );
     
     return response.statusCode == 200;
   } catch (e) {
     return false;
   }
 }
}