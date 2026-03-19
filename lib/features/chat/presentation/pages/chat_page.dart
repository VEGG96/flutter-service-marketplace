import 'package:flutter/material.dart';
import 'package:flutter_service_marketplace/l10n/l10n_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.chat),
        actions: <Widget>[
          IconButton(
            onPressed: () => context.go(AppRoutes.profile),
            icon: const Icon(Icons.person_outline_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(context.l10n.chatScreen),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.go(AppRoutes.profile),
              child: Text(context.l10n.goToMyProfile),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.go(AppRoutes.services),
              child: Text(context.l10n.backToServices),
            ),
          ],
        ),
      ),
    );
  }
}
