import 'package:flutter/material.dart';

class SuporteScreen extends StatefulWidget {
  const SuporteScreen({super.key});

  @override
  State<SuporteScreen> createState() => _SuporteScreenState();
}

class _SuporteScreenState extends State<SuporteScreen> {
  final Color primaryColor = const Color(0xFFDC143C);
  final TextEditingController _mensagemController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  
  List<Map<String, dynamic>> mensagens = [
    {
      'id': 1,
      'emissor': 'IA',
      'texto': '👋 Olá! Sou a assistente virtual do Coração Generoso. Como posso ajudar você hoje?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 1)),
    },
  ];

  final Map<String, String> respostasIA = {
    'evento': '📅 Para participar de um evento, vá em "Início", encontre o evento desejado e clique nele. Você verá todas as informações e poderá se inscrever!',
    'inscrever': '✅ Para se inscrever em eventos: 1) Acesse a tela inicial, 2) Escolha um evento, 3) Clique em "Participar". É simples assim!',
    'cancelar': '❌ Para cancelar sua participação: vá em "Meus Eventos" no menu lateral e clique no evento que deseja cancelar.',
    'perfil': '👤 Para editar seu perfil: acesse "Perfil" no menu lateral. Lá você pode alterar foto, nome, descrição e senha.',
    'favoritos': '❤️ Para favoritar eventos: clique no ícone de coração nos eventos que você gosta. Eles aparecerão na aba "Favoritos".',
    'histórico': '📊 Seu histórico de eventos fica em "Histórico" no menu lateral. Lá você vê todos os eventos que já participou.',
    'senha': '🔒 Para alterar sua senha: vá em "Perfil" > seção "Alterar Senha". Digite a senha atual e a nova senha.',
    'problema': '🔧 Se está com problemas técnicos, tente: 1) Fechar e abrir o app, 2) Verificar sua conexão, 3) Atualizar o app.',
    'contato': '📞 Para falar com nossa equipe: use este chat ou envie email para contato@coracaogeneroso.org',
  };

  @override
  void dispose() {
    _mensagemController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _gerarRespostaIA(String mensagem) {
    final msgLower = mensagem.toLowerCase();
    
    for (String key in respostasIA.keys) {
      if (msgLower.contains(key)) {
        return respostasIA[key]!;
      }
    }
    
    if (msgLower.contains('olá') || msgLower.contains('oi')) {
      return '👋 Olá! Estou aqui para ajudar. Você pode me perguntar sobre eventos, inscrições, perfil ou qualquer dúvida!';
    }
    
    if (msgLower.contains('obrigad')) {
      return '😊 De nada! Fico feliz em ajudar. Há mais alguma coisa que posso esclarecer?';
    }
    
    return '🤔 Entendi sua dúvida! Posso ajudar com:\n\n📅 Eventos e inscrições\n👤 Perfil e configurações\n❤️ Favoritos e histórico\n🔒 Problemas de senha\n\nSobre o que você gostaria de saber?';
  }

  void _enviarMensagem() {
    final texto = _mensagemController.text.trim();
    if (texto.isEmpty || _isTyping) return;
    
    setState(() {
      mensagens.add({
        'id': mensagens.length + 1,
        'emissor': 'Usuário',
        'texto': texto,
        'timestamp': DateTime.now(),
      });
      _mensagemController.clear();
      _isTyping = true;
    });
    
    _scrollToBottom();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        final resposta = _gerarRespostaIA(texto);
        setState(() {
          mensagens.add({
            'id': mensagens.length + 1,
            'emissor': 'IA',
            'texto': resposta,
            'timestamp': DateTime.now(),
          });
          _isTyping = false;
        });
        _scrollToBottom();
      }
    });
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
            Text('Assistente IA'),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                mensagens = [
                  {
                    'id': 1,
                    'emissor': 'IA',
                    'texto': '👋 Olá! Sou a assistente virtual do Coração Generoso. Como posso ajudar você hoje?',
                    'timestamp': DateTime.now(),
                  },
                ];
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.green[50],
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Assistente IA Online', style: TextStyle(fontSize: 12)),
                const Spacer(),
                if (_isTyping) 
                  const Row(
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('IA digitando...', style: TextStyle(fontSize: 12)),
                    ],
                  ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: mensagens.length,
              itemBuilder: (context, i) {
                final msg = mensagens[i];
                final isIA = msg['emissor'] == 'IA';
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  alignment: isIA ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: isIA ? const LinearGradient(
                        colors: [Colors.white, Color(0xFFFCE4EC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ) : null,
                      color: isIA ? null : primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isIA ? 4 : 20),
                        bottomRight: Radius.circular(isIA ? 20 : 4),
                      ),
                      boxShadow: [
                        const BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isIA)
                          Row(
                            children: [
                              const Text('🤖', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 4),
                              Text(
                                'Assistente IA',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        if (isIA) const SizedBox(height: 4),
                        Text(
                          msg['texto'],
                          style: TextStyle(
                            color: isIA ? Colors.black87 : Colors.white,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                const BoxShadow(
                  color: Color.fromRGBO(158, 158, 158, 0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _mensagemController,
                    decoration: InputDecoration(
                      hintText: 'Pergunte algo para a IA...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, 
                        vertical: 12,
                      ),
                      prefixIcon: const Icon(Icons.chat_bubble_outline),
                    ),
                    onSubmitted: (_) => _enviarMensagem(),
                    enabled: !_isTyping,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isTyping ? null : _enviarMensagem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}