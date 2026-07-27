import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
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
      case 'critical': return const Color(0xFFDC2626);
      case 'high': return const Color(0xFFEA580C);
      case 'medium': return const Color(0xFFF59E0B);
      case 'low': return const Color(0xFF059669);
      default: return Colors.grey;
    }
  }

  IconData _severityIcon(String severity) {
    switch (severity) {
      case 'critical': return Icons.error;
      case 'high': return Icons.warning;
      case 'medium': return Icons.info;
      case 'low': return Icons.info_outline;
      default: return Icons.help_outline;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'reported': return const Color(0xFFEA580C);
      case 'investigating': return const Color(0xFF2563EB);
      case 'resolved': return const Color(0xFF059669);
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
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadIncidents, tooltip: 'Refresh'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showReportForm,
        backgroundColor: const Color(0xFFEA580C),
        icon: const Icon(Icons.add_alert, color: Colors.white),
        label: const Text('Report', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _filterChip('All', null, Icons.list),
                                const SizedBox(width: 8),
                                _filterChip('Reported', 'reported', Icons.report),
                                const SizedBox(width: 8),
                                _filterChip('Investigating', 'investigating', Icons.search),
                                const SizedBox(width: 8),
                                _filterChip('Resolved', 'resolved', Icons.check_circle),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: _incidents.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.verified, size: 64, color: Theme.of(context).colorScheme.outlineVariant),
                                      const SizedBox(height: 16),
                                      Text('No incidents found', style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _incidents.length + (_hasMore ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == _incidents.length) {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: FilledButton.icon(
                                            onPressed: _loadMore,
                                            icon: const Icon(Icons.expand_more),
                                            label: const Text('Load More'),
                                          ),
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

  Widget _filterChip(String label, String? status, IconData icon) {
    final isSelected = _statusFilter == status;
    return FilterChip(
      label: Text(label),
      avatar: Icon(icon, size: 18),
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline, size: 48, color: Colors.red),
            ),
            const SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _loadIncidents,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentCard(dynamic incident) {
    final severity = incident['severity'] ?? 'low';
    final status = incident['status'] ?? 'reported';
    final severityColor = _severityColor(severity);
    final statusColor = _statusColor(status);

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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_severityIcon(severity), color: severityColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        incident['description'] ?? 'No description',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        incident['createdAt']?.substring(0, 10) ?? '',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_severityIcon(severity), size: 10, color: severityColor),
                      const SizedBox(width: 4),
                      Text(
                        severity.toUpperCase(),
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: severityColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        status == 'reported' ? Icons.report
                            : status == 'investigating' ? Icons.search
                            : status == 'resolved' ? Icons.check_circle
                            : Icons.circle,
                        size: 10,
                        color: statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status.toUpperCase(),
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (incident['location'] != null) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      incident['location'],
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ),
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEA580C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add_alert, color: Color(0xFFEA580C), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text('Report Incident', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              Text('Severity', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'low', label: Text('Low'), icon: Icon(Icons.info_outline, size: 16)),
                  ButtonSegment(value: 'medium', label: Text('Medium'), icon: Icon(Icons.info, size: 16)),
                  ButtonSegment(value: 'high', label: Text('High'), icon: Icon(Icons.warning, size: 16)),
                  ButtonSegment(value: 'critical', label: Text('Critical'), icon: Icon(Icons.error, size: 16)),
                ],
                selected: {_severity},
                onSelectionChanged: (s) => setState(() => _severity = s.first),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  hintText: 'Describe the incident...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (optional)',
                  hintText: 'e.g., NH8 near Pune',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
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
