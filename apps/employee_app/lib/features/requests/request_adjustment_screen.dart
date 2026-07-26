import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../providers.dart';

class RequestAdjustmentScreen extends ConsumerStatefulWidget {
  const RequestAdjustmentScreen({super.key});
  @override
  ConsumerState<RequestAdjustmentScreen> createState() => _RequestAdjustmentScreenState();
}

class _RequestAdjustmentScreenState extends ConsumerState<RequestAdjustmentScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Adjustment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Request Type', style: TextStyle(fontWeight: FontWeight.bold)),
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
          const SizedBox(height: 16),
          if (_requestType == 'routeChange') ...[
            TextField(controller: _routeIdController, decoration: const InputDecoration(labelText: 'New Route ID', border: OutlineInputBorder(), hintText: 'e.g., route_001')),
            const SizedBox(height: 12),
          ],
          if (_requestType == 'stopChange') ...[
            TextField(controller: _stopIdController, decoration: const InputDecoration(labelText: 'New Stop ID', border: OutlineInputBorder(), hintText: 'e.g., stop_003')),
            const SizedBox(height: 12),
          ],
          TextField(controller: _reasonController, decoration: const InputDecoration(labelText: 'Reason', border: OutlineInputBorder(), hintText: 'Why do you need this change?'), maxLines: 3),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitRequest,
              child: _isSubmitting ? const CircularProgressIndicator() : const Text('Submit Request'),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
