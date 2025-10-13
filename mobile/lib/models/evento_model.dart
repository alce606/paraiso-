import 'dart:convert';
import 'package:tcc/models/categoria_model.dart';
import 'package:tcc/models/usuario_model.dart';

class Evento {
  final int? id;
  final String nome;
  final String descricao;
  final String localEvento;
  final String cep;
  final String numero;
  final String complemento;
  final String dataEvento; // String para data (pode ser alterado para DateTime se necessário)
  final String horaEvento;
  final String periodo;
  final List<int>? foto; // Representa o byte[] como List<int> em Dart
  final double precoEntrada;
  final int totalParticipantes;
  final String dataCadastro; // String para data/hora
  final Usuario usuario; // Supondo que você já tenha a classe Usuario
  final Categoria categoria; // Supondo que você já tenha a classe Categoria
  final String statusEvento;

  Evento({
    this.id,
    required this.nome,
    required this.descricao,
    required this.localEvento,
    required this.cep,
    required this.numero,
    required this.complemento,
    required this.dataEvento,
    required this.horaEvento,
    required this.periodo,
    this.foto,
    required this.precoEntrada,
    required this.totalParticipantes,
    required this.dataCadastro,
    required this.usuario,
    required this.categoria,
    required this.statusEvento,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      nome: json['nome'] ?? '',
      descricao: json['descricao'] ?? '',
      localEvento: json['localEvento'] ?? '',
      cep: json['cep'] ?? '',
      numero: json['numero'] ?? '',
      complemento: json['complemento'] ?? '',
      dataEvento: json['dataEvento'] ?? '',
      horaEvento: json['horaEvento'] ?? '',
      periodo: json['periodo'] ?? '',
      foto: json['foto'] != null ? List<int>.from(json['foto']) : null,
      precoEntrada: (json['precoEntrada'] ?? 0).toDouble(),
      totalParticipantes: json['totalParticipantes'] ?? 0,
      dataCadastro: json['dataCadastro'] ?? '',
      usuario: Usuario.fromJson(json['usuario'] ?? {}),
      categoria: Categoria.fromJson(json['categoria'] ?? {}),
      statusEvento: json['statusEvento'] ?? 'ATIVO',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'localEvento': localEvento,
      'cep': cep,
      'numero': numero,
      'complemento': complemento,
      'dataEvento': dataEvento, // Como String
      'horaEvento': horaEvento,
      'periodo': periodo,
      'foto': foto,
      'precoEntrada': precoEntrada,
      'totalParticipantes': totalParticipantes,
      'dataCadastro': dataCadastro,
      'usuario': usuario.toJson(), // Convertendo o usuário para JSON
      'categoria': categoria.toJson(), // Convertendo a categoria para JSON
      'statusEvento': statusEvento,
    };
  }
}