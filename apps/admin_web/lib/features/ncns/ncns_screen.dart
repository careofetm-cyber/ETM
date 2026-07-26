import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

class NcnsScreen extends ConsumerStatefulWidget {
  const NcnsScreen({super.key});

  @override
  ConsumerState<NcnsScreen> createState() => _NcnsScreenState();
}

class _NcnsScreenState extends ConsumerState<NcnsScreen> {
  List<dynamic> _ncnsLog = [];
  Map<String, dynamic>? _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final api = await ref.read(ncnsApiProvider.future);
      _ncnsLog = await api.getNcnsLog();
      _settings = await api.getNcnsSettings();
    } catch (e) {
      debugPrint('Error: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('NCNS Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  _buildSettingsCard(),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showMarkNcnsDialog(),
                    icon: const Icon(Icons.person_off),
                    label: const Text('Mark NCNS'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Card(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Employee')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Reason')),
                          DataColumn(label: Text('Marked By')),
                          DataColumn(label: Text('Time')),
                        ],
                        rows: _ncnsLog.map((log) {
                          return DataRow(cells: [
                            DataCell(Text(log['employee_id'] ?? '')),
                            DataCell(Text(log['date'] ?? '')),
                            DataCell(Text(log['reason'] ?? '')),
                            DataCell(Text(log['marked_by'] ?? 'System')),
                            DataCell(Text(log['created_at']?.toString().substring(0, 16) ?? '')),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.settings, size: 18),
            const SizedBox(width: 8),
            Text('Threshold: ${_settings?['ncnsThreshold'] ?? 3}'),
            const SizedBox(width: 12),
            Switch(
              value: _settings?['autoDisable'] ?? true,
              onChanged: (v) async {
                final api = await ref.read(ncnsApiProvider.future);
                await api.updateNcnsSettings({'autoDisable': v});
                _loadData();
              },
            ),
            const Text('Auto-Disable'),
          ],
        ),
      ),
    );
  }

  void _showMarkNcnsDialog() {
    final employeeController = TextEditingController();
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mark NCNS'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: employeeController,
              decoration: const InputDecoration(labelText: 'Employee ID', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: 'Reason', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final api = await ref.read(ncnsApiProvider.future);
              await api.markNcns({
                'employeeId': employeeController.text,
                'reason': reasonController.text,
              });
              Navigator.pop(ctx);
              _loadData();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Mark NCNS'),
          ),
        ],
      ),
    );
  }
}
