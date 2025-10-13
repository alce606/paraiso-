import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/configuracoes_screen.dart';
import 'screens/politica_privacidade_screen.dart';
import 'screens/termos_uso_screen.dart';
import 'screens/meus_eventos_screen.dart';
import 'screens/eventos_ativos_screen.dart';
import 'screens/favoritos_screen.dart';
import 'screens/historico_screen.dart';
import 'screens/suporte_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/sobre_nos_screen.dart';
import 'services/http_service.dart';
import 'services/authService.dart';
import 'providers/auth_provider.dart';
import 'providers/evento_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/evento_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar serviços
  HttpService().initialize();
  await AuthService().initialize();

  // Inicializar provider de idioma
  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  // Inicializar EventoProvider com polling
  final eventoProvider = EventoProvider();
  eventoProvider.startPolling();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider.value(value: eventoProvider),
        ChangeNotifierProvider.value(value: localeProvider),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'CORAÇÃO GENEROSO',
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale,
        theme: ThemeData(
          primaryColor: const Color(0xFFD32F2F),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFD32F2F),
            foregroundColor: Colors.white,
            elevation: 3,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD32F2F)),
            ),
            labelStyle: TextStyle(color: Color(0xFF616161)),
            floatingLabelStyle: TextStyle(color: Color(0xFFD32F2F)),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFD32F2F),
            selectionColor: Color(0xFFFFCDD2),
            selectionHandleColor: Color(0xFFD32F2F),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/telaInicial': (context) => const DashboardScreen(),
          '/perfil': (context) => const PerfilScreen(),
          '/configuracoes': (context) => const ConfiguracoesScreen(),
          '/politica-privacidade': (context) => const PoliticaPrivacidadeScreen(),
          '/termos-uso': (context) => const TermosUsoScreen(),
          '/meus-eventos': (context) => const MeusEventosScreen(),
          '/eventos-ativos': (context) => const EventosAtivosScreen(),
          '/favoritos': (context) => const FavoritosScreen(),
          '/historico': (context) => const HistoricoScreen(),
          '/suporte': (context) => const SuporteScreen(),
          '/feedback': (context) => const FeedbackScreen(),
          '/sobre-nos': (context) => const SobreNosScreen(),
        },
          );
        },
      ),
    );
  }
}
