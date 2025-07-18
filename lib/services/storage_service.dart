import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadPostImage(File file, String postId) async {
    final ref = _storage.ref().child('posts/$postId.jpg');
    try {
      final task = await ref.putFile(file);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print('⚠️ Error al subir imagen: ${e.code} ${e.message}');
      rethrow;
    }
  }
}
