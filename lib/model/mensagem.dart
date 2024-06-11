import 'package:cloud_firestore/cloud_firestore.dart';

enum TipoMensagem { Text, Image }

class Mensagem {
  String? senderID;
  String? content;
  TipoMensagem? tipoMensagem;
  Timestamp? sentAt;

  Mensagem({
    required this.senderID,
    required this.content,
    required this.tipoMensagem,
    required this.sentAt,
  });

  Mensagem.fromJson(Map<String, dynamic> json) {
    senderID = json['senderID'];
    content = json['content'];
    sentAt = json['sentAt'];
    tipoMensagem = TipoMensagem.values.byName(json['tipoMensagem']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderID'] = senderID;
    data['content'] = content;
    data['sentAt'] = sentAt;
    data['tipoMensagem'] = tipoMensagem!.name;
    return data;
  }
}