import 'package:flutter/material.dart';
import 'ingresso_screen.dart';
import '../models/evento_model.dart';

class DetalhesEventoScreen extends StatelessWidget {
  final Evento evento;

  const DetalhesEventoScreen({super.key, required this.evento});

  IconData getEventIcon(String nome) {
    if (nome.toLowerCase().contains('bazar')) return Icons.shopping_bag;
    if (nome.toLowerCase().contains('show') || nome.toLowerCase().contains('rock')) return Icons.music_note;
    if (nome.toLowerCase().contains('almoço') || nome.toLowerCase().contains('comida')) return Icons.restaurant;
    if (nome.toLowerCase().contains('workshop') || nome.toLowerCase().contains('arte')) return Icons.palette;
    if (nome.toLowerCase().contains('feira') || nome.toLowerCase().contains('adoção')) return Icons.pets;
    return Icons.event;
  }

  void _participarEvento(BuildContext context) {
    String metodoPagamento = evento.precoEntrada == 0 ? 'gratuito' : 'pago';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IngressoScreen(evento: evento, metodoPagamento: metodoPagamento),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(evento.nome),
        backgroundColor: const Color(0xFFDC143C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0xFFFCE4EC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC143C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        getEventIcon(evento.nome),
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      evento.nome,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC143C).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        evento.categoria.nome,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFDC143C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Descrição',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      evento.descricao,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Informações do Evento',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(Icons.location_on, 'Local', evento.localEvento),
                  const SizedBox(height: 12),
                  _buildInfoCard(Icons.calendar_today, 'Data', evento.dataEvento),
                  const SizedBox(height: 12),
                  _buildInfoCard(Icons.access_time, 'Período', evento.periodo),
                  const SizedBox(height: 12),
                  _buildInfoCard(Icons.people, 'Participantes', '${evento.totalParticipantes} inscritos'),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    Icons.attach_money, 
                    'Valor', 
                    evento.precoEntrada == 0 ? 'GRATUITO' : 'R\$ ${evento.precoEntrada.toStringAsFixed(2)}'
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _participarEvento(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC143C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Participar do Evento',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFFCE4EC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFDC143C),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}