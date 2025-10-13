import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class MeusEventosScreen extends StatefulWidget {
  const MeusEventosScreen({super.key});

  @override
  State<MeusEventosScreen> createState() => _MeusEventosScreenState();
}

class _MeusEventosScreenState extends State<MeusEventosScreen> with SingleTickerProviderStateMixin {
  final Color primaryColor = const Color(0xFFDC143C);
  late TabController _tabController;
  List<Map<String, dynamic>> eventosConfirmados = [];
  List<Map<String, dynamic>> eventosCancelados = [];
  List<Map<String, dynamic>> todosEventos = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _carregarEventos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _carregarEventos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usuarioId = prefs.getInt('userId');
      
      // Carrega eventos confirmados (presenças do usuário)
      if (usuarioId != null) {
        final presencas = await ApiService.getPresencasUsuario(usuarioId);
        
        List<Map<String, dynamic>> eventos = [];
        for (var presenca in presencas) {
          eventos.add({
            'id': presenca['evento']?['id'] ?? presenca['eventoId'],
            'presencaId': presenca['id'],
            'nome': presenca['evento']?['nome'] ?? presenca['eventoNome'] ?? 'Evento',
            'data': presenca['evento']?['dataEvento'] ?? presenca['dataEvento'] ?? '',
            'local': presenca['evento']?['localEvento'] ?? presenca['localEvento'] ?? '',
            'periodo': presenca['evento']?['periodo'] ?? presenca['periodo'] ?? '',
            'preco': presenca['evento']?['precoEntrada'] ?? presenca['precoEntrada'] ?? 0.0,
            'codigo': presenca['codigo'] ?? '',
          });
        }
        
        setState(() {
          eventosConfirmados = eventos;
        });
      }
      
