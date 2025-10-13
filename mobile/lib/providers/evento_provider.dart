import 'dart:async';
import 'package:flutter/material.dart';
import '../models/evento_model.dart';
import '../services/evento_service.dart';

class EventoProvider extends ChangeNotifier {
  final EventoService _eventoService = EventoService();
  Timer? _pollingTimer;

  List<Evento> _eventos = [];
  List<String> _categorias = [];
  bool _isLoading = false;
  String? _error;

  List<Evento> get eventos => _eventos;
  List<String> get categorias => _categorias;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadEventos({String? categoria, String? search}) async {
    _setLoading(true);
    _clearError();

    try {
      _eventos = await _eventoService.getEventos(
        categoria: categoria,
        search: search,
      );
      notifyListeners();
    } catch (e) {
      if (categoria != null) {
        _eventos = _eventos.where((e) => e.categoria.nome == categoria).toList();
      }
      if (search != null && search.isNotEmpty) {
        _eventos = _eventos.where((e) => 
          e.nome.toLowerCase().contains(search.toLowerCase()) ||
          e.descricao.toLowerCase().contains(search.toLowerCase())
        ).toList();
      }
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadTodosEnventos() async {
    try {
      print('Carregando eventos...');
      _eventos = await _eventoService.getTodosEventos();
      print('Eventos carregados: ${_eventos.length}');
      notifyListeners();
    } catch (e) {
      print('Erro ao carregar eventos: $e');
      _setError(e.toString());
    }
  }

  Future<void> loadCategorias() async {
    try {
      _categorias = await _eventoService.getCategorias();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<Evento?> getEventoById(int id) async {
    try {
      return await _eventoService.getEventoById(id);
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void startPolling() {
    _pollingTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      loadTodosEnventos();
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}
