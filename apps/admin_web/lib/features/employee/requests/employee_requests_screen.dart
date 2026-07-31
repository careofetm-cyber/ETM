import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../shared/providers/api_providers.dart';

class EmployeeRequestScreen extends ConsumerStatefulWidget {
  const EmployeeRequestScreen({super.key});
  @override
  ConsumerState<EmployeeRequestScreen> createState() => _EmployeeRequestScreenState();
}

class _EmployeeRequestScreenState extends ConsumerState<EmployeeRequestScreen> {
  String _requestType = 'routeChange';
  final _reasonController = TextEditingController();
  final _routeIdController = TextEditingController();
  final _stopIdController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitRequest() async {
    if (_reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a reason')));
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final userId = prefs.getString('user_id');
      final dio = ref.read(dioProvider);
      await dio.post('/attendance/transport-requests', data: {
        'employeeId': '${userId}_emp',
        'type': _requestType,
        'routeId': _routeIdController.text.isNotEmpty ? _routeIdController.text : null,
        'stopId': _stopIdController.text.isNotEmpty ? _stopIdController.text : null,
        'reason': _reasonController.text,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request submitted'), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.response?.data?['error'] ?? 'Failed to submit')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error')));
      }
    }
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [cs.primaryContainer.withOpacity(0.5), cs.primaryContainer.withOpacity(0.2)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: cs.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.swap_horiz, color: cs.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Submit a Request', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text('Request changes to your transport route or schedule', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('Request Type', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'routeChange', label: Text('Route'), icon: Icon(Icons.route)),
            ButtonSegment(value: 'stopChange', label: Text('Stop'), icon: Icon(Icons.location_on)),
            ButtonSegment(value: 'cancellation', label: Text('Cancel'), icon: Icon(Icons.cancel)),
          ],
          selected: {_requestType},
          onSelectionChanged: (v) => setState(() => _requestType = v.first),
        ),
        const SizedBox(height: 20),
        if (_requestType == 'routeChange') ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _routeIdController,
                decoration: const InputDecoration(labelText: 'New Route ID', border: OutlineInputBorder(), hintText: 'e.g., route_001', prefixIcon: Icon(Icons.route)),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (_requestType == 'stopChange') ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _stopIdController,
                decoration: const InputDecoration(labelText: 'New Stop ID', border: OutlineInputBorder(), hintText: 'e.g., stop_003', prefixIcon: Icon(Icons.location_on)),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _reasonController,
              decoration: const InputDecoration(labelText: 'Reason *', border: OutlineInputBorder(), hintText: 'Why do you need this change?', prefixIcon: Icon(Icons.notes)),
              maxLines: 3,
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton.icon(
            onPressed: _isSubmitting ? null : _submitRequest,
            icon: _isSubmitting
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.send),
            label: Text(_isSubmitting ? 'Submitting...' : 'Submit Request'),
          ),
        ),
      ],
    );
  }
}
