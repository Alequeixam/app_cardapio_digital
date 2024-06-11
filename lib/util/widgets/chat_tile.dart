import 'package:app_cardapio_digital/model/usuario.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatTile extends StatelessWidget {
  final Usuario usuario;
  final Function onTap;

  const ChatTile({
    super.key,
    required this.usuario,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      dense: false,
      leading: CircleAvatar(
        backgroundImage: Image.network(usuario.pfpURL!).image,
      ),
      title: Text(
        usuario.nome!,
      ),
    );
  }
}
