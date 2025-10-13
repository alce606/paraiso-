import '../models/evento_model.dart';
import 'http_service.dart';

class EventoService {
  static final EventoService _instance = EventoService._internal();
  factory EventoService() => _instance;
  EventoService._internal();

  final HttpService _httpService = HttpService();

  Future<List<Evento>> getEventos({String? categoria, String? search}) async {
    try {
      Map<String, dynamic> queryParams = {};

      if (categoria != null && categoria.isNotEmpty) {
        queryParams['categoria'] = categoria;
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _httpService.get(
        'evento/findAll',
        queryParameters: queryParams,
      );

      final List<dynamic> eventosJson = response.data;
      return eventosJson.map((json) => Evento.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao carregar eventos: $e');
    }
  }

  Future<Evento> getEventoById(int id) async {
    try {
      final response = await _httpService.get('evento/findById/$id');
      return Evento.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao carregar evento: $e');
    }
  }

  Future<Evento> criarEvento(Evento evento) async {
    try {
      final response = await _httpService.post(
        '/eventos',
        data: evento.toJson(),
      );
      return Evento.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao criar evento: $e');
    }
  }

  Future<Evento> atualizarEvento(int id, Evento evento) async {
    try {
      final response = await _httpService.put(
        '/eventos/$id',
        data: evento.toJson(),
      );
      return Evento.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao atualizar evento: $e');
    }
  }

  Future<void> deletarEvento(int id) async {
    try {
      await _httpService.delete('/eventos/$id');
    } catch (e) {
      throw Exception('Erro ao deletar evento: $e');
    }
  }

  Future<List<String>> getCategorias() async {
    try {
      final response = await _httpService.get('/eventos/categorias');
      return List<String>.from(response.data);
    } catch (e) {
      throw Exception('Erro ao carregar categorias: $e');
    }
  }

  Future<List<Evento>> getTodosEventos() async {
    try {
      print('Fazendo requisição para: evento/findAll');
      final response = await _httpService.get('evento/findAll');
      print('Response recebido: ${response.data}');
      
      final List<dynamic> eventosJson = response.data;
      final eventos = eventosJson.map((json) => Evento.fromJson(json)).toList();
      print('Eventos convertidos: ${eventos.length}');
      
      return eventos;
    } catch (e) {
      print('Erro detalhado: $e');
      throw Exception('Erro ao carregar eventos: $e');
    }
  }
}
