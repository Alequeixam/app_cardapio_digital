import 'package:app_cardapio_digital/model/usuario.dart';
import 'package:app_cardapio_digital/util/consts.dart';
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
        print(usuario.pfpURL!);
      },
      dense: false,
      leading: CircleAvatar(
        backgroundImage: usuario.pfpURL! != null
            ? Image.network(
                usuario.pfpURL!,
                fit: BoxFit.fill,
              ).image
            : NetworkImage(PLACEHOLDER_PFP),
      ),
      title: Text(
        usuario.nome!,
      ),
    );
  }
}
