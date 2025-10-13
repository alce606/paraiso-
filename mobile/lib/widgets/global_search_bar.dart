import 'package:flutter/material.dart';

class GlobalSearchBar extends StatefulWidget {
  const GlobalSearchBar({super.key});

  @override
  State<GlobalSearchBar> createState() => _GlobalSearchBarState();
}

class _GlobalSearchBarState extends State<GlobalSearchBar> {
  final TextEditingController _controller = TextEditingController();
  List<SearchItem> _filteredItems = [];
  bool _showSuggestions = false;

  final List<SearchItem> _allItems = [
    SearchItem('Perfil', 'Meu perfil e configurações pessoais', Icons.person, '/perfil'),
    SearchItem('Configurações', 'Ajustes e preferências do app', Icons.settings, '/configuracoes'),
    SearchItem('Meus Eventos', 'Eventos confirmados e avaliações', Icons.event, '/meus-eventos'),
    SearchItem('Dashboard', 'Tela principal com eventos', Icons.dashboard, '/telaInicial'),
    SearchItem('Política de Privacidade', 'Termos de privacidade', Icons.privacy_tip, '/politica-privacidade'),
    SearchItem('Termos de Uso', 'Condições de uso do app', Icons.description, '/termos-uso'),
    SearchItem('Eventos Ativos', 'Ver todos os eventos disponíveis', Icons.event_available, '/eventos-ativos'),
    SearchItem('Favoritos', 'Seus eventos favoritos', Icons.favorite, '/favoritos'),
    SearchItem('Histórico', 'Histórico de participações', Icons.history, '/historico'),
    SearchItem('Suporte', 'Central de ajuda e suporte', Icons.help, '/suporte'),
    SearchItem('Feedback', 'Enviar comentários e sugestões', Icons.feedback, '/feedback'),
    SearchItem('Sobre Nós', 'Informações sobre o app', Icons.info, '/sobre-nos'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = [];
        _showSuggestions = false;
      } else {
        _filteredItems = _allItems
            .where((item) =>
                item.title.toLowerCase().contains(query.toLowerCase()) ||
                item.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
        _showSuggestions = true;
      }
    });
  }

  void _navigateToScreen(String route) {
    setState(() {
      _showSuggestions = false;
      _controller.clear();
    });
    
    try {
      Navigator.pushNamed(context, route);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tela "$route" não encontrada')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Pesquisar telas, configurações...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: _onSearchChanged,
          ),
        ),
        
        // Sugestões de navegação
        if (_showSuggestions && _filteredItems.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredItems.length > 5 ? 5 : _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return ListTile(
                  leading: Icon(item.icon, color: const Color(0xFFDC143C)),
                  title: Text(item.title),
                  subtitle: Text(
                    item.description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _navigateToScreen(item.route),
                );
              },
            ),
          ),
      ],
    );
  }
}

class SearchItem {
  final String title;
  final String description;
  final IconData icon;
  final String route;

  SearchItem(this.title, this.description, this.icon, this.route);
}