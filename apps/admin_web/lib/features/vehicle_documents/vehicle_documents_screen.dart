import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

class VehicleDocumentsScreen extends ConsumerStatefulWidget {
  const VehicleDocumentsScreen({super.key});

  @override
  ConsumerState<VehicleDocumentsScreen> createState() => _VehicleDocumentsScreenState();
}

class _VehicleDocumentsScreenState extends ConsumerState<VehicleDocumentsScreen> {
  List<dynamic> _documents = [];
  Map<String, dynamic>? _alerts;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final api = await ref.read(vehicleDocumentApiProvider.future);
      _documents = await api.getDocuments();
      _alerts = await api.getDocumentAlerts();
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
              const Text('Vehicle Documents', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => _showAddDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Document'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_alerts != null) _buildAlertsBanner(),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Card(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Vehicle')),
                          DataColumn(label: Text('Type')),
                          DataColumn(label: Text('Number')),
                          DataColumn(label: Text('Expiry')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: _documents.map((doc) {
                          final statusColor = doc['status'] == 'valid'
                              ? Colors.green
                              : doc['status'] == 'expiring_soon'
                                  ? Colors.orange
                                  : Colors.red;
                          return DataRow(cells: [
                            DataCell(Text(doc['vehicle_id'] ?? '')),
                            DataCell(Chip(
                              label: Text(doc['document_type']?.toString().toUpperCase() ?? '', style: const TextStyle(fontSize: 12)),
                              backgroundColor: Colors.blue.shade50,
                            )),
                            DataCell(Text(doc['document_number'] ?? '')),
                            DataCell(Text(doc['expiry_date'] ?? '')),
                            DataCell(Chip(
                              label: Text(doc['status'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.white)),
                              backgroundColor: statusColor,
                            )),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18),
                                  onPressed: () => _showEditDialog(doc),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                  onPressed: () => _deleteDocument(doc['id']),
                                ),
                              ],
                            )),
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

  Widget _buildAlertsBanner() {
    final expired = _alerts?['expired'] ?? 0;
    final expiringSoon = _alerts?['expiringSoon'] ?? 0;
    if (expired == 0 && expiringSoon == 0) return const SizedBox.shrink();

    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.orange, size: 32),
            const SizedBox(width: 12),
            if (expired > 0)
              Text('$expired expired documents', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            if (expired > 0 && expiringSoon > 0) const Text(' | '),
            if (expiringSoon > 0)
              Text('$expiringSoon expiring soon', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showAddDialog() {
    final vehicleIdController = TextEditingController();
    final numberController = TextEditingController();
    final issueDateController = TextEditingController();
    final expiryDateController = TextEditingController();
    String docType = 'rc';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Vehicle Document'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: vehicleIdController, decoration: const InputDecoration(labelText: 'Vehicle ID', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: docType,
                  items: const [
                    DropdownMenuItem(value: 'rc', child: Text('RC (Registration Certificate)')),
                    DropdownMenuItem(value: 'insurance', child: Text('Insurance')),
                    DropdownMenuItem(value: 'permit', child: Text('Permit')),
                    DropdownMenuItem(value: 'puc', child: Text('PUC Certificate')),
                  ],
                  onChanged: (v) => setDialogState(() => docType = v ?? 'rc'),
                  decoration: const InputDecoration(labelText: 'Document Type', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(controller: numberController, decoration: const InputDecoration(labelText: 'Document Number', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: issueDateController, decoration: const InputDecoration(labelText: 'Issue Date (YYYY-MM-DD)', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: expiryDateController, decoration: const InputDecoration(labelText: 'Expiry Date (YYYY-MM-DD)', border: OutlineInputBorder())),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final api = await ref.read(vehicleDocumentApiProvider.future);
                await api.createDocument({
                  'vehicleId': vehicleIdController.text,
                  'documentType': docType,
                  'documentNumber': numberController.text,
                  'issueDate': issueDateController.text,
                  'expiryDate': expiryDateController.text,
                });
                Navigator.pop(ctx);
                _loadData();
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Document added'), backgroundColor: Colors.green));
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(dynamic doc) {
    final numberController = TextEditingController(text: doc['documentNumber'] ?? '');
    final issueDateController = TextEditingController(text: doc['issueDate'] ?? '');
    final expiryDateController = TextEditingController(text: doc['expiryDate'] ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit ${doc['documentType']?.toString().toUpperCase()} Document'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Vehicle: ${doc['vehicleId']}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              TextField(controller: numberController, decoration: const InputDecoration(labelText: 'Document Number', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: issueDateController, decoration: const InputDecoration(labelText: 'Issue Date (YYYY-MM-DD)', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: expiryDateController, decoration: const InputDecoration(labelText: 'Expiry Date (YYYY-MM-DD)', border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final api = await ref.read(vehicleDocumentApiProvider.future);
              await api.updateDocument(doc['id'], {
                'documentNumber': numberController.text,
                'issueDate': issueDateController.text,
                'expiryDate': expiryDateController.text,
              });
              Navigator.pop(ctx);
              _loadData();
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Document updated'), backgroundColor: Colors.green));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDocument(String id) async {
    final api = await ref.read(vehicleDocumentApiProvider.future);
    await api.deleteDocument(id);
    _loadData();
  }
}
