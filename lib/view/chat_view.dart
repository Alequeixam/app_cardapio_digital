import 'dart:io' as io;
import 'dart:io';
import 'dart:typed_data';
import 'package:app_cardapio_digital/controller/login_controller.dart';
import 'package:app_cardapio_digital/model/mensagem.dart';
import 'package:app_cardapio_digital/model/usuario.dart';
import 'package:app_cardapio_digital/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/chat.dart';
import '../service/storage_service.dart';
import '../util/util.dart';

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
  final StorageService _storageService = StorageService();

  PlatformFile? midia;
  Uint8List? _imageBytes;
  io.File? _imageFile;

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
    return StreamBuilder(
      stream: _dbService.getChatMsgs(usrAtual!.id, outroUsr!.id),
      builder: (context, snapshot) {
        Chat? chat = snapshot.data?.data();
        List<ChatMessage> mensagens = [];
        if (chat != null && chat.mensagens != null) {
          mensagens = _gerarChatMessages(
            chat.mensagens!,
          );
        }

        return DashChat(
          messageOptions: const MessageOptions(
            showOtherUsersAvatar: true,
            showTime: true,
          ),
          inputOptions: InputOptions(
            alwaysShowSend: true,
            trailing: [
              _mensagemMidia(),
            ],
          ),
          currentUser: usrAtual!,
          onSend: _enviarMsg,
          messages: mensagens,
        );
      },
    );
  }

  Future<void> _enviarMsg(ChatMessage msg) async {
    if (msg.medias?.isNotEmpty ?? false) {
      if (msg.medias!.first.type == MediaType.image) {
        Mensagem mensagem = Mensagem(
            senderID: msg.user.id,
            content: msg.medias!.first.url,
            tipoMensagem: TipoMensagem.Image,
            sentAt: Timestamp.fromDate(msg.createdAt));
        await _dbService.enviarMsg(usrAtual!.id, outroUsr!.id, mensagem);
      }
    } else {
      Mensagem mensagem = Mensagem(
        senderID: usrAtual!.id,
        content: msg.text,
        tipoMensagem: TipoMensagem.Text,
        sentAt: Timestamp.fromDate(msg.createdAt),
      );
      await _dbService.enviarMsg(usrAtual!.id, outroUsr!.id, mensagem);
    }
  }

  List<ChatMessage> _gerarChatMessages(List<Mensagem> msgs) {
    List<ChatMessage> chatMessages = msgs.map((m) {
      if (m.tipoMensagem == TipoMensagem.Image) {
        return ChatMessage(
          user: m.senderID == usrAtual!.id ? usrAtual! : outroUsr!,
          medias: [
            ChatMedia(url: m.content!, fileName: "", type: MediaType.image)
          ],
          createdAt: m.sentAt!.toDate(),
        );
      } else {
        return ChatMessage(
          user: m.senderID == usrAtual!.id ? usrAtual! : outroUsr!,
          text: m.content!,
          createdAt: m.sentAt!.toDate(),
        );
      }
    }).toList();
    chatMessages.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return chatMessages;
  }

  Widget _mensagemMidia() {
    return IconButton(
        onPressed: () async {
          pickAndSetImage();
          if (midia != null) {
            String chatID = gerarChatID(uid1: usrAtual!.id, uid2: outroUsr!.id);
            String? downloadUrl = await _storageService.uploadImagemChat(
                file: midia!, chatID: chatID);
            if (downloadUrl != null) {
              ChatMessage chatMessage = ChatMessage(
                  user: usrAtual!,
                  createdAt: DateTime.now(),
                  medias: [
                    ChatMedia(
                        url: downloadUrl, fileName: "", type: MediaType.image),
                  ]);
              _enviarMsg(chatMessage);
            }
          }
        },
        icon: Icon(
          Icons.image,
          color: Theme.of(context).colorScheme.primary,
        ));
  }

  Future<void> pickAndSetImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single != null) {
      midia = result.files.single;
      print('Imagem selecionada: ${midia!.name}');

      if (kIsWeb) {
        setState(() {
          _imageBytes = midia!.bytes;
        });
      } else {
        setState(() {
          _imageFile = io.File(midia!.path!);
        });
      }
    } else {
      // Usuário cancelou o picker
    }
  }
}
