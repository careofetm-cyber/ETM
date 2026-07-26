import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

class TransportRequestsScreen extends ConsumerStatefulWidget {
  const TransportRequestsScreen({super.key});

  @override
  ConsumerState<TransportRequestsScreen> createState() => _TransportRequestsScreenState();
}

class _TransportRequestsScreenState extends ConsumerState<TransportRequestsScreen> {
  List<dynamic> _requests = [];
  bool _isLoading = true;
  String _statusFilter = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      final resp = await dio.get('/attendance/transport-requests', queryParameters: {
        if (_statusFilter.isNotEmpty) 'status': _statusFilter,
      });
      _requests = resp.data['data'] ?? [];
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
              const Text('Transport Requests', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  DropdownButton<String>(
                    value: _statusFilter,
                    items: const [
                      DropdownMenuItem(value: '', child: Text('All Status')),
                      DropdownMenuItem(value: 'pending', child: Text('Pending')),
                      DropdownMenuItem(value: 'approved', child: Text('Approved')),
                      DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
                    ],
                    onChanged: (v) {
                      setState(() => _statusFilter = v ?? '');
                      _loadData();
                    },
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
                          DataColumn(label: Text('Type')),
                          DataColumn(label: Text('Details')),
                          DataColumn(label: Text('Reason')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: _requests.map((req) {
                          final statusColor = req['status'] == 'approved'
                              ? Colors.green
                              : req['status'] == 'rejected'
                                  ? Colors.red
                                  : Colors.orange;
                          return DataRow(cells: [
                            DataCell(Text(req['employee_id'] ?? '')),
                            DataCell(Chip(
                              label: Text(req['type'] ?? '', style: const TextStyle(fontSize: 12)),
                              backgroundColor: Colors.blue.shade50,
                            )),
                            DataCell(Text('Route: ${req['route_id'] ?? 'N/A'}')),
                            DataCell(Text(req['reason'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis)),
                            DataCell(Chip(
                              label: Text(req['status'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.white)),
                              backgroundColor: statusColor,
                            )),
                            DataCell(
                              req['status'] == 'pending'
                                  ? Row(
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () => _approve(req['id']),
                                          icon: const Icon(Icons.check, size: 16),
                                          label: const Text('Approve'),
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton.icon(
                                          onPressed: () => _reject(req['id']),
                                          icon: const Icon(Icons.close, size: 16),
                                          label: const Text('Reject'),
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                        ),
                                      ],
                                    )
                                  : const Text(''),
                            ),
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

  Future<void> _approve(String id) async {
    final dio = ref.read(dioProvider);
    await dio.post('/attendance/transport-requests/$id/approve');
    _loadData();
  }

  Future<void> _reject(String id) async {
    final dio = ref.read(dioProvider);
    await dio.post('/attendance/transport-requests/$id/reject', data: {'reason': 'Rejected by admin'});
    _loadData();
  }
}
