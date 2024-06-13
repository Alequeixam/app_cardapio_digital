// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Sobre extends StatelessWidget {
  const Sobre({super.key});

  final String _urlGitHub = "https://github.com/Alequeixam/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sobre este aplicativo"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text("Chat de mensagens",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "\tO aplicativo de Chat é projetado para oferecer uma interface simples e amigável para interações básicas entre os usuários cadastrados no sistema.\n\t Ele permite que os usuários conversem enviando mensagens de texto ou fotos.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Expanded(
                  child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Devs:"),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Alex Henrique Santana"),
                        SizedBox(width: 5),
                        InkWell(
                          onTap: () => launchUrlString(_urlGitHub),
                          child: FaIcon(FontAwesomeIcons.github),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
