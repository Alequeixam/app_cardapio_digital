import 'dart:io' as io;
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart'; // Import para selecionar arquivos
import 'package:flutter/foundation.dart' show kIsWeb;

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageService() {}

  Future<String?> uploadPfp({
    required PlatformFile file,
    required String uid,
  }) async {
    try {
      Reference fileRef =
          _firebaseStorage.ref().child('$uid${p.extension(file.name)}');

      UploadTask task;

      if (kIsWeb) {
        // Para web
        task = fileRef.putData(file.bytes!);
      } else {
        // Para mobile
        task = fileRef.putFile(io.File(file.path!));
      }

      TaskSnapshot snapshot = await task;

      if (snapshot.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> pickAndUploadFile(
      StorageService storageService, String uid) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single != null) {
      PlatformFile file = result.files.single;
      String? downloadUrl =
          await storageService.uploadPfp(file: file, uid: uid);
      print('Download URL: $downloadUrl');
    } else {
      // Usuário cancelou o picker
    }
  }

  /*Future<String?> uploadPic({
    required File file,
    required String uid,
  }) async {
    try {
      Reference fileRef = _firebaseStorage
          .ref()
          .child('$uid${p.extension(file.path)}');

      UploadTask task = fileRef.putFile(file);
      return task.then(
        (p) {
          p.ref.getDownloadURL();
          
        },
      );
    } catch (e) {
      print(e.toString());
    }
    return null;
  }*/

  Future<String?> uploadImagemChat(
      {required PlatformFile file, required String chatID}) async {
    Reference fileRef = _firebaseStorage
        .ref('chats/$chatID')
        .child('${DateTime.now().toIso8601String()}${p.extension(file.name)}');
    
    UploadTask task = fileRef.putData(file.bytes!);
    return task.then((p) {
      if (p.state == TaskState.success) {
        return fileRef.getDownloadURL();
      }
    });
  }
}
