import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

class HcmIntegrationScreen extends ConsumerStatefulWidget {
  const HcmIntegrationScreen({super.key});

  @override
  ConsumerState<HcmIntegrationScreen> createState() => _HcmIntegrationScreenState();
}

class _HcmIntegrationScreenState extends ConsumerState<HcmIntegrationScreen> {
  List<dynamic> _configs = [];
  Map<String, dynamic>? _syncStatus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final api = await ref.read(hcmApiProvider.future);
      _configs = await api.getHcmConfigs();
      _syncStatus = await api.getSyncStatus();
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
              const Text('HCM Integration', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => _showAddConfigDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Integration'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Connect to your HR system to auto-sync employees and attendance. Supports Workday, SAP SuccessFactors, ADP, and custom APIs.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _configs.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sync_disabled, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('No HCM integrations configured'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _configs.length,
                        itemBuilder: (context, index) {
                          final config = _configs[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primary,
                                child: Icon(
                                  _getProviderIcon(config['provider']),
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(config['provider']?.toString().toUpperCase() ?? 'Unknown'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Endpoint: ${config['api_endpoint'] ?? 'Not configured'}'),
                                  Text('Employees: ${config['sync_employees'] == true ? 'Enabled' : 'Disabled'} | Attendance: ${config['sync_attendance'] == true ? 'Enabled' : 'Disabled'}'),
                                  if (config['last_sync_at'] != null)
                                    Text('Last sync: ${config['last_sync_at']}', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Switch(
                                    value: config['is_active'] ?? true,
                                    onChanged: (v) async {
                                      final api = await ref.read(hcmApiProvider.future);
                                      await api.updateHcmConfig(config['id'], {'isActive': v});
                                      _loadData();
                                    },
                                  ),
                                  PopupMenuButton(
                                    itemBuilder: (_) => [
                                      const PopupMenuItem(value: 'sync_emp', child: Text('Sync Employees')),
                                      const PopupMenuItem(value: 'sync_att', child: Text('Sync Attendance')),
                                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                      const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                                    ],
                                    onSelected: (v) => _handleMenuAction(v, config),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  IconData _getProviderIcon(String? provider) {
    switch (provider?.toLowerCase()) {
      case 'workday': return Icons.business;
      case 'sap': return Icons.account_tree;
      case 'adp': return Icons.people;
      default: return Icons.sync;
    }
  }

  Future<void> _handleMenuAction(String action, dynamic config) async {
    final api = await ref.read(hcmApiProvider.future);
    switch (action) {
      case 'sync_emp':
        await api.syncEmployees(config['id']);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Employee sync initiated')));
        break;
      case 'sync_att':
        await api.syncAttendance(config['id']);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance sync initiated')));
        break;
      case 'delete':
        await api.deleteHcmConfig(config['id']);
        _loadData();
        break;
    }
  }

  void _showAddConfigDialog() {
    final endpointController = TextEditingController();
    final apiKeyController = TextEditingController();
    String selectedProvider = 'workday';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add HCM Integration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedProvider,
                items: const [
                  DropdownMenuItem(value: 'workday', child: Text('Workday')),
                  DropdownMenuItem(value: 'sap', child: Text('SAP SuccessFactors')),
                  DropdownMenuItem(value: 'adp', child: Text('ADP')),
                  DropdownMenuItem(value: 'custom', child: Text('Custom API')),
                ],
                onChanged: (v) => setDialogState(() => selectedProvider = v ?? 'workday'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: endpointController,
                decoration: const InputDecoration(labelText: 'API Endpoint', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: apiKeyController,
                decoration: const InputDecoration(labelText: 'API Key', border: OutlineInputBorder()),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final api = await ref.read(hcmApiProvider.future);
                await api.createHcmConfig({
                  'provider': selectedProvider,
                  'apiEndpoint': endpointController.text,
                  'apiKey': apiKeyController.text,
                });
                Navigator.pop(ctx);
                _loadData();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
