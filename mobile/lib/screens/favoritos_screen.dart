import 'package:flutter/material.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> with SingleTickerProviderStateMixin {
  final Color primaryColor = const Color(0xFFDC143C);
  late TabController _tabController;

  List<Map<String, dynamic>> eventosFavoritos = [
    {
      'id': 1,
      'nome': 'Bazar de Natal',
      'data': '2025-12-10',
      'local': 'Centro Comunitário',
      'preco': 10.00,
      'categoria': 'Bazar',
      'avaliacao': 4.8,
      'participantes': 150,
    },
    {
      'id': 2,
      'nome': 'Almoço Comunitário',
      'data': '2025-09-01',
      'local': 'Parque Central',
      'preco': 15.00,
      'categoria': 'Almoço',
      'avaliacao': 4.5,
      'participantes': 200,
    },
  ];

  List<Map<String, dynamic>> rankingEventos = [
    {
      'posicao': 1,
      'nome': 'Show Beneficente 2024',
      'categoria': 'Show',
      'avaliacao': 4.9,
      'participantes': 500,
    },
    {
      'posicao': 2,
      'nome': 'Bazar de Natal',
      'categoria': 'Bazar',
      'avaliacao': 4.8,
      'participantes': 350,
    },
    {
      'posicao': 3,
      'nome': 'Almoço Solidário',
      'categoria': 'Almoço',
      'avaliacao': 4.7,
      'participantes': 280,
    },
    {
      'posicao': 4,
      'nome': 'Workshop de Arte',
      'categoria': 'Workshop',
      'avaliacao': 4.6,
      'participantes': 120,
    },
    {
      'posicao': 5,
      'nome': 'Feira de Adoção',
      'categoria': 'Feira',
      'avaliacao': 4.5,
      'participantes': 180,
    },
  ];

  List<Map<String, dynamic>> rankingCategorias = [
    {
      'posicao': 1,
      'categoria': 'Show',
      'eventos': 8,
      'avaliacaoMedia': 4.7,
      'emoji': '🎵',
    },
    {
      'posicao': 2,
      'categoria': 'Bazar',
      'eventos': 12,
      'avaliacaoMedia': 4.5,
      'emoji': '🛍️',
    },
    {
      'posicao': 3,
      'categoria': 'Almoço',
      'eventos': 15,
      'avaliacaoMedia': 4.4,
      'emoji': '🍽️',
    },
    {
      'posicao': 4,
      'categoria': 'Workshop',
      'eventos': 6,
      'avaliacaoMedia': 4.3,
      'emoji': '🎨',
    },
    {
      'posicao': 5,
      'categoria': 'Feira',
      'eventos': 4,
      'avaliacaoMedia': 4.2,
      'emoji': '🏪',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _removerFavorito(int eventoId) {
    setState(() {
      eventosFavoritos.removeWhere((e) => e['id'] == eventoId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removido dos favoritos!')),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  Widget _buildFavoritosTab() {
    if (eventosFavoritos.isEmpty) {
      return Center(
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
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('💔', style: TextStyle(fontSize: 64)),
              SizedBox(height: 16),
              Text(
                'Nenhum evento favoritado',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Toque no coração dos eventos para adicioná-los aqui',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: eventosFavoritos.length,
      itemBuilder: (context, index) {
        final evento = eventosFavoritos[index];
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        evento['nome'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => _removerFavorito(evento['id']),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(evento['data']),
                    const SizedBox(width: 16),
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(child: Text(evento['local'])),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.category, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(evento['categoria']),
                    const SizedBox(width: 16),
                    const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('R\$ ${evento['preco'].toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildStarRating(evento['avaliacao']),
                    const SizedBox(width: 8),
                    Text('${evento['avaliacao']}'),
                    const Spacer(),
                    Text('${evento['participantes']} participantes'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRankingEventosTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rankingEventos.length,
      itemBuilder: (context, index) {
        final evento = rankingEventos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getPosicaoColor(evento['posicao']),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${evento['posicao']}°',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              evento['nome'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Categoria: ${evento['categoria']}'),
                Row(
                  children: [
                    _buildStarRating(evento['avaliacao']),
                    const SizedBox(width: 8),
                    Text('${evento['avaliacao']}'),
                  ],
                ),
              ],
            ),
            trailing: Text(
              '${evento['participantes']}\nparticipantes',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRankingCategoriasTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rankingCategorias.length,
      itemBuilder: (context, index) {
        final categoria = rankingCategorias[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getPosicaoColor(categoria['posicao']),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${categoria['posicao']}°',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                Text(categoria['emoji'], style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  categoria['categoria'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${categoria['eventos']} eventos realizados'),
                Row(
                  children: [
                    _buildStarRating(categoria['avaliacaoMedia']),
                    const SizedBox(width: 8),
                    Text('${categoria['avaliacaoMedia']} média'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getPosicaoColor(int posicao) {
    switch (posicao) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_rounded, color: Colors.red, size: 24),
            SizedBox(width: 8),
            Text('Favoritos'),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Favoritos'),
            Tab(text: 'Top Eventos'),
            Tab(text: 'Top Categorias'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFavoritosTab(),
          _buildRankingEventosTab(),
          _buildRankingCategoriasTab(),
        ],
      ),
    );
  }
}