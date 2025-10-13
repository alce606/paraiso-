import 'package:flutter/material.dart';

class SobreNosScreen extends StatelessWidget {
  const SobreNosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFDC143C);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_rounded, color: Colors.red, size: 24),
            SizedBox(width: 8),
            Text('Sobre Nós'),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com logo
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('❤️', style: TextStyle(fontSize: 50)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'CORAÇÃO GENEROSO',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Transformando vidas através da solidariedade',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Nossa Missão
            Card(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFFCE4EC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('🎯', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(
                          'Nossa Missão',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nossa missão é dar visibilidade às pessoas em situação de vulnerabilidade social e fortalecer nossa organização para alcançar cada vez mais pessoas que precisam de apoio.',
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Acreditamos que através de eventos solidários e ações comunitárias, podemos construir uma sociedade mais justa e igualitária, onde todos tenham oportunidades de crescer e prosperar.',
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Nossos Valores
            Card(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFFCE4EC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('⭐', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(
                          'Nossos Valores',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text('🤝', style: TextStyle(fontSize: 32)),
                              const SizedBox(height: 8),
                              const Text(
                                'Solidariedade',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Apoio mútuo e compaixão',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text('🌟', style: TextStyle(fontSize: 32)),
                              const SizedBox(height: 8),
                              const Text(
                                'Transparência',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Clareza em nossas ações',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text('💪', style: TextStyle(fontSize: 32)),
                              const SizedBox(height: 8),
                              const Text(
                                'Compromisso',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Dedicação à causa',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Nossa Equipe
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('👥', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(
                          'Nossa Equipe',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Contamos com uma equipe dedicada de voluntários e profissionais comprometidos com nossa causa:',
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey[300],
                                  child: const Text('👩', style: TextStyle(fontSize: 25)),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Isabella Marques',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Gerente',
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey[300],
                                  child: const Text('👨', style: TextStyle(fontSize: 25)),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Pedro Henrique',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Designer',
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey[300],
                                  child: const Text('👩', style: TextStyle(fontSize: 25)),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Nicolly Costa',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Time Scrum',
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey[300],
                                  child: const Text('👩', style: TextStyle(fontSize: 25)),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Rafaella Kolle',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Time Scrum',
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey[300],
                                  child: const Text('👨', style: TextStyle(fontSize: 25)),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Guilherme Felix',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Time Scrum',
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey[300],
                                  child: const Text('👨', style: TextStyle(fontSize: 25)),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Arthur Silva',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Designer',
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Estatísticas
            Card(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFFCE4EC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('📊', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(
                          'Nosso Impacto',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              '500+',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const Text('Voluntários'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '50+',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const Text('Eventos'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '2000+',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const Text('Pessoas Ajudadas'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Contato
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('📞', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(
                          'Entre em Contato',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Quer fazer parte da nossa missão? Entre em contato conosco:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    const Text('📧 contato@coracaogeneroso.org'),
                    const Text('📱 (11) 99999-9999'),
                    const Text('📍 São Paulo, SP'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}