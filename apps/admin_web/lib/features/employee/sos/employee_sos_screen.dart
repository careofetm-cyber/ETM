import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../shared/providers/api_providers.dart';

class EmployeeSOSScreen extends ConsumerStatefulWidget {
  const EmployeeSOSScreen({super.key});
  @override
  ConsumerState<EmployeeSOSScreen> createState() => _EmployeeSOSScreenState();
}

class _EmployeeSOSScreenState extends ConsumerState<EmployeeSOSScreen> {
  bool _isLoading = true;
  String? _error;
  List<dynamic> _activeAlerts = [];
  List<dynamic> _history = [];
  bool _showingActive = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final dio = ref.read(dioProvider);
      final activeResp = await dio.get('/sos/active');
      _activeAlerts = activeResp.data['data'] ?? [];

      final histResp = await dio.get('/sos/history', queryParameters: {'page': 1, 'limit': 20});
      _history = histResp.data['data'] ?? [];
    } on DioException catch (e) {
      setState(() => _error = e.response?.data?['error'] ?? 'Failed to load SOS data');
    } catch (e) {
      setState(() => _error = 'Network error: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _sendSOS() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.red),
        title: const Text('Send SOS Alert?'),
        content: const Text('This will alert your transport manager and emergency contacts immediately. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            icon: const Icon(Icons.send),
            label: const Text('SEND SOS'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final dio = ref.read(dioProvider);
      await dio.post('/sos/', data: {'message': 'Emergency SOS alert from employee'});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SOS alert sent successfully'), backgroundColor: Colors.red),
        );
        _loadData();
      }
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${e.response?.data?['error'] ?? 'Unknown error'}'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                    const SizedBox(height: 16),
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    FilledButton.icon(onPressed: _loadData, icon: const Icon(Icons.refresh), label: const Text('Retry')),
                  ],
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: SegmentedButton<bool>(
                            segments: [
                              ButtonSegment(value: true, label: Text('Active (${_activeAlerts.length})'),
                                icon: Icon(_activeAlerts.isNotEmpty ? Icons.warning_amber : Icons.check_circle_outline, size: 18)),
                              ButtonSegment(value: false, label: const Text('History'),
                                icon: const Icon(Icons.history, size: 18)),
                            ],
                            selected: {_showingActive},
                            onSelectionChanged: (s) => setState(() => _showingActive = s.first),
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.icon(
                          onPressed: _sendSOS,
                          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
                          icon: const Icon(Icons.emergency, color: Colors.white),
                          label: const Text('SEND SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _showingActive ? _buildActiveList() : _buildHistoryList(),
                  ),
                ],
              );
  }

  Widget _buildActiveList() {
    if (_activeAlerts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF059669).withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.check_circle_outline, size: 56, color: const Color(0xFF059669).withOpacity(0.5)),
            ),
            const SizedBox(height: 16),
            Text('No Active Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text('All clear!', style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _activeAlerts.length,
      itemBuilder: (context, index) {
        final alert = _activeAlerts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.red.withOpacity(0.2))),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.emergency, color: Colors.red, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(alert['message'] ?? 'SOS Alert', style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text('From: ${alert['userName'] ?? alert['user_id'] ?? 'Unknown'}', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning_amber, size: 10, color: Colors.red),
                            SizedBox(width: 4),
                            Text('ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryList() {
    if (_history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 16),
            Text('No SOS history', style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final alert = _history[index];
        final isResolved = alert['isResolved'] == true;
        final statusColor = isResolved ? const Color(0xFF059669) : const Color(0xFFDC2626);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: statusColor.withOpacity(0.12),
              child: Icon(isResolved ? Icons.check_circle : Icons.warning_amber, color: statusColor, size: 20),
            ),
            title: Text(alert['message'] ?? 'SOS Alert', style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('${isResolved ? 'Resolved' : 'Active'} | ${alert['createdAt'] ?? ''}', style: const TextStyle(fontSize: 12)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Text(isResolved ? 'Resolved' : 'Active', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
            ),
          ),
        );
      },
    );
  }
}
