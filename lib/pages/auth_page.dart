import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/hive_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final String name = _controller.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    final Box settings = HiveService.getSettingsBox();
    await settings.put('username', name);
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('사용자 이름 설정')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('앱에서 사용할 사용자 이름을 입력하세요.'),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '예: sunfish',
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _continue(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saving ? null : _continue,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('계속'),
            ),
          ],
        ),
      ),
    );
  }
}


