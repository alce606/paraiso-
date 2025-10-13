class EventosData {
  static final List<Map<String, dynamic>> eventos = [
    {
      'id': 1,
      'nome': 'Bazari de Natal',
      'descricao': 'Bazar beneficente especial de Natal com roupas, brinquedos, livros e artesanatos. Toda a renda será destinada para famílias carentes da comunidade. Venha participar desta ação solidária e ajude a tornar o Natal de muitas crianças mais feliz!',
      'localEvento': 'Centro Comunitário',
      'dataEvento': '2025-12-10',
      'periodo': 'Manhã',
      'preco': 10.00,
      'categoria': 'Bazar',
      'vagas': 50,
      'statusEvento': 'ATIVO',
    },
    {
      'id': 2,
      'nome': 'Show de Rock',
      'descricao': 'Show de rock beneficente com as melhores bandas locais da região. Uma noite inesquecível de música e solidariedade para arrecadar fundos para o projeto de música para jovens em situação de vulnerabilidade social.',
      'localEvento': 'Arena Municipal',
      'dataEvento': '2025-08-15',
      'periodo': 'Noite',
      'preco': 50.00,
      'categoria': 'Show',
      'vagas': 200,
      'statusEvento': 'ATIVO',
    },
    {
      'id': 3,
      'nome': 'Almoço Comunitário',
      'descricao': 'Almoço solidário aberto para toda a comunidade. Um momento de confraternização e união, onde compartilhamos não apenas uma refeição, mas também histórias, sorrisos e esperança. Todos são bem-vindos!',
      'localEvento': 'Parque Central',
      'dataEvento': '2025-09-01',
      'periodo': 'Tarde',
      'preco': 15.00,
      'categoria': 'Almoço',
      'vagas': 100,
      'statusEvento': 'ATIVO',
    },
  ];

  static final List<String> menuOptions = [
    'Perfil',
    'Meus Eventos',
    'Meus Ingressos',
    'Favoritos',
    'Histórico',
    'Dar Meu Feedback',
    'Suporte',
    'Configurações',
    'Sobre Nós'
  ];
}