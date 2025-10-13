import 'package:flutter/material.dart';

class HistoricoScreen extends StatelessWidget {
  const HistoricoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFDC143C);
    
    final List<Map<String, dynamic>> historicoEventos = [
      {
        'nome': 'Bazar Solidário 2024',
        'data': '2024-12-15',
        'status': 'Participou',
        'avaliacao': 5,
      },
      {
        'nome': 'Show Beneficente',
        'data': '2024-11-20',
        'status': 'Organizou',
        'avaliacao': 4,
      },
      {
        'nome': 'Almoço de Páscoa',
        'data': '2024-03-31',
        'status': 'Participou',
        'avaliacao': 5,
      },
    ];

    Widget buildStarRating(int rating) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 16,
          );
        }),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('📈', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('Histórico'),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: historicoEventos.isEmpty
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
                    const Text('📄', style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum evento no histórico',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historicoEventos.length,
              itemBuilder: (context, index) {
                final evento = historicoEventos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.white, Color(0xFFFCE4EC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: evento['status'] == 'Organizou' 
                            ? Colors.green 
                            : const Color(0xFFDC143C),
                        child: Text(
                          evento['status'] == 'Organizou' 
                              ? '👨💼' 
                              : '👤',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      title: Text(evento['nome']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('📅 ${evento['data']}'),
                          Text('👤 ${evento['status']}'),
                          const SizedBox(height: 4),
                          buildStarRating(evento['avaliacao']),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(evento['nome']),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Data: ${evento['data']}'),
                                  Text('Status: ${evento['status']}'),
                                  const SizedBox(height: 8),
                                  const Text('Avaliação:'),
                                  buildStarRating(evento['avaliacao']),
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
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}