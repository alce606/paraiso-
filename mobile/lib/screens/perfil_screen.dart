import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario_model.dart';
import '../services/api_service.dart';



class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Usuario? _usuario;
  List<int>? _fotoBytes;

  final Color primaryColor = const Color(0xFFDC143C);
  final TextEditingController _nomeController = TextEditingController(text: 'João Silva');
  final TextEditingController _senhaController = TextEditingController();
  
  bool _obscureSenha = true;
  
  bool _isEditing = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }
  



Future<void> _carregarUsuario() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int userId = prefs.getInt('userId') ?? 0;

  try {
    final usuarioJson = await ApiService.getUsuarioPorId(userId);
    final usuario = Usuario.fromJson(usuarioJson);

    if (mounted) {
      setState(() {
        _usuario = usuario;
        _nomeController.text = usuario.nome;
        _fotoBytes = usuario.foto;
      });
    }
  } catch (e) {
    print('Erro ao carregar usuário: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar dados do perfil')),
      );
    }
  }
}


  void _alterarFoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Alterar Foto do Perfil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('📷 Câmera selecionada!'),
                        backgroundColor: Color(0xFFDC143C),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCE4EC),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, size: 30, color: Color(0xFFDC143C)),
                      ),
                      const SizedBox(height: 8),
                      const Text('Câmera'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🖼️ Galeria selecionada!'),
                        backgroundColor: Color(0xFFDC143C),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCE4EC),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.photo_library, size: 30, color: Color(0xFFDC143C)),
                      ),
                      const SizedBox(height: 8),
                      const Text('Galeria'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _salvarPerfil() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      print('UserId para alterar nome: $userId');
      print('Novo nome: ${_nomeController.text}');
      
      if (userId != null) {
        final dadosAtualizados = {
          'nome': _nomeController.text,
        };
        
        final sucesso = await ApiService.atualizarUsuario(userId, dadosAtualizados);
        print('Resultado alteração nome: $sucesso');
        
        if (sucesso) {
          // Atualiza dados locais
          await prefs.setString('userName', _nomeController.text);
          
          setState(() {
            _isEditing = false;
          });
          
          // Força recarregar dados do servidor
          await Future.delayed(Duration(milliseconds: 500));
          await _carregarUsuario();
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Perfil atualizado com sucesso!'),
              backgroundColor: Color(0xFFDC143C),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao atualizar perfil')),
          );
        }
      } else {
        print('UserId é null!');
      }
    } catch (e) {
      print('Erro ao salvar perfil: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar perfil')),
      );
    }
  }
  
  void _salvarSenha() async {
    if (_senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite uma nova senha')),
      );
      return;
    }
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      print('UserId para alterar senha: $userId');
      print('Nova senha: ${_senhaController.text}');
      
      if (userId != null) {
        final sucesso = await ApiService.alterarSenha(userId, _senhaController.text);
        print('Resultado alteração senha: $sucesso');
        
        if (sucesso) {
          _senhaController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Senha alterada com sucesso!'),
              backgroundColor: Color(0xFFDC143C),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao alterar senha')),
          );
        }
      }
    } catch (e) {
      print('Erro ao alterar senha: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao alterar senha')),
      );
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
            Text('Meu Perfil'),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _isEditing ? _salvarPerfil : () => setState(() => _isEditing = true),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header acolhedor
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.white, Color(0xFFFCE4EC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    '👋 Olá!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Que bom ter você aqui! Vamos manter seu perfil sempre atualizado.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Foto do perfil
            GestureDetector(
              onTap: _alterarFoto,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(220, 20, 60, 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: const Color(0xFFFCE4EC),
                      child: const Text('👤', style: TextStyle(fontSize: 60)),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(0, 0, 0, 0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Informações do perfil
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: Color(0xFFDC143C)),
                        const SizedBox(width: 8),
                        const Text(
                          'Nome Completo',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        if (_isEditing)
                          const Icon(Icons.edit, size: 16, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nomeController,
                      enabled: _isEditing,
                      decoration: InputDecoration(
                        border: _isEditing ? const OutlineInputBorder() : InputBorder.none,
                        filled: !_isEditing,
                        fillColor: Colors.grey[50],
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        color: _isEditing ? Colors.black : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Campo de senha compacto
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.lock, color: Color(0xFFDC143C)),
                    const SizedBox(width: 8),
                    const Text('Nova Senha:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _senhaController,
                        obscureText: _obscureSenha,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          hintText: 'Digite nova senha',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _obscureSenha = !_obscureSenha),
                      icon: Icon(
                        _obscureSenha ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFFDC143C),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _salvarSenha,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC143C),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Ações rápidas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '⚙️ Ações Rápidas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  

                  
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCE4EC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.notifications, color: Color(0xFFDC143C)),
                    ),
                    title: const Text('Notificações'),
                    subtitle: const Text('Gerencie suas preferências'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pushNamed(context, '/configuracoes');
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}