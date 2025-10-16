import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import 'ingresso_screen.dart';
import '../models/evento_model.dart';

class DescricaoEventoScreen extends StatefulWidget {
  final Map<String, dynamic> evento;

  const DescricaoEventoScreen({super.key, required this.evento});

  @override
  State<DescricaoEventoScreen> createState() => _DescricaoEventoScreenState();
}

class _DescricaoEventoScreenState extends State<DescricaoEventoScreen> {
  bool _isLoading = false;

  Future<bool> _verificarPresencaExistente(int usuarioId, int eventoId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/presenca/findAll'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final presencas = jsonDecode(response.body) as List;
        return presencas.any((presenca) => 
          presenca['usuario']?['id'] == usuarioId && 
          presenca['evento']?['id'] == eventoId
        );
      }
    } catch (e) {
      print('Erro ao verificar presença: $e');
    }
    return false;
  }

  Future<bool> _marcarPresenca(int usuarioId, int eventoId, String codigo) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/presenca/save'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'codigo': codigo,
          'usuario': {'id': usuarioId},
          'evento': {'id': eventoId},
          'statusPresenca': 'confirmado',
        }),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao marcar presença: $e');
      return false;
    }
  }

  String _gerarCodigoIngresso() {
    final random = Random();
    return 'CG${random.nextInt(999999).toString().padLeft(6, '0')}';
  }

  Future<void> _participarEvento() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final usuarioId = prefs.getInt('userId');

      if (usuarioId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não autenticado!')),
        );
        return;
      }

      final eventoId = widget.evento['id'];
      if (eventoId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID do evento inválido!')),
        );
        return;
      }

      // Verificar se já confirmou presença
      final jaConfirmado = await _verificarPresencaExistente(usuarioId, eventoId);
      if (jaConfirmado) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você já confirmou presença neste evento!'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final codigo = _gerarCodigoIngresso();
      final sucesso = await _marcarPresenca(usuarioId, eventoId, codigo);

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Presença confirmada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navegar para tela de ingresso
        final evento = Evento.fromJson(widget.evento);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IngressoScreen(
              evento: evento,
              metodoPagamento: evento.precoEntrada == 0 ? 'gratuito' : 'pago',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao confirmar presença. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descrição do Evento'),
        backgroundColor: const Color(0xFFDC143C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título e categoria
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.white, Color(0xFFFCE4EC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    widget.evento['nome'] ?? 'Evento',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDC143C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC143C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.evento['categoria']?['nome'] ?? 'Categoria',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Informações básicas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📋 Informações Gerais',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC143C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('📅 Data:', widget.evento['dataEvento'] ?? 'Não informado'),
                    _buildInfoRow('⏰ Horário:', widget.evento['horaEvento'] ?? 'Não informado'),
                    _buildInfoRow('🌅 Período:', widget.evento['periodo'] ?? 'Não informado'),
                    _buildInfoRow('📍 Local:', widget.evento['localEvento'] ?? 'Não informado'),
                    _buildInfoRow('👥 Total de Participantes:', '${widget.evento['totalParticipantes'] ?? 0}'),
                    if (widget.evento['complemento'] != null)
                      _buildInfoRow('🏢 Endereço:', widget.evento['complemento']),
                    if (widget.evento['cep'] != null)
                      _buildInfoRow('📮 CEP:', widget.evento['cep']),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Detalhes financeiros
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💰 Detalhes do Evento',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF28A745),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      '💵 Valor:',
                      (widget.evento['precoEntrada'] ?? 0) == 0
                          ? 'GRATUITO'
                          : 'R\$ ${(widget.evento['precoEntrada'] ?? 0).toStringAsFixed(2)}',
                    ),
                    if ((widget.evento['totalParticipantes'] ?? 0) > 0)
                      _buildInfoRow('👥 Vagas:', '${widget.evento['totalParticipantes']} disponíveis'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Descrição completa
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📝 Descrição Completa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC143C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.evento['descricao'] ?? 'Nenhuma descrição disponível.',
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Organizador
            if (widget.evento['usuario'] != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '👤 Organizador',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('Nome:', widget.evento['usuario']['nome'] ?? 'Não informado'),
                      _buildInfoRow('Email:', widget.evento['usuario']['email'] ?? 'Não informado'),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Botão de participar
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _participarEvento,
                icon: _isLoading 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.event_available),
                label: Text(
                  _isLoading ? 'Confirmando...' : 'Participar do Evento',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC143C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}