// ignore_for_file: prefer_const_constructors

import 'package:app_cardapio_digital/controller/login_controller.dart';
import 'package:app_cardapio_digital/util/util.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class Recuperacao extends StatefulWidget {
  const Recuperacao({super.key});

  @override
  State<Recuperacao> createState() => _RecuperacaoState();
}

class _RecuperacaoState extends State<Recuperacao> {
  //Identificador do formulário
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      title: Text(
        "Recuperar a senha",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      content: Container(
        height: 270,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Digite seu e-mail de cadastro',
                    icon: Icon(Icons.email),
                    border: InputBorder.none,
                    //hintText: 'nome@email.com',
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
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    LoginController().esqueceuSenha(context, _emailController.text);
                    Navigator.pop(context);
                    }
                },
                child: Text(
                  "Enviar",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Após clicar em 'Enviar', você receberá dentro de alguns instantes um e-mail com os detalhes para recuperar sua conta",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
