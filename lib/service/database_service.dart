import 'package:app_cardapio_digital/model/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  final FirebaseFirestore _fbFirestore = FirebaseFirestore.instance;

  CollectionReference? _usuariosRef;

  DbService() {
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
}
