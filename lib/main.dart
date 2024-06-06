import 'package:app_cardapio_digital/view/cadastro_view.dart';
import 'package:app_cardapio_digital/view/homepage_view.dart';
import 'package:app_cardapio_digital/view/recuperacao_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'tema/tema.dart';
import 'view/login_view.dart';

Future<void> main() async {
  //
  // Firebase
  //
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: temaGeral,
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginView(),
        'cadastro': (context) => Cadastro(),
        'recuperacao': (context) => Recuperacao(),
        'homepage': (context) => HomePage(),
    },

    );
  }
}
