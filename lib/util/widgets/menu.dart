// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:app_cardapio_digital/controller/login_controller.dart';
import 'package:app_cardapio_digital/model/usuario.dart';
import 'package:app_cardapio_digital/util/widgets/drawer_tile.dart';
import 'package:app_cardapio_digital/view/usuario_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../service/database_service.dart';
import '../util.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _pfpURL;
  String? _nome;
  String? _email;
  String? _usrId;

  @override
  void initState() {
    super.initState();
    _usrId = LoginController().idUsuario();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('usuarios').doc(_usrId).get();
      if (userDoc.exists) {
        setState(() {
          _pfpURL = userDoc['pfpURL'];
          _nome = userDoc['nome'];
          _email = userDoc['email'];
        });
      }
    } catch (e) {
      print("Não foi possível recuperar dados de: $e");
    }
  }

  final DbService _dbService = DbService();
  String? userName;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          //LOGO
          UserAccountsDrawerHeader(
            accountName: Text(_nome ?? 'Nome do Usuário'),
            accountEmail: Text(_email ?? 'email@exemplo.com'),
            currentAccountPicture: _pfpURL != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(_pfpURL!),
                  )
                : CircleAvatar(
                    child: Icon(Icons.person),
                  ),
          ),
          
          DrawerTile(
            texto: "Editar nome",
            icon: Icons.add_box_outlined,
            onTap: () async {
              final usrId = LoginController().idUsuario();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UsuarioView(userId: usrId)));
            },
          ),
          const Spacer(),

          DrawerTile(
              texto: "SAIR",
              icon: Icons.logout_rounded,
              onTap: () {
                LoginController().logout();
                sucesso(context, 'Você saiu da conta.');
                Navigator.pop(context);
                Navigator.pushNamed(context, 'login');
              }),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  // Nome do usuario logado
  nomeUsuario() async {
    final FirebaseFirestore fs = FirebaseFirestore.instance;
    final CollectionReference dados = fs.collection('usuarios');
    var documento;

    await dados
        .doc(LoginController().idUsuario())
        .get()
        .then((value) => userName = value['nome']);

    return documento?.data();
  }
}
