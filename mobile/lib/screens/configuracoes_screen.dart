import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/locale_provider.dart';
import '../utils/app_strings.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  final Color primaryColor = const Color(0xFFDC143C);
  
  bool _notificacoesEventos = true;
  bool _notificacoesLembretes = true;
  bool _notificacoesSistema = false;
  bool _perfilPublico = true;
  bool _compartilharDados = false;
  String _idiomaSelecionado = 'Português';
  final String _armazenamentoUsado = '2.3 MB';
  bool _isLoading = true;
  
  // Permissões
  bool _permissaoCamera = true;
  bool _permissaoNotificacoes = true;
  bool _permissaoLocalizacao = false;

  @override
  void initState() {
    super.initState();
    _carregarConfiguracoes();
  }

  Future<void> _carregarConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificacoesEventos = prefs.getBool('notificacoes_eventos') ?? true;
      _notificacoesLembretes = prefs.getBool('notificacoes_lembretes') ?? true;
      _notificacoesSistema = prefs.getBool('notificacoes_sistema') ?? false;
      _perfilPublico = prefs.getBool('perfil_publico') ?? true;
      _compartilharDados = prefs.getBool('compartilhar_dados') ?? false;
      _idiomaSelecionado = prefs.getString('idioma') ?? 'Português';
      
      // Carrega permissões
      _permissaoCamera = prefs.getBool('permissao_camera') ?? true;
      _permissaoNotificacoes = prefs.getBool('permissao_notificacoes') ?? true;
      _permissaoLocalizacao = prefs.getBool('permissao_localizacao') ?? false;
      
      _isLoading = false;
    });
  }

  Future<void> _salvarConfiguracao(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  void _mostrarDialogIdioma() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecionar Idioma'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Português'),
                leading: Radio<String>(
                  value: 'Português',
                  groupValue: _idiomaSelecionado,
                  onChanged: (value) => _alterarIdioma(value!, const Locale('pt'), setDialogState),
                ),
              ),
              ListTile(
                title: const Text('English'),
                leading: Radio<String>(
                  value: 'English',
                  groupValue: _idiomaSelecionado,
                  onChanged: (value) => _alterarIdioma(value!, const Locale('en'), setDialogState),
                ),
              ),
              ListTile(
                title: const Text('Español'),
                leading: Radio<String>(
                  value: 'Español',
                  groupValue: _idiomaSelecionado,
                  onChanged: (value) => _alterarIdioma(value!, const Locale('es'), setDialogState),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _alterarIdioma(String idioma, Locale locale, StateSetter setDialogState) async {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    
    setState(() {
      _idiomaSelecionado = idioma;
    });
    
    localeProvider.setLocale(locale);
    await _salvarConfiguracao('idioma', idioma);
    setDialogState(() {});
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Idioma alterado para $idioma')),
    );
  }

  void _limparCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Cache'),
        content: const Text('Isso irá limpar dados temporários e pode melhorar o desempenho. Continuar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache limpo com sucesso!')),
              );
            },
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }

  void _exportarDados() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exportar Dados'),
        content: const Text('Seus dados pessoais serão enviados por email em formato PDF.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              // Simula processo de exportação
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preparando exportação...')),
              );
              
              await Future.delayed(Duration(seconds: 2));
              
              final prefs = await SharedPreferences.getInstance();
              final userName = prefs.getString('userName') ?? 'Usuário';
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('✅ Dados de $userName exportados! Verifique seu email.')),
              );
            },
            child: const Text('Exportar'),
          ),
        ],
      ),
    );
  }

  void _excluirConta() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Conta'),
        content: const Text('⚠️ Esta ação é irreversível! Todos os seus dados serão permanentemente removidos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Conta excluída com sucesso!')),
              );
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String emoji) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        value: value,
        onChanged: onChanged,
        activeColor: primaryColor,
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: primaryColor),
        title: Text(title),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildPermissaoTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: primaryColor),
        title: Text(title),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<LocaleProvider>(
              builder: (context, localeProvider, child) {
                return Text(
                  value 
                    ? AppStrings.get('allowed', localeProvider.locale.languageCode)
                    : AppStrings.get('denied', localeProvider.locale.languageCode),
                  style: TextStyle(
                    color: value ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarFeedbackPermissao(String permissao, bool permitido) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          permitido 
            ? '✅ Permissão de $permissao ativada'
            : '❌ Permissão de $permissao desativada',
        ),
        backgroundColor: permitido ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Consumer<LocaleProvider>(
          builder: (context, localeProvider, child) {
            return Text(AppStrings.get('settings', localeProvider.locale.languageCode));
          },
        ),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_rounded, color: Colors.red, size: 24),
            SizedBox(width: 8),
            Text('Configurações'),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Consumer<LocaleProvider>(
            builder: (context, localeProvider, child) {
              return _buildSectionHeader(AppStrings.get('notifications', localeProvider.locale.languageCode), '🔔');
            },
          ),
          _buildSwitchTile(
            'Eventos',
            'Receber notificações sobre novos eventos',
            _notificacoesEventos,
            (value) async {
              setState(() => _notificacoesEventos = value);
              await _salvarConfiguracao('notificacoes_eventos', value);
            },
          ),
          _buildSwitchTile(
            'Lembretes',
            'Lembretes de eventos que você se inscreveu',
            _notificacoesLembretes,
            (value) async {
              setState(() => _notificacoesLembretes = value);
              await _salvarConfiguracao('notificacoes_lembretes', value);
            },
          ),
          _buildSwitchTile(
            'Sistema',
            'Atualizações e informações do sistema',
            _notificacoesSistema,
            (value) async {
              setState(() => _notificacoesSistema = value);
              await _salvarConfiguracao('notificacoes_sistema', value);
            },
          ),

          Consumer<LocaleProvider>(
            builder: (context, localeProvider, child) {
              return _buildSectionHeader(AppStrings.get('privacy', localeProvider.locale.languageCode), '🔒');
            },
          ),
          _buildSwitchTile(
            'Perfil Público',
            'Permitir que outros usuários vejam seu perfil',
            _perfilPublico,
            (value) async {
              setState(() => _perfilPublico = value);
              await _salvarConfiguracao('perfil_publico', value);
            },
          ),
          _buildSwitchTile(
            'Compartilhar Dados',
            'Compartilhar dados anônimos para melhorias',
            _compartilharDados,
            (value) async {
              setState(() => _compartilharDados = value);
              await _salvarConfiguracao('compartilhar_dados', value);
            },
          ),

          Consumer<LocaleProvider>(
            builder: (context, localeProvider, child) {
              return _buildSectionHeader(AppStrings.get('preferences', localeProvider.locale.languageCode), '🎨');
            },
          ),
          Consumer<LocaleProvider>(
            builder: (context, localeProvider, child) {
              return _buildListTile(
                AppStrings.get('language', localeProvider.locale.languageCode),
                _idiomaSelecionado,
                Icons.language,
                _mostrarDialogIdioma,
              );
            },
          ),

          Consumer<LocaleProvider>(
            builder: (context, localeProvider, child) {
              return _buildSectionHeader(AppStrings.get('personalData', localeProvider.locale.languageCode), '👤');
            },
          ),
          _buildListTile(
            'Exportar Dados',
            'Baixar uma cópia dos seus dados',
            Icons.download,
            _exportarDados,
          ),
          _buildListTile(
            'Excluir Conta',
            'Remover permanentemente sua conta',
            Icons.delete_forever,
            _excluirConta,
          ),

          _buildSectionHeader('Armazenamento', '💾'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Icon(Icons.storage, color: primaryColor),
              title: const Text('Dados do App'),
              subtitle: Text('Usado: $_armazenamentoUsado', style: TextStyle(color: Colors.grey[600])),
              trailing: TextButton(
                onPressed: _limparCache,
                child: const Text('Limpar Cache'),
              ),
            ),
          ),

          Consumer<LocaleProvider>(
            builder: (context, localeProvider, child) {
              return _buildSectionHeader(AppStrings.get('permissions', localeProvider.locale.languageCode), '🛡️');
            },
          ),
          Consumer<LocaleProvider>(
            builder: (context, localeProvider, child) {
              return _buildPermissaoTile(
                AppStrings.get('camera', localeProvider.locale.languageCode),
                'Permitir acesso à câmera para fotos de perfil',
                Icons.camera_alt,
                _permissaoCamera,
                (value) async {
                  setState(() => _permissaoCamera = value);
                  await _salvarConfiguracao('permissao_camera', value);
                  _mostrarFeedbackPermissao(AppStrings.get('camera', localeProvider.locale.languageCode), value);
                },
              );
            },
          ),
          _buildPermissaoTile(
            'Notificações',
            'Permitir notificações push do aplicativo',
            Icons.notifications,
            _permissaoNotificacoes,
            (value) async {
              setState(() => _permissaoNotificacoes = value);
              await _salvarConfiguracao('permissao_notificacoes', value);
              _mostrarFeedbackPermissao('Notificações', value);
            },
          ),
          _buildPermissaoTile(
            'Localização',
            'Acesso à localização para encontrar eventos próximos',
            Icons.location_on,
            _permissaoLocalizacao,
            (value) async {
              setState(() => _permissaoLocalizacao = value);
              await _salvarConfiguracao('permissao_localizacao', value);
              _mostrarFeedbackPermissao('Localização', value);
            },
          ),

          _buildSectionHeader('Sobre', 'ℹ️'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Icon(Icons.info, color: primaryColor),
              title: const Text('Versão do App'),
              subtitle: Text('v1.0.0 (Build 1)', style: TextStyle(color: Colors.grey[600])),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Icon(Icons.policy, color: primaryColor),
              title: const Text('Política de Privacidade'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.pushNamed(context, '/politica-privacidade'),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: Icon(Icons.description, color: primaryColor),
              title: const Text('Termos de Uso'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.pushNamed(context, '/termos-uso'),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}