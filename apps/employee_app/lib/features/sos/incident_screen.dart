import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import '../../providers.dart';

class IncidentScreen extends ConsumerStatefulWidget {
  const IncidentScreen({super.key});
  @override
  ConsumerState<IncidentScreen> createState() => _IncidentScreenState();
}

class _IncidentScreenState extends ConsumerState<IncidentScreen> {
  bool _isLoading = true;
  String? _error;
  List<dynamic> _incidents = [];
  int _page = 1;
  bool _hasMore = true;
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    _loadIncidents();
  }

  Future<void> _loadIncidents() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final dio = ref.read(dioProvider);
      final params = <String, dynamic>{'page': 1, 'limit': 20};
      if (_statusFilter != null) params['status'] = _statusFilter;
      final resp = await dio.get('/incidents/', queryParameters: params);
      _incidents = resp.data['data'] ?? [];
      _page = 1;
      final total = resp.data['pagination']?['totalPages'] ?? 1;
      _hasMore = _page < total;
    } on DioException catch (e) {
      setState(() => _error = e.response?.data?['error'] ?? 'Failed to load incidents');
    } catch (e) {
      setState(() => _error = 'Network error: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _loadMore() async {
    if (!_hasMore) return;
    try {
      final dio = ref.read(dioProvider);
      _page++;
      final params = <String, dynamic>{'page': _page, 'limit': 20};
      if (_statusFilter != null) params['status'] = _statusFilter;
      final resp = await dio.get('/incidents/', queryParameters: params);
      final more = resp.data['data'] ?? [];
      setState(() {
        _incidents.addAll(more);
        final total = resp.data['pagination']?['totalPages'] ?? 1;
        _hasMore = _page < total;
      });
    } catch (_) {}
  }

  void _showReportForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _ReportIncidentSheet(),
    ).then((result) {
      if (result == true) _loadIncidents();
    });
  }

  Color _severityColor(String severity) {
    switch (severity) {
      case 'critical': return Colors.red;
      case 'high': return Colors.orange;
      case 'medium': return Colors.amber;
      case 'low': return Colors.green;
      default: return Colors.grey;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'reported': return Colors.orange;
      case 'investigating': return Colors.blue;
      case 'resolved': return Colors.green;
      case 'closed': return Colors.grey;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incidents'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadIncidents),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showReportForm,
        icon: const Icon(Icons.add_alert),
        label: const Text('Report'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _buildError()
                : RefreshIndicator(
                    onRefresh: _loadIncidents,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _filterChip('All', null),
                                const SizedBox(width: 8),
                                _filterChip('Reported', 'reported'),
                                const SizedBox(width: 8),
                                _filterChip('Investigating', 'investigating'),
                                const SizedBox(width: 8),
                                _filterChip('Resolved', 'resolved'),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: _incidents.isEmpty
                              ? const Center(child: Text('No incidents found'))
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _incidents.length + (_hasMore ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == _incidents.length) {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: FilledButton(onPressed: _loadMore, child: const Text('Load More')),
                                        ),
                                      );
                                    }
                                    return _buildIncidentCard(_incidents[index]);
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _filterChip(String label, String? status) {
    final isSelected = _statusFilter == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _statusFilter = status);
        _loadIncidents();
      },
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
            FilledButton(onPressed: _loadIncidents, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentCard(dynamic incident) {
    final severity = incident['severity'] ?? 'low';
    final status = incident['status'] ?? 'reported';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _severityColor(severity).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(severity.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _severityColor(severity))),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(status.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _statusColor(status))),
                ),
                const Spacer(),
                Text(incident['createdAt']?.substring(0, 10) ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Text(incident['description'] ?? 'No description', style: const TextStyle(fontWeight: FontWeight.w500)),
            if (incident['location'] != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(incident['location'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReportIncidentSheet extends ConsumerStatefulWidget {
  const _ReportIncidentSheet();
  @override
  ConsumerState<_ReportIncidentSheet> createState() => _ReportIncidentSheetState();
}

class _ReportIncidentSheetState extends ConsumerState<_ReportIncidentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  String _severity = 'medium';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      final dio = ref.read(dioProvider);
      await dio.post('/incidents/', data: {
        'severity': _severity,
        'description': _descController.text.trim(),
        'location': _locationController.text.trim().isNotEmpty ? _locationController.text.trim() : null,
      });
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incident reported successfully'), backgroundColor: Colors.green),
        );
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
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.add_alert, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text('Report Incident', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              Text('Severity', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'low', label: Text('Low')),
                  ButtonSegment(value: 'medium', label: Text('Medium')),
                  ButtonSegment(value: 'high', label: Text('High')),
                  ButtonSegment(value: 'critical', label: Text('Critical')),
                ],
                selected: {_severity},
                onSelectionChanged: (s) => setState(() => _severity = s.first),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  hintText: 'Describe the incident...',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (optional)',
                  hintText: 'e.g., NH8 near Pune',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isSubmitting ? null : _submit,
                  icon: _isSubmitting
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.send),
                  label: Text(_isSubmitting ? 'Submitting...' : 'Submit Report'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
