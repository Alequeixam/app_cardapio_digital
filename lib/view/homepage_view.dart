import 'package:app_cardapio_digital/util/widgets/barra_busca.dart';
import 'package:app_cardapio_digital/util/widgets/sliver_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controller/login_controller.dart';
import '../util/util.dart';
import '../util/widgets/menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tituloDespesa = TextEditingController();
  final TextEditingController _dsDespesa = TextEditingController();
  final TextEditingController _precoDespesa = TextEditingController();
  final TextEditingController _tipoDespesa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mensagens"),
        actions: [
          IconButton(
            onPressed: () {
              LoginController().logout();
              sucesso(context, 'Você saiu da conta.');
              Navigator.pop(context);
              Navigator.pushNamed(context, 'login');
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      drawer: MenuDrawer(),
      body: Stack(
        children: [
          SizedBox(height: 60,),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: criarItem,
        child: Icon(Icons.add),
      ),
    );
  }

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

  criarItem() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          title: const Text(
            "Adicionar Despesa",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          content: Container(
            height: 320,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Theme.of(context).colorScheme.background,
                    ),
                    child: TextFormField(
                      controller: _tituloDespesa,
                      decoration: InputDecoration(
                        labelText: 'Titulo da despesa',
                        icon: Icon(Icons.abc),
                        border: InputBorder.none,
                      ),
                      validator: (nome) {
                        if (nome == null || nome.isEmpty) {
                          return 'Por favor, digite o titulo da despesa.';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.fromLTRB(2, 0, 0, 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Theme.of(context).colorScheme.background,
                    ),
                    child: TextFormField(
                      controller: _precoDespesa,
                      decoration: InputDecoration(
                        labelText: 'Quanto foi gasto',
                        icon: Icon(Icons.pin),
                        border: InputBorder.none,
                      ),
                      validator: (qtd) {
                        if (qtd == null || qtd.isEmpty) {
                          return 'Por favor, digite a quantidade do item';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(110, 40),
                    ),
                    child: Text(
                      "Criar",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancelar",
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
