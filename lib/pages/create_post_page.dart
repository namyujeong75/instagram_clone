import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/post_provider.dart';
import '../services/hive_service.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  final TextEditingController _captionController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file == null) return;
    final Uint8List bytes = await file.readAsBytes();
    setState(() => _imageBytes = bytes);
  }

  Future<void> _submit() async {
    final Uint8List? img = _imageBytes;
    if (img == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 선택하세요.')),
      );
      return;
    }
    final String caption = _captionController.text.trim();
    final Box settings = HiveService.getSettingsBox();
    final String? username = settings.get('username') as String?;
    if (username == null || username.isEmpty) {
      if (!mounted) return;
      Navigator.of(context).pushNamed('/auth');
      return;
    }
    setState(() => _saving = true);
    await context.read<PostProvider>().addPost(
          username: username,
          caption: caption,
          imageBytes: img,
        );
    if (!mounted) return;
    setState(() => _saving = false);
    _captionController.clear();
    setState(() => _imageBytes = null);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('게시물이 업로드되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('새 게시물')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: _pickImage,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.grey.shade100,
                  ),
                  child: _imageBytes == null
                      ? const Center(child: Text('탭하여 이미지 선택'))
                      : Image.memory(_imageBytes!, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '문구를 입력하세요',
              ),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              maxLines: null,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('업로드'),
            ),
          ],
        ),
      ),
    );
  }
}


