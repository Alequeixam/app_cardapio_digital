import 'package:app_cardapio_digital/model/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../service/storage_service.dart';
import '../util/util.dart';

class LoginController {
  final StorageService _storageService = StorageService();

  User? _user;
  User? get user {
    return _user;
  }

  LoginController() {
   // FirebaseAuth.instance.authStateChanges().listen(stateChangeStreamListener);
  }
  //
  // CRIAR CONTA
  // Adiciona a conta de um novo usuário no serviço
  // Firebase Authentication
  //
  criarConta(context, nome, email, senha, pfFile) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((resultado) async {
          _user = resultado.user;
      FirebaseFirestore.instance.collection('usuarios').doc(_user!.uid).set({
        'uid': _user!.uid,
        'nome': nome,
        'email': email,
        'pfpURL': await _storageService.uploadPfp(file: pfFile, uid: _user!.uid),
      });
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
      _user = resultado.user;
      Navigator.pushNamed(context, 'homepage');
      sucesso(context, 'Usuário autenticado com sucesso!');
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
  nomeUsuario() {
    return FirebaseAuth.instance.currentUser!.displayName;
  }

  void stateChangeStreamListener(User? user) {
    if (user != null) {
      _user = user;
    } else {
      _user = null;
    }
  }
}
