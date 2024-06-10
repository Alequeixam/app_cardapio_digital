import 'package:app_cardapio_digital/controller/login_controller.dart';
import 'package:app_cardapio_digital/service/database_service.dart';
import 'package:app_cardapio_digital/service/media_service.dart';
import 'package:app_cardapio_digital/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
//
// MENSAGEM DE ERRO
//
void erro(context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.redAccent.withOpacity(0.4),
      content: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}

//
// MENSAGEM DE SUCESSO
//
void sucesso(context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Color.fromARGB(255, 105, 166, 240).withOpacity(0.4),
      content: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}

Future<void> registrarServico() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<LoginController>(LoginController());
  
  getIt.registerSingleton<MediaService>(MediaService());

  getIt.registerSingleton<StorageService>(StorageService());

  getIt.registerSingleton<DbService>(DbService());
}