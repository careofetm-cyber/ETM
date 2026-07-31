import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/api_providers.dart';

class EmployeeRosterScreen extends ConsumerStatefulWidget {
  const EmployeeRosterScreen({super.key});
  @override
  ConsumerState<EmployeeRosterScreen> createState() => _EmployeeRosterScreenState();
}

class _EmployeeRosterScreenState extends ConsumerState<EmployeeRosterScreen> {
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
    return _isLoading
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
                        Text('No roster entries this week', style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  )
                : Card(
                    margin: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5)),
                        columns: const [
                          DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.w600))),
                          DataColumn(label: Text('Shift', style: TextStyle(fontWeight: FontWeight.w600))),
                          DataColumn(label: Text('Route', style: TextStyle(fontWeight: FontWeight.w600))),
                          DataColumn(label: Text('Stop', style: TextStyle(fontWeight: FontWeight.w600))),
                          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w600))),
                        ],
                        rows: _rosters.map((roster) {
                          final shift = roster['shiftType'] ?? 'morning';
                          final status = roster['status'] ?? 'pending';
                          final shiftColor = _shiftColor(shift);
                          final statusColor = _statusColor(status);

                          return DataRow(cells: [
                            DataCell(Text(roster['date'] ?? '', style: const TextStyle(fontWeight: FontWeight.w500))),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(_shiftIcon(shift), size: 16, color: shiftColor),
                                  const SizedBox(width: 6),
                                  Text('${shift[0].toUpperCase() + shift.substring(1)} Shift'),
                                ],
                              ),
                            ),
                            DataCell(Text(roster['routeId'] ?? 'N/A')),
                            DataCell(Text(roster['stopId'] ?? 'N/A')),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      status == 'confirmed' ? Icons.check_circle
                                          : status == 'pending' ? Icons.hourglass_top
                                          : Icons.cancel,
                                      size: 14,
                                      color: statusColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      status[0].toUpperCase() + status.substring(1),
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
          );
  }
}
