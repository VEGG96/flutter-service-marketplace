import 'package:flutter/material.dart';
import 'package:flutter_service_marketplace/l10n/l10n_extension.dart';

class ProviderAvailabilityPage extends StatefulWidget {
  const ProviderAvailabilityPage({super.key});

  @override
  State<ProviderAvailabilityPage> createState() =>
      _ProviderAvailabilityPageState();
}

class _ProviderAvailabilityPageState extends State<ProviderAvailabilityPage> {
  final Map<String, bool> _days = {
    'Lunes': true,
    'Martes': true,
    'Miércoles': true,
    'Jueves': true,
    'Viernes': true,
    'Sábado': false,
    'Domingo': false,
  };

  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 18, minute: 0);

  Future<void> _pickStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _pickEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null && picked != _endTime) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(context.l10n.configureAvailability),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
             Text(
              context.l10n.selectDays,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ..._days.keys.map((day) {
              return SwitchListTile(
                title: Text(day),
                value: _days[day]!,
                onChanged: (bool value) {
                  setState(() {
                    _days[day] = value;
                  });
                },
              );
            }),
            const Divider(height: 32),
             Text(
              context.l10n.workingHours,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickStartTime,
                    child:
                        Text('${context.l10n.start}: ${_startTime.format(context)}'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickEndTime,
                    child: Text('${context.l10n.end}: ${_endTime.format(context)}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: guardar cambios
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text(context.l10n.availabilitySaved)),
                );
              },
              child:  Text(context.l10n.saveAvailability),
            ),
          ],
        ),
      ),
    );
  }
}
