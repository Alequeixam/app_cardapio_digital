// ignore_for_file: prefer_const_declarations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Usuario {
  String? uid;
  String? email;
  String? nome;
  String? pfpURL;

  Usuario(this.uid,  this.email,  this.nome, this.pfpURL);

  // Objeto em JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'nome': nome,
      'pfpURL': pfpURL,
    };
  }
  Map<String, dynamic> toJsonn() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    data['pfpURL'] = pfpURL;
    data['email'] = email;
    data['uid'] = uid;
    return data;
  }
  

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (nome != null) "nome": nome,
      if (email != null) "email": email,
      if (pfpURL != null) "email": pfpURL,
    };
  }

  // JSON em Objeto
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      json['uid'],
      json['email'],
      json['nome'],
      json['pfpURL'],
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
      data?['pfpURL'],
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
      "email": email,
    });
  }
}
