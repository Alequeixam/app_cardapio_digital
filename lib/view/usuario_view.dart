import 'dart:io' as io;
import 'dart:typed_data';

import 'package:app_cardapio_digital/util/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../service/storage_service.dart';
import '../util/consts.dart';

class UsuarioView extends StatefulWidget {
  final String userId;
  final String pfpURL;

  UsuarioView({required this.userId, required this.pfpURL});

  @override
  _UsuarioViewState createState() => _UsuarioViewState();
}

class _UsuarioViewState extends State<UsuarioView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storageService = StorageService();
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  //String? pfpURL;
  PlatformFile? pfFile;
  Uint8List? _imageBytes;
  io.File? _imageFile;

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
      //pfpURL = userData['pfpURL'] ?? '';
      _nomeController.text = userData['nome'] ?? '';
      _emailController.text = userData['email'] ?? '';
    }
  }

  Future<void> _updateUserData() async {
    await _firestore.collection('usuarios').doc(widget.userId).update({
      'nome': _nomeController.text,
      'email': _emailController.text,
      'pfpURL': await _storageService.updatePfp(
          file: pfFile!, uid: widget.userId, pfpURL: widget.pfpURL),
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
            pfpSelectionField(),
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

  Widget pfpSelectionField() {
    return GestureDetector(
      onTap: pickAndSetImage,
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: _imageBytes != null
            ? MemoryImage(_imageBytes!)
            : _imageFile != null
                ? FileImage(_imageFile!)
                : widget.pfpURL != null
                    ? Image.network(widget.pfpURL).image
                    : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Future<void> pickAndSetImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single != null) {
      pfFile = result.files.single;
      print('Imagem selecionada: ${pfFile!.name}');

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

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
