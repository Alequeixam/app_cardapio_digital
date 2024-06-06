// ignore_for_file: prefer_const_constructors

import 'package:app_cardapio_digital/controller/login_controller.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController1 = TextEditingController();
  final _senhaController2 = TextEditingController();

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
                    SizedBox(height: 20),
                    Icon(
                      Icons.lock,
                      size: 50,
                    ),

                    SizedBox(height: 18),
                    Text(
                      "Crie uma conta no app",
                      style: TextStyle(fontSize: 18, color: Colors.grey[550]),
                    ),

                    SizedBox(height: 40),

                    // Email
                    //
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Theme.of(context).colorScheme.tertiary,
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
                        color: Theme.of(context).colorScheme.tertiary,
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
                          } else if (senha.length < 6) {
                            return 'A senha deve conter no mínimo 6 dígitos!';
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
                        color: Theme.of(context).colorScheme.tertiary,
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
                          } else if (_senhaController1.text != _senhaController2.text) {
                            return 'As senhas devem ser iguais.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          LoginController().criarConta(context, '', _emailController.text, _senhaController1.text);
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
}