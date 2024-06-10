// ignore_for_file: prefer_const_constructors

import 'dart:io' as io;
import 'dart:io';

import 'package:app_cardapio_digital/controller/login_controller.dart';
import 'package:app_cardapio_digital/model/usuario.dart';
import 'package:app_cardapio_digital/service/database_service.dart';
import 'package:app_cardapio_digital/service/media_service.dart';
import 'package:app_cardapio_digital/service/storage_service.dart';
import 'package:app_cardapio_digital/util/consts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController1 = TextEditingController();
  final _senhaController2 = TextEditingController();

  PlatformFile? pfFile;
  File? imagem;
  Uint8List? _imageBytes;
  io.File? _imageFile;

  final GetIt _getIt = GetIt.instance;
  late MediaService _mediaService;
  late LoginController _loginController;
  late StorageService _storageService;
  late DbService _dbService;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _storageService = _getIt.get<StorageService>();
    _loginController = _getIt.get<LoginController>();
    _dbService = _getIt.get<DbService>();
  }

  bool isVisivel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.info_outline),
                      onPressed: () {
                        Navigator.pushNamed(context, 'cadastro_view');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  "Crie uma conta no app",
                  style: TextStyle(fontSize: 18, color: Colors.grey[550]),
                ),

                SizedBox(height: 40),
                pfpSelectionField(),
                pfFile == null
                    ? Text(
                        "Selecione uma foto para seu perfil",
                        style: TextStyle(fontSize: 12, color: Colors.grey[550]),
                      )
                    : Text(""),
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      border: InputBorder.none,
                      hintText: 'nome completo',
                    ),
                    validator: (nome) {
                      if (nome == null || nome.isEmpty) {
                        return 'Por favor, insira um nome';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Email
                //
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      border: InputBorder.none,
                      hintText: 'nome@email.com',
                    ),
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return 'Por favor, insira um e-mail';
                      } else if (!EmailValidator.validate(email)) {
                        return 'Digite um endereço de e-mail válido!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Senha
                //
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: TextFormField(
                    controller: _senhaController1,
                    obscureText: !isVisivel,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      border: InputBorder.none,
                      hintText: 'senha',
                      // define como visivel ou nao o campo da senha
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisivel = !isVisivel;
                            });
                          },
                          icon: Icon(!isVisivel
                              ? Icons.visibility
                              : Icons.visibility_off)),
                    ),
                    validator: (senha) {
                      if (senha == null || senha.isEmpty) {
                        return 'Por favor, insira uma senha';
                      } else if (senha.length < 8) {
                        return 'A senha deve conter no mínimo 8 dígitos!';
                      } else if (!PASSWORD_VALIDATION_REGEX.hasMatch(senha)) {
                        return 'Deve conter letras maiusculas e minusculas, e caractere espeial';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Senha 2
                //
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: TextFormField(
                    controller: _senhaController2,
                    obscureText: !isVisivel,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      border: InputBorder.none,
                      hintText: 'repita a senha',
                      // define como visivel ou nao o campo da senha
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisivel = !isVisivel;
                            });
                          },
                          icon: Icon(!isVisivel
                              ? Icons.visibility
                              : Icons.visibility_off)),
                    ),
                    validator: (senha) {
                      if (senha == null || senha.isEmpty) {
                        return 'Por favor, insira uma senha';
                      } else if (senha.length < 6) {
                        return 'A senha deve conter no mínimo 6 dígitos!';
                      } else if (_senhaController1.text !=
                          _senhaController2.text) {
                        return 'As senhas devem ser iguais.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && pfFile != null) {
                      LoginController().criarConta(
                          context,
                          _nomeController.text,
                          _emailController.text,
                          _senhaController1.text);
                      String? pfpURL = await _storageService.uploadPfp(
                          file: pfFile!, uid: _loginController.user!.uid);
                      if (pfpURL != null) {
                        await _dbService.novoUsuario(
                            context,
                            Usuario(
                                _loginController.user!.uid,
                                _emailController.text,
                                _nomeController.text,
                                pfpURL));
                      }
                    }
                  },
                  child: const Text(
                    "Cadastrar",
                    style: TextStyle(
                      color: Color.fromRGBO(70, 70, 70, 1),
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancelar"),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget pfpSelectionField() {
    return GestureDetector(
      onTap: pickAndSetImage,
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: _imageBytes != null
            ? MemoryImage(_imageBytes!)
            : _imageFile != null
                ? FileImage(_imageFile!)
                : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Future<void> pickAndSetImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single != null) {
      pfFile = result.files.single;
      if (kIsWeb) {
        setState(() {
          _imageBytes = pfFile!.bytes;
        });
      } else {
        setState(() {
          _imageFile = io.File(pfFile!.path!);
        });
      }
    } else {
      // Usuário cancelou o picker
    }
  }
}
