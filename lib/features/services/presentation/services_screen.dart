import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text('Listado de servicios disponible'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  context.push('${AppRoutes.serviceDetail}?id=service_demo_1'),
              child: const Text('Ver detalle de servicio'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.booking),
              child: const Text('Ir a reservas'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.chat),
              child: const Text('Ir a chat'),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () => context.go(AppRoutes.login),
              child: const Text('Cerrar sesion'),
            ),
          ],
        ),
      ),
    );
  }
}
