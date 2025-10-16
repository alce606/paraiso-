import 'package:flutter/material.dart';
import 'package:tcc/models/evento_model.dart';
import 'detalhes_evento_screen.dart';
import 'descricao_evento_screen.dart';
import 'ingresso_screen.dart';
import '../services/api_service.dart';

class EventosAtivosScreen extends StatefulWidget {
  const EventosAtivosScreen({super.key});

  @override
  State<EventosAtivosScreen> createState() => _EventosAtivosScreenState();
}

class _EventosAtivosScreenState extends State<EventosAtivosScreen> {
  final Color primaryColor = const Color(0xFFDC143C);
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<dynamic> eventosAtivos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarEventos();
  }

  Future<void> _carregarEventos() async {
    try {
      final eventos = await ApiService.getTodosEventos();
      setState(() {
        eventosAtivos = eventos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> get filteredEventos {
    final eventos = eventosAtivos.isEmpty ? [] : eventosAtivos;
    if (_searchQuery.isEmpty) {
      return eventos;
    }
    return eventos
        .where(
          (e) =>
              (e['nome'] ?? '').toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              (e['descricao'] ?? '').toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              (e['localEvento'] ?? '').toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              (e['categoria']?['nome'] ?? '').toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }

  IconData getEventIcon(String nome) {
    if (nome.toLowerCase().contains('bazar')) return Icons.shopping_bag;
    if (nome.toLowerCase().contains('show') ||
        nome.toLowerCase().contains('rock'))
      return Icons.music_note;
    if (nome.toLowerCase().contains('almoço') ||
        nome.toLowerCase().contains('comida'))
      return Icons.restaurant;
    if (nome.toLowerCase().contains('workshop') ||
        nome.toLowerCase().contains('arte'))
      return Icons.palette;
    if (nome.toLowerCase().contains('feira') ||
        nome.toLowerCase().contains('adoção'))
      return Icons.pets;
    return Icons.event;
  }

  void _participarEvento(Map<String, dynamic> eventoMap) {
    final evento = Evento.fromJson(eventoMap);

    if (evento.precoEntrada == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              IngressoScreen(evento: evento, metodoPagamento: 'gratuito'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Função para eventos pagos ainda não implementada.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🎯', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('Eventos Ativos'),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _carregarEventos,
            tooltip: 'Atualizar eventos',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar eventos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredEventos.isEmpty
                ? Center(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.white, Color(0xFFFCE4EC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_searchQuery.isEmpty ? '📅' : '🔍', style: TextStyle(fontSize: 64)),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty 
                              ? 'Nenhum evento disponível'
                              : 'Nenhum evento encontrado para "$_searchQuery"',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (_searchQuery.isEmpty) ...[
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _carregarEventos,
                              child: Text('Atualizar'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredEventos.length,
                    itemBuilder: (context, index) {
                      final evento = filteredEventos[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 6,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DescricaoEventoScreen(evento: evento),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.white, Color(0xFFFCE4EC)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Icon(
                                          getEventIcon(evento['nome']),
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              evento['nome'],
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: primaryColor.withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                evento['categoria']?['nome'] ?? 'Sem categoria',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    evento['descricao'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 18,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          evento['localEvento'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 18,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${evento['dataEvento']} • ${evento['horaEvento']} (${evento['periodo']})',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if ((evento['totalParticipantes'] ?? 0) > 0) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.people,
                                          size: 18,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${evento['totalParticipantes']} vagas disponíveis',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      (evento['precoEntrada'] ?? 0) == 0
                                          ? 'GRATUITO'
                                          : 'R\$ ${(evento['precoEntrada'] ?? 0).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Center(
                                    child: Text(
                                      'Toque para ver detalhes e participar',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
