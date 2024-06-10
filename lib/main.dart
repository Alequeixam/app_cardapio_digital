import 'package:app_cardapio_digital/controller/login_controller.dart';
import 'package:app_cardapio_digital/util/util.dart';
import 'package:app_cardapio_digital/view/cadastro_view.dart';
import 'package:app_cardapio_digital/view/homepage_view.dart';
import 'package:app_cardapio_digital/view/recuperacao_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
  await setup();
  runApp(MainApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await registrarServico();
}

class MainApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;

  late LoginController _loginController;
  MainApp({super.key}) {
    _loginController = _getIt.get<LoginController>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: temaGeral,
      initialRoute: _loginController.user != null ? 'homepage' : 'login',
      routes: {
        'login': (context) => LoginView(),
        'cadastro': (context) => Cadastro(),
        'recuperacao': (context) => Recuperacao(),
        'homepage': (context) => HomePage(),
    },

    );
  }
}
