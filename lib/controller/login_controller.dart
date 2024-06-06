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

    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, password: senha
    ).then((resultado){
      // INFO adicional do usuario
      FirebaseFirestore.instance.collection('usuarios').add({
        "uid": resultado.user!.uid.toString(),
        "nome": nome,
      });


      sucesso(context,'Usuário criado com sucesso!');
      Navigator.pop(context);

    }).catchError((e){
      switch(e.code){
        case 'email-already-in-use':
          erro(context,'O email já foi cadastrado.');
          break;
        default:
          erro(context,'ERRO: ${e.code.toString()}');
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
      
      switch(e.code){
        case 'invalid-credential':
          erro(context,'Email e/ou senha inválida');
          break;
        case 'invalid-email':
          erro(context,'O formato do email é inválido.');
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
      sucesso(context,'Email enviado com sucesso!');
    }else{
      erro(context,'Não foi possível enviar o e-mail');
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
  nomeUsuario() {
    CollectionReference user = FirebaseFirestore.instance.collection('usuarios')
      .where('uid', isEqualTo: LoginController().idUsuario()) as CollectionReference<Object?>;
    
  }
}