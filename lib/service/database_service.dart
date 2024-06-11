import 'package:app_cardapio_digital/model/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../controller/login_controller.dart';

class DbService {
  final GetIt getIt = GetIt.instance;
  final FirebaseFirestore _fbFirestore = FirebaseFirestore.instance;

  late LoginController _loginController;

  CollectionReference? _usuariosRef;

  DbService() {
    _loginController = getIt.get<LoginController>();
    _setupCollectionReferences();
  }

  void _setupCollectionReferences() {
    _usuariosRef = _fbFirestore.collection('usuarios').withConverter<Usuario>(
        fromFirestore: (snapshots, _) => Usuario.fromJson(snapshots.data()!),
        toFirestore: (userProfile, _) => userProfile.toJsonn());
  }

  Future<void> novoUsuario(context, Usuario userProfile) async {
    await _usuariosRef?.doc(userProfile.uid).set(userProfile);
  }

  Future<void> criarConta(context, nome, email, senha, pfpURL) {
    return _loginController.criarConta(context, nome, email, senha,);
  }

  Stream<QuerySnapshot<Usuario>> getUsuarios() {
    return _usuariosRef
        ?.where('uid', isNotEqualTo: _loginController.user!.uid)
        .snapshots() as Stream<QuerySnapshot<Usuario>>;
  }
}
