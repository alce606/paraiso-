import 'package:flutter/material.dart';
import '../screens/meus_eventos_screen.dart';
import '../screens/configuracoes_screen.dart';
import '../screens/sobre_nos_screen.dart';
import '../screens/favoritos_screen.dart';
import '../screens/historico_screen.dart';

import '../screens/feedback_screen.dart';
import '../screens/suporte_screen.dart';

class DashboardNavigation {
  static IconData getMenuIcon(String menuName) {
    switch (menuName) {
      case 'Perfil': return Icons.person;
      case 'Meus Eventos': return Icons.event;

      case 'Favoritos': return Icons.favorite;
      case 'Histórico': return Icons.history;
      case 'Dar Meu Feedback': return Icons.rate_review;
      case 'Suporte': return Icons.support_agent;
      case 'Configurações': return Icons.settings;
      case 'Sobre Nós': return Icons.info;
      default: return Icons.menu;
    }
  }

  static void navigateToMenu(BuildContext context, String menuName) {
    switch (menuName) {
      case 'Perfil1':
        Navigator.pushNamed(context, '/perfil');
        break;
      case 'Meus Eventos':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MeusEventosScreen()));
        break;

      case 'Favoritos':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritosScreen()));
        break;
      case 'Histórico':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoricoScreen()));
        break;
      case 'Dar Meu Feedback':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackScreen()));
        break;
      case 'Suporte':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SuporteScreen()));
        break;
      case 'Configurações':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfiguracoesScreen()));
        break;
      case 'Sobre Nós':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SobreNosScreen()));
        break;
    }
  }
}