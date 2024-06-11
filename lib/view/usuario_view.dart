import 'package:app_cardapio_digital/util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class UsuarioView extends StatefulWidget {
  final String userId;

  UsuarioView({required this.userId});

  @override
  _UsuarioViewState createState() => _UsuarioViewState();
}

class _UsuarioViewState extends State<UsuarioView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TextEditingController _nomeController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _emailController = TextEditingController();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    DocumentSnapshot userDoc =
        await _firestore.collection('usuarios').doc(widget.userId).get();
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      _nomeController.text = userData['nome'] ?? '';
      _emailController.text = userData['email'] ?? '';
    }
  }

  Future<void> _updateUserData() async {
    await _firestore.collection('usuarios').doc(widget.userId).update({
      'nome': _nomeController.text,
      'email': _emailController.text,
    });
    sucesso(context, "Dados atualizados com sucesso!");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Nome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            SizedBox(height: 8),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserData,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
