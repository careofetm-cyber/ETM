import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../providers.dart';

class SOSScreen extends ConsumerStatefulWidget {
  const SOSScreen({super.key});
  @override
  ConsumerState<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends ConsumerState<SOSScreen> {
  bool _isLoading = true;
  String? _error;
  List<dynamic> _activeAlerts = [];
  List<dynamic> _history = [];
  int _historyPage = 1;
  bool _hasMoreHistory = true;
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
      try {
        final activeResp = await dio.get('/sos/active');
        _activeAlerts = activeResp.data['data'] ?? [];
      } on DioException catch (e) {
        if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
          _activeAlerts = [];
        } else {
          rethrow;
        }
      }

      try {
        final histResp = await dio.get('/sos/history', queryParameters: {'page': 1, 'limit': 20});
        _history = histResp.data['data'] ?? [];
        _historyPage = 1;
        final total = histResp.data['pagination']?['totalPages'] ?? 1;
        _hasMoreHistory = _historyPage < total;
      } on DioException catch (e) {
        if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
          _history = [];
          _hasMoreHistory = false;
        } else {
          rethrow;
        }
      }
    } on DioException catch (e) {
      setState(() => _error = e.response?.data?['error'] ?? 'Failed to load SOS data');
    } catch (e) {
      setState(() => _error = 'Network error: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _loadMoreHistory() async {
    if (!_hasMoreHistory) return;
    try {
      final dio = ref.read(dioProvider);
      _historyPage++;
      final resp = await dio.get('/sos/history', queryParameters: {'page': _historyPage, 'limit': 20});
      final more = resp.data['data'] ?? [];
      setState(() {
        _history.addAll(more);
        final total = resp.data['pagination']?['totalPages'] ?? 1;
        _hasMoreHistory = _historyPage < total;
      });
    } catch (_) {}
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
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError()
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: Column(
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
                  ),
                ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.error_outline, size: 48, color: Colors.red),
            ),
            const SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            FilledButton.icon(onPressed: _loadData, icon: const Icon(Icons.refresh), label: const Text('Retry')),
          ],
        ),
      ),
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
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text('Role: ${alert['userRole'] ?? alert['user_type'] ?? 'Unknown'}', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text('${alert['createdAt'] ?? 'Unknown'}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
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
      itemCount: _history.length + (_hasMoreHistory ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _history.length) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(onPressed: _loadMoreHistory, icon: const Icon(Icons.expand_more), label: const Text('Load More')),
            ),
          );
        }
        final alert = _history[index];
        final isResolved = alert['isResolved'] == true || alert['is_resolved'] == true;
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
