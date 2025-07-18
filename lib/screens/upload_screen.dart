import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../services/firestore_service.dart';
import '../models/post.dart';
import '../providers/user_provider.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;
  final _captionCtrl = TextEditingController();
  bool _loading = false;
  final _picker = ImagePicker();
  final _storage = StorageService();
  final _firestore = FirestoreService();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _upload() async {
    if (_image == null) return;
    setState(() => _loading = true);

    try {
      final postId = const Uuid().v4();
      final user = context.read<UserProvider>().user;
      if (user == null) throw Exception('Usuario no autenticado');

      final imageUrl = await _storage.uploadPostImage(_image!, postId);
      final post = PostModel(
        id: postId,
        authorId: user.uid,
        imageUrl: imageUrl,
        caption: _captionCtrl.text.trim(),
        timestamp: DateTime.now(),
      );

      await _firestore.createPost(post);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post subido con éxito')),
      );
      setState(() {
        _image = null;
        _captionCtrl.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir post: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Nuevo Post',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: _loading ? null : _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade300),
                ),
                child: _image == null
                    ? Center(
                  child: Text(
                    'Toca para seleccionar imagen',
                    style: TextStyle(color: Colors.blue.shade700),
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _image!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _captionCtrl,
              decoration: InputDecoration(
                labelText: 'Caption',
                labelStyle: TextStyle(color: Colors.blue.shade700),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.text_snippet, color: Colors.blue.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _upload,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _loading
                  ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Text(
                'Subir',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

