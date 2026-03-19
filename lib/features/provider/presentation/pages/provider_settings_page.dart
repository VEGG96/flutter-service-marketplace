import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_service_marketplace/l10n/l10n_extension.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import 'provider_edit_profile_page.dart';

class ProviderSettingsPage extends StatefulWidget {
  const ProviderSettingsPage({super.key});

  @override
  State<ProviderSettingsPage> createState() => _ProviderSettingsPageState();
}

class _ProviderSettingsPageState extends State<ProviderSettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.providerSettings)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                context.l10n.notifications,
                style: AppTextStyles.sectionTitle(context),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SwitchListTile(
                title: Text(context.l10n.receiveNotifications),
                subtitle: Text(context.l10n.notificationsSubtitle),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                context.l10n.settings,
                style: AppTextStyles.sectionTitle(context),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.lock_outline_rounded),
                    title: Text(context.l10n.changePassword),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.person_outline_rounded),
                    title: Text(context.l10n.editProfile),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProviderEditProfilePage(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(context.l10n.logout),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.read<AuthBloc>().add(SignOutRequested());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
