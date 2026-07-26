import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

class SosAlertsScreen extends ConsumerStatefulWidget {
  const SosAlertsScreen({super.key});

  @override
  ConsumerState<SosAlertsScreen> createState() => _SosAlertsScreenState();
}

class _SosAlertsScreenState extends ConsumerState<SosAlertsScreen> {
  List<dynamic> _activeAlerts = [];
  List<dynamic> _history = [];
  Map<String, dynamic>? _stats;
  bool _isLoading = true;
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      final activeResp = await dio.get('/sos/active');
      _activeAlerts = activeResp.data['data'] ?? [];
      final historyResp = await dio.get('/sos/history');
      _history = historyResp.data['data'] ?? [];
      final statsResp = await dio.get('/sos/stats');
      _stats = statsResp.data;
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
              const Text('SOS Alerts', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  if (_stats != null) ...[
                    _buildStatBadge('Active', _stats!['active'] ?? 0, Colors.red),
                    const SizedBox(width: 8),
                    _buildStatBadge('Total', _stats!['total'] ?? 0, Colors.blue),
                  ],
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _showHistory = !_showHistory);
                    },
                    child: Text(_showHistory ? 'Show Active' : 'Show History'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _showHistory ? _buildHistoryList() : _buildActiveAlerts(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text('$label: $count', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActiveAlerts() {
    if (_activeAlerts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 64),
            SizedBox(height: 16),
            Text('No Active SOS Alerts', style: TextStyle(fontSize: 18, color: Colors.green)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _activeAlerts.length,
      itemBuilder: (context, index) {
        final alert = _activeAlerts[index];
        return Card(
          color: Colors.red.shade50,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: const Icon(Icons.warning, color: Colors.white),
            ),
            title: Text(alert['user_name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Role: ${alert['user_role'] ?? ''} | Phone: ${alert['phone'] ?? 'N/A'}'),
                if (alert['message'] != null) Text(alert['message']),
                Text('Time: ${alert['created_at'] ?? ''}', style: const TextStyle(fontSize: 12)),
              ],
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => _acknowledge(alert['id']),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('Acknowledge'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _resolve(alert['id']),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Resolve'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryList() {
    if (_history.isEmpty) {
      return const Center(child: Text('No SOS history'));
    }

    return Card(
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('User')),
            DataColumn(label: Text('Role')),
            DataColumn(label: Text('Message')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Time')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _history.map((alert) {
            final isResolved = alert['is_resolved'] == true;
            return DataRow(cells: [
              DataCell(Text(alert['user_id'] ?? '')),
              DataCell(Text(alert['user_type'] ?? '')),
              DataCell(Text(alert['message'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis)),
              DataCell(Chip(
                label: Text(isResolved ? 'Resolved' : 'Active', style: const TextStyle(fontSize: 12, color: Colors.white)),
                backgroundColor: isResolved ? Colors.green : Colors.red,
              )),
              DataCell(Text(alert['created_at']?.toString().substring(0, 16) ?? '')),
              DataCell(
                !isResolved
                    ? ElevatedButton(
                        onPressed: () => _resolve(alert['id']),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        child: const Text('Resolve'),
                      )
                    : const Text(''),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _acknowledge(String id) async {
    final dio = ref.read(dioProvider);
    await dio.post('/sos/$id/acknowledge');
    _loadData();
  }

  Future<void> _resolve(String id) async {
    final dio = ref.read(dioProvider);
    await dio.post('/sos/$id/resolve', data: {'notes': 'Resolved by admin'});
    _loadData();
  }
}
