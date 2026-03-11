import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  void _setNotificationsEnabled(bool value) {
    if (_notificationsEnabled == value) return;
    setState(() => _notificationsEnabled = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Preferencias',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SwitchListTile(
                title: const Text('Notificaciones push'),
                subtitle: const Text('Avisos de mensajes y solicitudes nuevas'),
                value: _notificationsEnabled,
                onChanged: _setNotificationsEnabled,
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Cuenta',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.lock_outline_rounded),
                    title: const Text('Cambiar contraseña'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),

                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Cerrar sesión'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.read<AuthBloc>().add(SignOutRequested());
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: Text(
                      'Eliminar cuenta',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      final bool? confirmed = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Eliminar cuenta'),
                          content: const Text(
                            'Esta acción es permanente. ¿Deseas continuar?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(true),
                              child: Text(
                                'Eliminar',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirmed != true) return;
                      if (!context.mounted) return;
                      context.read<AuthBloc>().add(DeleteAccountRequested());
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
