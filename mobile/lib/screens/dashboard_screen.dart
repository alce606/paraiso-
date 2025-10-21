import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/global_search_bar.dart';
import '../widgets/info_section_widget.dart';
import '../widgets/dashboard_eventos_vitrine.dart';
import '../widgets/dashboard_footer.dart';
import '../services/search_service.dart';
import '../utils/dashboard_navigation.dart';
import '../models/evento_model.dart';
import '../providers/evento_provider.dart';
import 'detalhes_evento_screen.dart';
import 'meus_eventos_screen.dart';
import 'eventos_ativos_screen.dart';
import 'favoritos_screen.dart';
import 'historico_screen.dart';
import 'feedback_screen.dart';
import 'suporte_screen.dart';
import 'configuracoes_screen.dart';
import 'sobre_nos_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Color primaryColor = const Color(0xFFD32F2F);
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Carregar eventos ao inicializar a tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventoProvider = Provider.of<EventoProvider>(context, listen: false);
      eventoProvider.loadTodosEnventos();
      eventoProvider.startPolling();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchResults() {
    final results = SearchService.getFilteredResults(_searchQuery, []);
    
    if (results.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
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
          children: [
            const Text('🔍', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'Nenhum resultado encontrado para "$_searchQuery"',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resultados da pesquisa',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ...results.map((result) {
            if (result['type'] == 'menu') {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(DashboardNavigation.getMenuIcon(result['name']), color: primaryColor),
                  title: Text(result['name']),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => DashboardNavigation.navigateToMenu(context, result['name']),
                ),
              );
            } else {
              final evento = result as Evento;
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: primaryColor,
                    child: const Icon(Icons.event, color: Colors.white),
                  ),
                  title: Text(evento.nome),
                  subtitle: Text(evento.localEvento),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalhesEventoScreen(evento: evento),
                    ),
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
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
            Text('CORAÇÃO GENEROSO'),
          ],
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD32F2F), Color.fromRGBO(211, 47, 47, 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('❤️', style: TextStyle(fontSize: 50)),
                  SizedBox(height: 8),
                  Text(
                    'CORAÇÃO GENEROSO',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Bem-vindo!',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFFCE4EC),
              ),
              child: ListTile(
                leading: const Icon(Icons.home, color: Color(0xFFD32F2F)),
                title: const Text('Início'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () => Navigator.pop(context),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[50],
              ),
              child: ListTile(
                leading: const Icon(Icons.person, color: Color(0xFFD32F2F)),
                title: const Text('Perfil'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/perfil');
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[50],
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Color(0xFFD32F2F)),
                title: const Text('Eventos Disponíveis'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EventosAtivosScreen()));
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[50],
              ),
              child: ListTile(
                leading: const Icon(Icons.event, color: Color(0xFFD32F2F)),
                title: const Text('Meus Eventos'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MeusEventosScreen()));
                },
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[50],
              ),
              child: ListTile(
                leading: const Icon(Icons.favorite, color: Color(0xFFD32F2F)),
                title: const Text('Favoritos'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritosScreen()));
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[50],
              ),
              child: ListTile(
                leading: const Icon(Icons.history, color: Color(0xFFD32F2F)),
                title: const Text('Histórico'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoricoScreen()));
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[50],
              ),
              child: ListTile(
                leading: const Icon(Icons.rate_review, color: Color(0xFFD32F2F)),
                title: const Text('Dar Meu Feedback'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackScreen()));
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[50],
              ),
              child: ListTile(
                leading: const Icon(Icons.support_agent, color: Color(0xFFD32F2F)),
                title: const Text('Suporte'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SuporteScreen()));
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[50],
              ),
              child: ListTile(
                leading: const Icon(Icons.settings, color: Color(0xFFD32F2F)),
                title: const Text('Configurações'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfiguracoesScreen()));
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[50],
              ),
              child: ListTile(
                leading: const Icon(Icons.info, color: Color(0xFFD32F2F)),
                title: const Text('Sobre Nós'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SobreNosScreen()));
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.red[50],
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Sair', style: TextStyle(color: Colors.red)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () async {
                  Navigator.pop(context);
                  // Limpar dados de sessão
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.remove('userId');
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const GlobalSearchBar(),
            InfoSectionWidget(primaryColor: primaryColor),
            Consumer<EventoProvider>(
              builder: (context, eventoProvider, child) {
                if (eventoProvider.isLoading) {
                  return Container(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: primaryColor),
                          SizedBox(height: 16),
                          Text('Carregando eventos...'),
                        ],
                      ),
                    ),
                  );
                }
                
                if (eventoProvider.error != null) {
                  return Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 48),
                        SizedBox(height: 8),
                        Text('Erro ao carregar eventos'),
                        Text(eventoProvider.error!, style: TextStyle(fontSize: 12)),
                        ElevatedButton(
                          onPressed: () => eventoProvider.loadTodosEnventos(),
                          child: Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  );
                }
                
                print('Eventos no dashboard: ${eventoProvider.eventos.length}');
                
                return DashboardEventosVitrine(
                  primaryColor: primaryColor,
                  eventos: eventoProvider.eventos,
                );
              },
            ),
            DashboardFooter(primaryColor: primaryColor),
          ],
        ),
      ),
    );
  }
}