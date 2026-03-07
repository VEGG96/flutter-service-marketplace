import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text('Pantalla de chat'),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.go(AppRoutes.services),
              child: const Text('Volver a servicios'),
            ),
          ],
        ),
      ),
    );
  }
}
