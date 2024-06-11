import 'package:app_cardapio_digital/model/chat.dart';
import 'package:app_cardapio_digital/model/mensagem.dart';
import 'package:app_cardapio_digital/model/usuario.dart';
import 'package:app_cardapio_digital/util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../controller/login_controller.dart';

class DbService {
  final GetIt getIt = GetIt.instance;
  final FirebaseFirestore _fbFirestore = FirebaseFirestore.instance;

  late LoginController _loginController;

  CollectionReference? _usuariosRef;
  CollectionReference? _chatsRef;

  DbService() {
    _loginController = getIt.get<LoginController>();
    _setupCollectionReferences();
  }

  void _setupCollectionReferences() {
    _usuariosRef = _fbFirestore.collection('usuarios').withConverter<Usuario>(
        fromFirestore: (snapshots, _) => Usuario.fromJson(snapshots.data()!),
        toFirestore: (userProfile, _) => userProfile.toJson());

    _chatsRef = _fbFirestore.collection('chats').withConverter<Chat>(
        fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
        toFirestore: (chat, _) => chat.toJson());
  }

  Future<void> novoUsuario(context, Usuario userProfile) async {
    await _usuariosRef?.doc(userProfile.uid).set(userProfile);
  }

  Future<void> criarConta(context, nome, email, senha, pfpURL) {
    return _loginController.criarConta(context, nome, email, senha, pfpURL);
  }

  Stream<QuerySnapshot<Usuario>> getUsuarios() {
    return _usuariosRef
        ?.where('uid', isNotEqualTo: LoginController().idUsuario())
        .snapshots() as Stream<QuerySnapshot<Usuario>>;
  }

  Future<bool> chatExists(String uid1, String uid2) async {
    String chatID = gerarChatID(uid1: uid1, uid2: uid2);
    final resultado = await _chatsRef?.doc(chatID).get();
    if (resultado != null) {
      return resultado.exists;
    }
    return false;
  }

  Future<void> criarNovoChat(String uid1, String uid2) async {
    String chatID = gerarChatID(uid1: uid1, uid2: uid2);
    final docRef = _chatsRef!.doc(chatID);
    final chat = Chat(
      id: chatID,
      participantes: [uid1, uid2],
      mensagens: [],
    );
    await docRef.set(chat);
  }

  Future<void> enviarMsg(String uid1, String uid2, Mensagem msg) async {
    String chatID = gerarChatID(uid1: uid1, uid2: uid2);
    final docRef = _chatsRef!.doc(chatID);
    await docRef.update({
      "mensagens": FieldValue.arrayUnion(
        [
          msg.toJson(),
        ],
      )
    });
  }

  Stream<DocumentSnapshot<Chat>> getChatMsgs(String uid1, String uid2) {
    String chatID = gerarChatID(uid1: uid1, uid2: uid2);
    return _chatsRef?.doc(chatID).snapshots() as Stream<DocumentSnapshot<Chat>>;
  }
}
