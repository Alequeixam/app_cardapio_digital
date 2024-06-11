import 'mensagem.dart';

class Chat {
  String? id;
  List<String>? participantes;
  List<Mensagem>? mensagens;

  Chat({
    required this.id,
    required this.participantes,
    required this.mensagens,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    participantes = List<String>.from(json['participantes']);
    mensagens =
        List.from(json['mensagens']).map((m) => Mensagem.fromJson(m)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['participantes'] = participantes;
    data['mensagens'] = mensagens?.map((m) => m.toJson()).toList() ?? [];
    return data;
  }
}