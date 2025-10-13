class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final String? nivelAcesso;
  final List<int>? foto; // Representa byte[] como List<int> em Dart
  final String? dataCadastro;
  final String statusUsuario;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.nivelAcesso,
    this.foto,
    this.dataCadastro,
    required this.statusUsuario,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
      nivelAcesso: json['nivelAcesso'],
      foto: json['foto'] != null ? List<int>.from(json['foto']) : null,
      dataCadastro: json['dataCadastro'],
      statusUsuario: json['statusUsuario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      if (nivelAcesso != null) 'nivelAcesso': nivelAcesso,
      if (foto != null) 'foto': foto,
      if (dataCadastro != null) 'dataCadastro': dataCadastro,
      'statusUsuario': statusUsuario,
    };
  }
}
