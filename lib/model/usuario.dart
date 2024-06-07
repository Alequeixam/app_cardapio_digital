import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Usuario {
  String? uid;
  String? email;
  String? nome;

  Usuario(this.uid, this.email, this.nome);

  // Objeto em JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'nome': nome,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (nome != null) "nome": nome,
      if (email != null) "email": email,
    };
  }

  // JSON em Objeto
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      json['uid'],
      json['email'],
      json['nome'],
    );
  }

  factory Usuario.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Usuario(
      data?['uid'],
      data?['email'],
      data?['nome'],
    );
  }

  novoUsuario(context, user) async {
    var fbUser = await FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
    .collection('usuarios')
    .doc(fbUser.uid)
    .set({
      "uid": user!.uid.toString(),
      "nome": nome,
    });
  }
}
