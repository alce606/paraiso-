import 'package:flutter/material.dart';

class PoliticaPrivacidadeScreen extends StatelessWidget {
  const PoliticaPrivacidadeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFDC143C);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🔒', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text('Política de Privacidade'),
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
                      child: Text('🔒', style: TextStyle(fontSize: 40)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Política de Privacidade',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
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
                    'Informações que Coletamos',
                    'Coletamos informações que você nos fornece diretamente, como nome, email, gênero e preferências quando você se cadastra em nossa plataforma.',
                    Icons.info_outline,
                    Colors.blue,
                  ),
                  
                  _buildSection(
                    '2',
                    'Como Usamos suas Informações',
                    'Utilizamos suas informações para:\n\n• Processar inscrições em eventos\n• Enviar notificações sobre eventos\n• Melhorar nossos serviços\n• Comunicar atualizações importantes',
                    Icons.settings,
                    Colors.green,
                  ),
                  
                  _buildSection(
                    '3',
                    'Compartilhamento de Informações',
                    'Não vendemos, alugamos ou compartilhamos suas informações pessoais com terceiros, exceto quando necessário para a operação dos eventos ou quando exigido por lei.',
                    Icons.share,
                    Colors.orange,
                  ),
                  
                  _buildSection(
                    '4',
                    'Segurança dos Dados',
                    'Implementamos medidas de segurança adequadas para proteger suas informações contra acesso não autorizado, alteração, divulgação ou destruição.',
                    Icons.security,
                    Colors.red,
                  ),
                  
                  _buildSection(
                    '5',
                    'Seus Direitos',
                    'Você tem o direito de:\n\n✓ Acessar suas informações pessoais\n✓ Corrigir dados incorretos\n✓ Solicitar exclusão de sua conta\n✓ Retirar consentimento a qualquer momento',
                    Icons.account_circle,
                    Colors.purple,
                  ),
                  
                  _buildSection(
                    '6',
                    'Cookies e Tecnologias',
                    'Utilizamos cookies e tecnologias similares para melhorar sua experiência, analisar o uso do aplicativo e personalizar conteúdo.',
                    Icons.cookie,
                    Colors.brown,
                  ),
                  
                  _buildSection(
                    '7',
                    'Retenção de Dados',
                    'Mantemos suas informações pessoais apenas pelo tempo necessário para cumprir os propósitos descritos nesta política ou conforme exigido por lei.',
                    Icons.schedule,
                    Colors.teal,
                  ),
                  
                  _buildSection(
                    '8',
                    'Contato',
                    'Para questões sobre esta política:\n\n📧 privacidade@coracaogeneroso.org\n📱 (11) 99999-9999\n🌐 www.coracaogeneroso.org/privacidade',
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
                        const Text('🛡️', style: TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        const Text(
                          'Sua privacidade é nossa prioridade!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Estamos comprometidos em proteger suas informações pessoais.',
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