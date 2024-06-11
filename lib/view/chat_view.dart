import 'package:app_cardapio_digital/controller/login_controller.dart';
import 'package:app_cardapio_digital/model/mensagem.dart';
import 'package:app_cardapio_digital/model/usuario.dart';
import 'package:app_cardapio_digital/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  final Usuario usuario;

  const ChatView({
    super.key,
    required this.usuario,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  ChatUser? usrAtual, outroUsr;
  final DbService _dbService = DbService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usrAtual = ChatUser(
      id: LoginController().idUsuario(),
      firstName: LoginController().nomeUsuario(),
    );
    outroUsr = ChatUser(
      id: widget.usuario.uid!,
      firstName: widget.usuario.nome,
      profileImage: widget.usuario.pfpURL,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usuario.nome!),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      messageOptions: const MessageOptions(
        showOtherUsersAvatar: true,
        showTime: true,
      ),
      inputOptions: const InputOptions(alwaysShowSend: true),
      currentUser: usrAtual!,
      onSend: _enviarMsg,
      messages: [],
    );
  }

  Future<void> _enviarMsg(ChatMessage msg) async {
    Mensagem mensagem = Mensagem(
      senderID: usrAtual!.id,
      content: msg.text,
      tipoMensagem: TipoMensagem.Text,
      sentAt: Timestamp.fromDate(msg.createdAt),
    );
    await _dbService.enviarMsg(usrAtual!.id, outroUsr!.id, mensagem);
  }
}
