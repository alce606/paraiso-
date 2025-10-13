import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/evento_model.dart';

class SyncService {
  static const String baseUrl = 'http://localhost:8080';
  static Timer? _syncTimer;
  
  static void startSync(Function(List<Evento>) onEventosUpdated) {
    _syncTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      try {
        final eventos = await getEventosFromAPI();
        onEventosUpdated(eventos);
      } catch (e) {
        print('Erro na sincronização: $e');
      }
    });
  }
  
  static void stopSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }
  
  static Future<List<Evento>> getEventosFromAPI() async {
    final response = await http.get(
      Uri.parse('$baseUrl/evento/findAll'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Evento.fromJson(json)).toList();
    }
    throw Exception('Erro ao sincronizar eventos');
  }
}