      // Carrega TODOS os eventos para avaliação
      await _carregarTodosEventos();
      
    } catch (e) {
      setState(() {
        eventosConfirmados = [];
        todosEventos = [];
      });
    }
  }

  Future<void> _carregarTodosEventos() async {
    try {
      final response = await ApiService.getTodosEventos();
      
      List<Map<String, dynamic>> eventos = [];
      for (var evento in response) {
        eventos.add({
          'id': evento['id'],
          'nome': evento['nome'] ?? 'Evento',
          'descricao': evento['descricao'] ?? '',
          'data': evento['dataEvento'] ?? '',
          'local': evento['localEvento'] ?? '',
          'periodo': evento['periodo'] ?? '',
          'preco': evento['precoEntrada'] ?? 0.0,
          'avaliacao': 0, // Avaliação padrão
          'comentario': '', // Comentário padrão
        });
      }
      
      setState(() {
        todosEventos = eventos;
      });
    } catch (e) {
      print('Erro ao carregar todos os eventos: $e');
    }
  }

  Future<void> _cancelarPresenca(Map<String, dynamic> evento) async {
    try {
      final presencaId = evento['presencaId'];
      if (presencaId != null) {
        final sucesso = await ApiService.deletarPresencaPorId(presencaId);
        
        if (sucesso) {
          setState(() {
            eventosConfirmados.removeWhere((e) => e['id'] == evento['id']);
            eventosCancelados.add(evento);
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Presença cancelada com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao cancelar presença')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cancelar presença')),
      );
    }
  }

  void _confirmarCancelamento(Map<String, dynamic> evento) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Presença'),
        content: Text('Deseja realmente cancelar sua presença no evento "${evento['nome']}"?\n\nO evento será movido para a aba Cancelados.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelarPresenca(evento);
            },
            child: const Text('Sim', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _mostrarQrCode(Map<String, dynamic> evento) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('QR Code - ${evento['nome']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              color: Colors.white,
              child: QrImageView(
                data: 'CG-${evento['codigo']}-${evento['nome']}-${evento['data']}',
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            const SizedBox(height: 16),
            Text('Código: ${evento['codigo']}', 
                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> evento) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(evento['nome'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Data: ${evento['data']}'),
            Text('Local: ${evento['local']}'),
            Text('Período: ${evento['periodo']}'),
            Text('Valor: R\$ ${evento['preco'].toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.qr_code, color: Color(0xFFDC143C)),
                      const SizedBox(width: 8),
                      Text('Código: ${evento['codigo']}', 
                           style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.white,
                    child: QrImageView(
                      data: 'CG-${evento['codigo']}-${evento['nome']}-${evento['data']}',
                      version: QrVersions.auto,
                      size: 80.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _mostrarQrCode(evento),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Ver QR Code'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC143C),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmarCancelamento(evento),
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancelar Presença'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvaliacaoCard(Map<String, dynamic> evento) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(evento['nome'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Data: ${evento['data']}'),
            Text('Local: ${evento['local']}'),
            Text('Período: ${evento['periodo']}'),
            if (evento['descricao'].isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Descrição: ${evento['descricao']}', style: TextStyle(color: Colors.grey[600])),
            ],
            const SizedBox(height: 16),
            
            // Avaliação por estrelas
            const Text('Sua avaliação:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      evento['avaliacao'] = index + 1;
                    });
                  },
                  child: Icon(
                    index < evento['avaliacao'] ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            
            // Campo de comentário
            TextField(
              decoration: const InputDecoration(
                labelText: 'Comentário (opcional)',
                border: OutlineInputBorder(),
                hintText: 'Compartilhe sua experiência...',
              ),
              maxLines: 3,
              onChanged: (value) {
                evento['comentario'] = value;
              },
            ),
            const SizedBox(height: 16),
            
            // Botão de enviar avaliação
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _enviarAvaliacao(evento),
                icon: const Icon(Icons.send),
                label: const Text('Enviar Avaliação'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC143C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _enviarAvaliacao(Map<String, dynamic> evento) {
    if (evento['avaliacao'] == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma avaliação de 1 a 5 estrelas')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Avaliação'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Evento: ${evento['nome']}'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Avaliação: '),
                ...List.generate(5, (index) {
                  return Icon(
                    index < evento['avaliacao'] ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
              ],
            ),
            if (evento['comentario'].isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Comentário: ${evento['comentario']}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _salvarAvaliacao(evento);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Future<void> _salvarAvaliacao(Map<String, dynamic> evento) async {
    try {
      // Aqui você pode implementar a chamada para a API
      // await ApiService.salvarAvaliacao(evento['id'], evento['avaliacao'], evento['comentario']);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Avaliação do evento "${evento['nome']}" enviada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Reset da avaliação
      setState(() {
        evento['avaliacao'] = 0;
        evento['comentario'] = '';
      });
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar avaliação')),
      );
    }
  }

  Widget _buildCanceladoCard(Map<String, dynamic> evento) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cancel, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    evento['nome'], 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Data: ${evento['data']}', style: TextStyle(color: Colors.grey[600])),
            Text('Local: ${evento['local']}', style: TextStyle(color: Colors.grey[600])),
            Text('Período: ${evento['periodo']}', style: TextStyle(color: Colors.grey[600])),
            Text('Valor: R\$ ${evento['preco'].toStringAsFixed(2)}', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Presença cancelada',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Eventos'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Confirmados'),
            Tab(text: 'Avaliações'),
            Tab(text: 'Cancelados'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          eventosConfirmados.isEmpty
              ? const Center(child: Text('Nenhum evento confirmado'))
              : ListView.builder(
                  itemCount: eventosConfirmados.length,
                  itemBuilder: (context, index) => _buildEventCard(eventosConfirmados[index]),
                ),
          todosEventos.isEmpty
              ? const Center(child: Text('Nenhum evento disponível para avaliação'))
              : ListView.builder(
                  itemCount: todosEventos.length,
                  itemBuilder: (context, index) => _buildAvaliacaoCard(todosEventos[index]),
                ),
          eventosCancelados.isEmpty
              ? const Center(child: Text('Nenhum evento cancelado'))
              : ListView.builder(
                  itemCount: eventosCancelados.length,
                  itemBuilder: (context, index) => _buildCanceladoCard(eventosCancelados[index]),
                ),
        ],
      ),
    );
  }
}