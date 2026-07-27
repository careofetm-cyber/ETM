import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

class RosterScreen extends ConsumerStatefulWidget {
  const RosterScreen({super.key});
  @override
  ConsumerState<RosterScreen> createState() => _RosterScreenState();
}

class _RosterScreenState extends ConsumerState<RosterScreen> {
  List<dynamic> _rosters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRosters();
  }

  Future<void> _loadRosters() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final userId = prefs.getString('user_id');
      if (userId != null) {
        final dio = ref.read(dioProvider);
        final now = DateTime.now();
        final monday = now.subtract(Duration(days: now.weekday - 1));
        final sunday = monday.add(const Duration(days: 6));
        final resp = await dio.get('/rosters/employee/${userId}_emp', queryParameters: {
          'startDate': monday.toIso8601String().substring(0, 10),
          'endDate': sunday.toIso8601String().substring(0, 10),
        });
        _rosters = resp.data['data'] ?? [];
      }
    } catch (e) {
      debugPrint('Roster error: $e');
    }
    setState(() => _isLoading = false);
  }

  Color _shiftColor(String shift) {
    switch (shift) {
      case 'morning': return const Color(0xFFF59E0B);
      case 'afternoon': return const Color(0xFF2563EB);
      case 'night': return const Color(0xFF6366F1);
      default: return Colors.grey;
    }
  }

  IconData _shiftIcon(String shift) {
    switch (shift) {
      case 'morning': return Icons.wb_sunny;
      case 'afternoon': return Icons.wb_cloudy;
      case 'night': return Icons.nightlight_round;
      default: return Icons.schedule;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed': return const Color(0xFF059669);
      case 'pending': return const Color(0xFFD97706);
      case 'cancelled': return const Color(0xFFDC2626);
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadRosters,
                child: _rosters.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_busy, size: 64, color: Theme.of(context).colorScheme.outlineVariant),
                            const SizedBox(height: 16),
                            Text(
                              'No roster entries this week',
                              style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _rosters.length,
                        itemBuilder: (context, index) {
                          final roster = _rosters[index];
                          final shift = roster['shiftType'] ?? 'morning';
                          final status = roster['status'] ?? 'pending';
                          final shiftColor = _shiftColor(shift);
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
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: shiftColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(_shiftIcon(shift), color: shiftColor, size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              roster['date'] ?? '',
                                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${shift[0].toUpperCase() + shift.substring(1)} Shift',
                                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          status[0].toUpperCase() + status.substring(1),
                                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Divider(height: 1),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(Icons.route, size: 16, color: Colors.grey.shade500),
                                      const SizedBox(width: 4),
                                      Text('Route: ${roster['routeId'] ?? "N/A"}', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                                      const SizedBox(width: 16),
                                      Icon(Icons.location_on, size: 16, color: Colors.grey.shade500),
                                      const SizedBox(width: 4),
                                      Text('Stop: ${roster['stopId'] ?? "N/A"}', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
