import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'http_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final HttpService _httpService = HttpService();
  User? _currentUser;
  String? _token;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _token != null && _currentUser != null;

  Future<void> initialize() async {
    await _loadStoredAuth();
  }

  Future<LoginResponse> login(String email, String senha) async {
    try {
      final loginRequest = LoginRequest(email: email, senha: senha);
      final response = await _httpService.post('/auth/login', data: loginRequest.toJson());
      
      final loginResponse = LoginResponse.fromJson(response.data);
      
      _token = loginResponse.token;
      _currentUser = loginResponse.user;
      
      _httpService.setAuthToken(_token!);
      await _saveAuth();
      
      return loginResponse;
    } catch (e) {
      throw Exception('Erro no login: $e');
    }
  }

  Future<User> register(String nome, String email, String senha, {String? telefone}) async {
    try {
      final registerData = {
        'nome': nome,
        'email': email,
        'senha': senha,
        if (telefone != null) 'telefone': telefone,
      };
      
      final response = await _httpService.post('/auth/register', data: registerData);
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro no cadastro: $e');
    }
  }

  Future<void> logout() async {
    _token = null;
    _currentUser = null;
    _httpService.clearAuthToken();
    await _clearStoredAuth();
  }

  Future<void> _saveAuth() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token != null) {
      await prefs.setString('auth_token', _token!);
    }
    if (_currentUser != null) {
      await prefs.setString('current_user', _currentUser!.toJson().toString());
    }
  }

  Future<void> _loadStoredAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    
    if (_token != null) {
      _httpService.setAuthToken(_token!);
      // Aqui você pode fazer uma chamada para validar o token
      // e carregar os dados do usuário atual
    }
  }

  Future<void> _clearStoredAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('current_user');
  }
}