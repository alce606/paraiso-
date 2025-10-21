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
import 'widgets/auth_wrapper.dart';

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
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (context) => const LoginScreen());
            case '/signup':
              return MaterialPageRoute(builder: (context) => const SignupScreen());
            case '/telaInicial':
              return MaterialPageRoute(builder: (context) => const AuthWrapper(child: DashboardScreen()));
            case '/perfil':
              return MaterialPageRoute(builder: (context) => const AuthWrapper(child: PerfilScreen()));
            case '/configuracoes':
              return MaterialPageRoute(builder: (context) => const AuthWrapper(child: ConfiguracoesScreen()));
            case '/politica-privacidade':
              return MaterialPageRoute(builder: (context) => const PoliticaPrivacidadeScreen());
            case '/termos-uso':
              return MaterialPageRoute(builder: (context) => const TermosUsoScreen());
            case '/meus-eventos':
              return MaterialPageRoute(builder: (context) => const AuthWrapper(child: MeusEventosScreen()));
            case '/eventos-ativos':
              return MaterialPageRoute(builder: (context) => const AuthWrapper(child: EventosAtivosScreen()));
            case '/favoritos':
              return MaterialPageRoute(builder: (context) => const AuthWrapper(child: FavoritosScreen()));
            case '/historico':
              return MaterialPageRoute(builder: (context) => const AuthWrapper(child: HistoricoScreen()));
            case '/suporte':
              return MaterialPageRoute(builder: (context) => const SuporteScreen());
            case '/feedback':
              return MaterialPageRoute(builder: (context) => const AuthWrapper(child: FeedbackScreen()));
            case '/sobre-nos':
              return MaterialPageRoute(builder: (context) => const SobreNosScreen());
            default:
              return MaterialPageRoute(builder: (context) => const LoginScreen());
          }
        },
          );
        },
      ),
    );
  }
}
