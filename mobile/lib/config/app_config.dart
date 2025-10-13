class AppConfig {
  // URLs da API - Sincronizado com React
  static const String baseUrl = 'http://localhost:8080';
  static const String apiUrl = '$baseUrl/';
  
  // Configurações de sincronização
  static const int syncIntervalSeconds = 5;
  static const int connectionTimeoutSeconds = 30;
  
  // URLs específicas
  static const String eventosEndpoint = 'evento/findAll';
  static const String loginEndpoint = 'auth/login';
  static const String usuariosEndpoint = 'usuarios';
  
  // Configurações do app
  static const String appName = 'CORAÇÃO GENEROSO';
  static const String appVersion = '1.0.0';
}