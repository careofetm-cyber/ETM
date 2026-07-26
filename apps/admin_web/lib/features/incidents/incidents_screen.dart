import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

final incidentsPageProvider = StateProvider<int>((ref) => 1);
final incidentsStatusFilterProvider = StateProvider<String>((ref) => 'all');

final incidentsProvider = FutureProvider<List<Incident>>((ref) async {
  final api = await ref.watch(incidentApiProvider.future);
  final page = ref.watch(incidentsPageProvider);
  final status = ref.watch(incidentsStatusFilterProvider);
  return api.getIncidents(
    page: page,
    limit: 20,
    status: status == 'all' ? null : status,
  );
});

final _vehiclesListProvider = FutureProvider<List<Vehicle>>((ref) async {
  final api = await ref.watch(vehicleApiProvider.future);
  return api.getVehicles(limit: 100);
});

class IncidentsScreen extends ConsumerStatefulWidget {
  const IncidentsScreen({super.key});

  @override
  ConsumerState<IncidentsScreen> createState() => _IncidentsScreenState();
}

class _IncidentsScreenState extends ConsumerState<IncidentsScreen> {
  @override
  Widget build(BuildContext context) {
    final incidentsAsync = ref.watch(incidentsProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Incidents',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showReportIncidentDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Report Incident'),
                ),
                const SizedBox(width: 12),
                SOSButton(),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                DropdownButton<String>(
                  value: ref.watch(incidentsStatusFilterProvider),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Status')),
                    DropdownMenuItem(value: 'reported', child: Text('Reported')),
                    DropdownMenuItem(value: 'investigating', child: Text('Investigating')),
                    DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
                    DropdownMenuItem(value: 'closed', child: Text('Closed')),
                  ],
                  onChanged: (value) {
                    ref.read(incidentsStatusFilterProvider.notifier).state = value!;
                    ref.read(incidentsPageProvider.notifier).state = 1;
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: incidentsAsync.when(
                    data: (incidents) {
                      if (incidents.isEmpty) {
                        return const Center(child: Text('No incidents found'));
                      }
                      return _buildIncidentsTable(incidents);
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(child: Text('Error: $error')),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentsTable(List<Incident> incidents) {
    return DataTable2(
      columns: const [
        DataColumn2(label: Text('Reported By'), size: ColumnSize.L),
        DataColumn2(label: Text('Vehicle')),
        DataColumn2(label: Text('Severity')),
        DataColumn2(label: Text('Status')),
        DataColumn2(label: Text('Description')),
        DataColumn2(label: Text('Location')),
        DataColumn2(label: Text('Time')),
        DataColumn2(label: Text('Actions'), size: ColumnSize.S),
      ],
      rows: incidents.map((incident) {
        return DataRow2(cells: [
          DataCell(Text(incident.reportedBy)),
          DataCell(Text(incident.vehicleId ?? '-')),
          DataCell(_buildSeverityChip(incident.severity.name)),
          DataCell(_buildStatusChip(incident.status.name)),
          DataCell(Text(
            incident.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
          DataCell(Text(incident.location ?? '-')),
          DataCell(Text(incident.incidentTime != null
              ? '${incident.incidentTime!.day}/${incident.incidentTime!.month}/${incident.incidentTime!.year}'
              : '-')),
          DataCell(Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, size: 20),
                onPressed: () => _showIncidentDetail(context, incident),
              ),
              if (incident.status == IncidentStatus.reported)
                IconButton(
                  icon: const Icon(Icons.play_arrow, size: 20, color: AppColors.info),
                  tooltip: 'Mark Investigating',
                  onPressed: () async {
                    try {
                      final api = await ref.read(incidentApiProvider.future);
                      await api.updateIncident(incident.id, {'status': 'investigating'});
                      ref.invalidate(incidentsProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Incident marked as investigating'), backgroundColor: AppColors.success),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update incident: $e'), backgroundColor: AppColors.error),
                        );
                      }
                    }
                  },
                ),
              if (incident.status == IncidentStatus.investigating)
                IconButton(
                  icon: const Icon(Icons.check_circle, size: 20, color: AppColors.success),
                  tooltip: 'Mark Resolved',
                  onPressed: () async {
                    try {
                      final api = await ref.read(incidentApiProvider.future);
                      await api.updateIncident(incident.id, {'status': 'resolved'});
                      ref.invalidate(incidentsProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Incident resolved'), backgroundColor: AppColors.success),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to resolve incident: $e'), backgroundColor: AppColors.error),
                        );
                      }
                    }
                  },
                ),
            ],
          )),
        ]);
      }).toList(),
    );
  }

  Widget _buildSeverityChip(String severity) {
    Color color;

    switch (severity) {
      case 'low':
        color = AppColors.info;
        break;
      case 'medium':
        color = AppColors.warning;
        break;
      case 'high':
        color = AppColors.error;
        break;
      case 'critical':
        color = AppColors.sos;
        break;
      default:
        color = AppColors.textSecondary;
    }

    return Chip(
      label: Text(severity.toUpperCase(), style: TextStyle(color: color)),
      backgroundColor: color.withOpacity(0.1),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'reported':
        color = AppColors.warning;
        label = 'Reported';
        break;
      case 'investigating':
        color = AppColors.info;
        label = 'Investigating';
        break;
      case 'resolved':
        color = AppColors.success;
        label = 'Resolved';
        break;
      case 'closed':
        color = AppColors.textSecondary;
        label = 'Closed';
        break;
      default:
        color = AppColors.textSecondary;
        label = status;
    }

    return Chip(
      label: Text(label, style: TextStyle(color: color)),
      backgroundColor: color.withOpacity(0.1),
    );
  }

  void _showIncidentDetail(BuildContext context, Incident incident) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Incident Details'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('Reported By', incident.reportedBy),
              _detailRow('Vehicle', incident.vehicleId ?? '-'),
              _detailRow('Driver', incident.driverId ?? '-'),
              _detailRow('Trip', incident.tripId ?? '-'),
              _detailRow('Severity', incident.severity.name.toUpperCase()),
              _detailRow('Status', incident.status.name[0].toUpperCase() + incident.status.name.substring(1)),
              _detailRow('Description', incident.description),
              _detailRow('Location', incident.location ?? '-'),
              if (incident.latitude != null && incident.longitude != null)
                _detailRow('Coordinates', '${incident.latitude}, ${incident.longitude}'),
              if (incident.incidentTime != null)
                _detailRow('Time', '${incident.incidentTime!.day}/${incident.incidentTime!.month}/${incident.incidentTime!.year} '
                    '${incident.incidentTime!.hour}:${incident.incidentTime!.minute.toString().padLeft(2, '0')}'),
              if (incident.resolution != null)
                _detailRow('Resolution', incident.resolution!),
              if (incident.resolvedBy != null)
                _detailRow('Resolved By', incident.resolvedBy!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showReportIncidentDialog(BuildContext context) {
    String? selectedVehicleId;
    String selectedSeverity = 'medium';
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Report Incident'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      final vehiclesAsync = ref.watch(_vehiclesListProvider);
                      return vehiclesAsync.when(
                        data: (vehicles) => DropdownButtonFormField<String>(
                          value: selectedVehicleId,
                          decoration: const InputDecoration(labelText: 'Vehicle'),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('None')),
                            ...vehicles.map((v) => DropdownMenuItem(
                              value: v.id,
                              child: Text('${v.brand} ${v.model} (${v.plateNumber})'),
                            )),
                          ],
                          onChanged: (v) => setDialogState(() => selectedVehicleId = v),
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) => Text('Error: $e'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedSeverity,
                    decoration: const InputDecoration(labelText: 'Severity'),
                    items: const [
                      DropdownMenuItem(value: 'low', child: Text('Low')),
                      DropdownMenuItem(value: 'medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'high', child: Text('High')),
                      DropdownMenuItem(value: 'critical', child: Text('Critical')),
                    ],
                    onChanged: (v) => setDialogState(() => selectedSeverity = v!),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description *'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: descriptionController.text.isEmpty
                  ? null
                  : () async {
                      try {
                        final api = await ref.read(incidentApiProvider.future);
                        await api.reportIncident({
                          'vehicleId': selectedVehicleId,
                          'severity': selectedSeverity,
                          'description': descriptionController.text,
                          'location': locationController.text.isEmpty ? null : locationController.text,
                        });
                        if (context.mounted) Navigator.pop(context);
                        ref.invalidate(incidentsProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Incident reported successfully'), backgroundColor: AppColors.success),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to report incident: $e'), backgroundColor: AppColors.error),
                          );
                        }
                      }
                    },
              child: const Text('Report'),
            ),
          ],
        ),
      ),
    );
  }
}

class SOSButton extends StatelessWidget {
  const SOSButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.textInverse,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Send SOS Alert'),
            content: const Text(
                'Are you sure you want to send an SOS alert? This will notify all administrators.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  try {
                    final container = ProviderScope.containerOf(context);
                    final api = await container.read(incidentApiProvider.future);
                    await api.sendSOS(0.0, 0.0, 'SOS from admin dashboard');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('SOS alert sent successfully'), backgroundColor: AppColors.success),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to send SOS: $e'), backgroundColor: AppColors.error),
                      );
                    }
                  }
                },
                child: const Text('Send SOS'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.warning),
      label: const Text('SOS'),
    );
  }
}
