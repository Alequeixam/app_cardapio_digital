import 'package:app_cardapio_digital/controller/login_controller.dart';
import 'package:app_cardapio_digital/util/drawer_tile.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Row(children: [Text(data)],)
          //LOGO
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Icon(
              Icons.fastfood_outlined,
              size: 72,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          //DIVISAO
          Padding(
            padding: EdgeInsets.all(25.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          DrawerTile(
            texto: "ADICIONAR ITEM",
            icon: Icons.add_box_outlined,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'add_itens');
            },
          ),
          const Spacer(),

          DrawerTile(
            texto: "SAIR",
            icon: Icons.logout_rounded,
            onTap: () {
              LoginController().logout();
              Navigator.pop(context);
              Navigator.pushNamed(context, 'login');
            }
          ),
          const SizedBox(height: 15,),
        ],
      ),
    );
  }
}
