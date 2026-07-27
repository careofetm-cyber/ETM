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
      final activeResp = await dio.get('/sos/active');
      _activeAlerts = activeResp.data['data'] ?? [];

      final histResp = await dio.get('/sos/history', queryParameters: {'page': 1, 'limit': 20});
      _history = histResp.data['data'] ?? [];
      _historyPage = 1;
      final total = histResp.data['pagination']?['totalPages'] ?? 1;
      _hasMoreHistory = _historyPage < total;
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
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('SEND SOS'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final dio = ref.read(dioProvider);
      await dio.post('/sos/', data: {
        'message': 'Emergency SOS alert from employee',
      });
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
      appBar: AppBar(
        title: const Text('SOS Alerts'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _sendSOS,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.emergency, color: Colors.white),
        label: const Text('SEND SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _buildError()
                : RefreshIndicator(
                    onRefresh: _loadData,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: SegmentedButton<bool>(
                                  segments: [
                                    ButtonSegment(value: true, label: Text('Active (${_activeAlerts.length})')),
                                    ButtonSegment(value: false, label: Text('History')),
                                  ],
                                  selected: {_showingActive},
                                  onSelectionChanged: (s) => setState(() => _showingActive = s.first),
                                ),
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
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loadData, child: const Text('Retry')),
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
            Icon(Icons.check_circle_outline, size: 64, color: Colors.green.shade300),
            const SizedBox(height: 12),
            Text('No Active Alerts', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _activeAlerts.length,
      itemBuilder: (context, index) {
        final alert = _activeAlerts[index];
        return Card(
          color: Colors.red.shade50,
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.red, child: const Icon(Icons.emergency, color: Colors.white)),
            title: Text(alert['message'] ?? 'SOS Alert', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('From: ${alert['userName'] ?? alert['user_id'] ?? 'Unknown'}'),
                Text('Role: ${alert['userRole'] ?? alert['user_type'] ?? 'Unknown'}'),
                Text('Time: ${alert['createdAt'] ?? 'Unknown'}', style: const TextStyle(fontSize: 12)),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildHistoryList() {
    if (_history.isEmpty) {
      return const Center(child: Text('No SOS history'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _history.length + (_hasMoreHistory ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _history.length) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(onPressed: _loadMoreHistory, child: const Text('Load More')),
            ),
          );
        }
        final alert = _history[index];
        final isResolved = alert['isResolved'] == true || alert['is_resolved'] == true;
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isResolved ? Colors.green.shade100 : Colors.red.shade100,
              child: Icon(isResolved ? Icons.check_circle : Icons.warning_amber, color: isResolved ? Colors.green : Colors.red),
            ),
            title: Text(alert['message'] ?? 'SOS Alert'),
            subtitle: Text('Status: ${isResolved ? 'Resolved' : 'Active'} | ${alert['createdAt'] ?? ''}', style: const TextStyle(fontSize: 12)),
          ),
        );
      },
    );
  }
}
