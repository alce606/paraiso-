import '../models/evento_model.dart';

class SearchService {
  static List<dynamic> getFilteredResults(String searchQuery, List<Evento> eventos) {
    if (searchQuery.isEmpty) {
      return eventos.where((e) => e.statusEvento == 'ATIVO').toList();
    }

    List<dynamic> results = [];

    // Buscar nos eventos
    results.addAll(eventos
        .where((e) =>
            e.statusEvento == 'ATIVO' &&
            (e.nome.toLowerCase().contains(searchQuery.toLowerCase()) ||
                e.descricao.toLowerCase().contains(searchQuery.toLowerCase()) ||
                e.localEvento.toLowerCase().contains(searchQuery.toLowerCase())))
        .toList());

    // Buscar nas opções do menu (removido por enquanto)

    return results;
  }
}