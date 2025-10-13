import 'package:flutter/material.dart';

class TermosUsoScreen extends StatelessWidget {
  const TermosUsoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFDC143C);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('📋', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('Termos de Uso'),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header decorativo
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('📋', style: TextStyle(fontSize: 40)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Termos de Uso',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Última atualização: Janeiro 2025',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSection(
                    '1',
                    'Aceitação dos Termos',
                    'Ao usar o aplicativo Coração Generoso, você concorda com estes termos de uso. Se não concordar, não utilize nossos serviços.',
                    Icons.check_circle,
                    Colors.green,
                  ),
                  
                  _buildSection(
                    '2',
                    'Uso Permitido',
                    'Você pode usar nosso aplicativo para:\n\n✓ Visualizar eventos beneficentes\n✓ Inscrever-se em eventos\n✓ Gerenciar seu perfil\n✓ Interagir com nossa comunidade de forma respeitosa',
                    Icons.thumb_up,
                    Colors.blue,
                  ),
                  
                  _buildSection(
                    '3',
                    'Uso Proibido',
                    'É proibido:\n\n✗ Usar o aplicativo para fins ilegais\n✗ Compartilhar conteúdo ofensivo\n✗ Tentar hackear ou comprometer a segurança\n✗ Criar múltiplas contas falsas',
                    Icons.block,
                    Colors.red,
                  ),
                  
                  _buildSection(
                    '4',
                    'Responsabilidades do Usuário',
                    'Você é responsável por:\n\n• Manter suas informações atualizadas\n• Proteger suas credenciais de acesso\n• Comparecer aos eventos confirmados\n• Seguir as regras dos eventos',
                    Icons.person_outline,
                    Colors.orange,
                  ),
                  
                  _buildSection(
                    '5',
                    'Cancelamento de Eventos',
                    'Reservamo-nos o direito de cancelar eventos por motivos de força maior. Participantes serão notificados com antecedência quando possível.',
                    Icons.event_busy,
                    Colors.purple,
                  ),
                  
                  _buildSection(
                    '6',
                    'Modificações',
                    'Podemos modificar estes termos a qualquer momento. Mudanças significativas serão comunicadas através do aplicativo.',
                    Icons.update,
                    Colors.teal,
                  ),
                  
                  _buildSection(
                    '7',
                    'Contato',
                    'Para dúvidas sobre estes termos:\n\n📧 termos@coracaogeneroso.org\n📱 (11) 99999-9999\n🌐 www.coracaogeneroso.org',
                    Icons.contact_support,
                    const Color(0xFFDC143C),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Footer
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
                        const Text('❤️', style: TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        const Text(
                          'Obrigado por fazer parte da nossa comunidade!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Juntos, fazemos a diferença na vida de muitas pessoas.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String number, String title, String content, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}