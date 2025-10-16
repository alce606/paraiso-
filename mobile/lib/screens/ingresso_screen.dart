import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/evento_model.dart';
import '../services/favoritos_service.dart';
import '../config/app_config.dart';
import 'meus_eventos_screen.dart';

class IngressoScreen extends StatelessWidget {
  final Evento evento;
  final String? metodoPagamento;

  const IngressoScreen({super.key, required this.evento, this.metodoPagamento});

  String _gerarCodigoIngresso() {
    final random = Random();
    return 'CG${random.nextInt(999999).toString().padLeft(6, '0')}';
  }

  Future<bool> marcarPresenca({
    required String codigo,
    required int usuarioId,
    required int eventoId,
    String statusPresenca = "confirmado",
  }) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/presenca/save');

      final body = jsonEncode({
        'codigo': codigo,
        'usuario': {'id': usuarioId},
        'evento': {'id': eventoId},
        'statusPresenca': statusPresenca,
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

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
      print('Erro ao verificar presença existente: $e');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final codigoIngresso = _gerarCodigoIngresso();
    final preco = evento.precoEntrada.toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Presença Confirmada!'),
        backgroundColor: const Color(0xFFDC143C),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/telaInicial',
              (route) => false,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              '🎉 Presença Confirmada!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.white, Color(0xFFFCE4EC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDC143C),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Text(
                            '❤️ CORAÇÃO GENEROSO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          evento.nome,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: QrImageView(
                            data:
                                'CG-$codigoIngresso-${evento.nome}-${evento.dataEvento}',
                            version: QrVersions.auto,
                            size: 120.0,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow('📅 Data:', evento.dataEvento),
                              _buildInfoRow('⏰ Período:', evento.periodo),
                              _buildInfoRow('📍 Local:', evento.localEvento),
                              _buildInfoRow('💰 Valor:', 'R\$ $preco'),
                              const Divider(),
                              _buildInfoRow('🎫 Código:', codigoIngresso),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Apresente este ingresso na entrada do evento',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();

                      final usuarioId = prefs.getInt('userId');
                      print('=== DEBUG USUARIO ===');
                      print('Usuario ID: $usuarioId');
                      print('Todas as chaves: ${prefs.getKeys()}');

                      if (usuarioId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Usuário não autenticado!'),
                          ),
                        );
                        return;
                      }

                      final eventoId = evento.id;
                      if (eventoId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('ID do evento inválido!'),
                          ),
                        );
                        return;
                      }
                      // Verificar duplicata primeiro
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

                      final sucesso = await marcarPresenca(
                        codigo: codigoIngresso,
                        usuarioId: usuarioId,
                        eventoId: eventoId,
                      );

                      if (sucesso) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Presença confirmada e salva no banco de dados!'),
                            backgroundColor: Colors.green,
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
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Confirmar e Salvar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ingresso compartilhado!'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Compartilhar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC143C),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _mostrarAvaliacaoDialog(BuildContext context, int usuarioId, int eventoId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Avaliar Evento'),
        content: const Text('Que nota você dá para este evento?'),
        actions: List.generate(5, (index) {
          final nota = index + 1;
          return TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final sucesso = await FavoritosService.avaliarEvento(
                eventoId, usuarioId, nota,
              );
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(sucesso 
                    ? 'Evento avaliado e adicionado aos favoritos!' 
                    : 'Erro ao avaliar evento'),
                ),
              );
              
              if (sucesso) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MeusEventosScreen(),
                  ),
                );
              }
            },
            child: Text('$nota ⭐'),
          );
        }),
      ),
    );
  }
}
