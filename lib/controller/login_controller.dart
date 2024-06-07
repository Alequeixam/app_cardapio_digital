import 'package:app_cardapio_digital/model/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../util/util.dart';

class LoginController {
  //
  // CRIAR CONTA
  // Adiciona a conta de um novo usuário no serviço
  // Firebase Authentication
  //
  criarConta(context, nome, email, senha) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((resultado) {
      var usr = Usuario('1', email, nome);

      usr.novoUsuario(context, resultado.user);
      sucesso(context, 'Usuário criado com sucesso!');
      Navigator.pop(context);
    }).catchError((e) {
      switch (e.code) {
        case 'email-already-in-use':
          erro(context, 'O email já foi cadastrado.');
          break;
        default:
          erro(context, 'ERRO: ${e.code.toString()}');
      }
    });
  }

  //
  // LOGIN
  //
  login(context, email, senha) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((resultado) {
      sucesso(context, 'Usuário autenticado com sucesso!');
      Navigator.pushNamed(context, 'principal');
    }).catchError((e) {
      switch (e.code) {
        case 'invalid-credential':
          erro(context, 'Email e/ou senha inválida');
          break;
        case 'invalid-email':
          erro(context, 'O formato do email é inválido.');
          break;
        default:
          erro(context, 'ERRO: ${e.code.toString()}');
      }
    });
  }

  //
  // ESQUECEU A SENHA
  //
  esqueceuSenha(context, String email) {
    if (email.isNotEmpty) {
      FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      sucesso(context, 'Email enviado com sucesso!');
    } else {
      erro(context, 'Não foi possível enviar o e-mail');
    }
  }

  //
  // LOGOUT
  //
  logout() {
    FirebaseAuth.instance.signOut();
  }

  //
  // ID do Usuário Logado
  //
  idUsuario() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  // Nome do usuario logado
  nomeUsuario() async {
    final FirebaseFirestore fs = FirebaseFirestore.instance;
    final CollectionReference dados = fs.collection('usuarios');
    DocumentSnapshot? documento;

   /* var ref = await dados
        .withConverter(
          fromFirestore: Usuario.fromFirestore,
          toFirestore: (Usuario usuario, _) => usuario.toFirestore(),
        )
        .where('uid', isEqualTo: LoginController().idUsuario())
        .get()
        .then((value) => documento = value as DocumentSnapshot<Object?>?);*/

    await dados.doc(LoginController().idUsuario()).get()
    .then((value) => documento = value);

    
    var user;
    return documento?.data();
  }
}
