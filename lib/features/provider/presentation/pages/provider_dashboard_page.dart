import 'package:flutter/material.dart';
import 'package:flutter_service_marketplace/l10n/l10n_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

class ProviderDashboardPage extends StatelessWidget {
  const ProviderDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${context.l10n.greetingHello}, Emmanuel 👋'),
            const SizedBox(height: 2),
            Text(
              context.l10n.statusActive,
              style: const TextStyle(fontSize: 12, color: Colors.greenAccent),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go(AppRoutes.providerSettings);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildQuickStats(context),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 32),
            _buildPendingRequests(context),
            const SizedBox(height: 32),
            _buildTodayAgenda(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.attach_money, size: 28, color: Colors.green),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.earningsWeekly,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '3,250 MXN',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.star, size: 28, color: Colors.amber),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.rating,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '4.8',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '50 ${context.l10n.reviews}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, size: 28, color: Colors.blue),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.completed,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '12',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            context.go(AppRoutes.providerAvailability);
          },
          icon: const Icon(Icons.calendar_today),
          label: Text(context.l10n.configureAvailability),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () {
            // Mock: se usa un provider predefinido para mostrar el perfil público.
            // En producción, se debería usar el ID del proveedor autenticado.
            context.go('${AppRoutes.providerProfile}?id=carlos-gomez');
          },
          icon: const Icon(Icons.person),
          label: Text(context.l10n.viewHowCustomersSeeMe),
        ),
      ],
    );
  }

  Widget _buildPendingRequests(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.l10n.newRequests} (2)',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _requestCard(
          servicio: 'Fuga de agua en lavabo',
          cliente: 'Juan Pérez',
          horario: 'Jueves 15 - 10:00 AM',
          direccion: 'Col. Roma Sur (a 3 km)',
          context: context,
        ),
        const SizedBox(height: 8),
        _requestCard(
          servicio: 'Instalación de ventilador de techo',
          cliente: 'María López',
          horario: 'Viernes 16 - 04:00 PM',
          direccion: 'Condesa (a 1.5 km)',
          context: context,
        ),
      ],
    );
  }

  Widget _requestCard({
    required String servicio,
    required String cliente,
    required String horario,
    required String direccion,
    required BuildContext context,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(servicio, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              '${context.l10n.clientLabel}: $cliente',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              '${context.l10n.scheduleLabel}: $horario',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              '${context.l10n.addressLabel}: $direccion',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text(context.l10n.reject),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(context.l10n.accept),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayAgenda(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.todayAgenda,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n.confirmed,
                      style: const TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Mantenimiento de Minisplit',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  '${context.l10n.clientLabel}: Carlos G.',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 2),
                const Text(
                  '12:00 PM - 02:00 PM',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(context.l10n.viewDetails),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
