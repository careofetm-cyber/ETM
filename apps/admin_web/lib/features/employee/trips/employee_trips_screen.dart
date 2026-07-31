import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/api_providers.dart';

class EmployeeTripsScreen extends ConsumerStatefulWidget {
  const EmployeeTripsScreen({super.key});
  @override
  ConsumerState<EmployeeTripsScreen> createState() => _EmployeeTripsScreenState();
}

class _EmployeeTripsScreenState extends ConsumerState<EmployeeTripsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _upcomingTrips = [];
  List<dynamic> _completedTrips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTrips();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTrips() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final userId = prefs.getString('user_id');
      if (userId != null) {
        final dio = ref.read(dioProvider);
        final resp = await dio.get('/trips/employee/${userId}_emp');
        final trips = resp.data['data'] ?? [];
        _upcomingTrips = trips.where((t) => t['status'] == 'scheduled' || t['status'] == 'inProgress').toList();
        _completedTrips = trips.where((t) => t['status'] == 'completed').toList();
      }
    } catch (e) {
      debugPrint('Trips error: $e');
    }
    setState(() => _isLoading = false);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'inProgress': return const Color(0xFFD97706);
      case 'completed': return const Color(0xFF059669);
      case 'scheduled': return const Color(0xFF2563EB);
      default: return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'inProgress': return Icons.play_circle;
      case 'completed': return Icons.check_circle;
      case 'scheduled': return Icons.schedule;
      default: return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                child: TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.upcoming, size: 18),
                        const SizedBox(width: 6),
                        Text('Upcoming (${_upcomingTrips.length})'),
                      ],
                    )),
                    Tab(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 18),
                        const SizedBox(width: 6),
                        Text('Completed (${_completedTrips.length})'),
                      ],
                    )),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTripTable(_upcomingTrips),
                    _buildTripTable(_completedTrips),
                  ],
                ),
              ),
            ],
          );
  }

  Widget _buildTripTable(List<dynamic> trips) {
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 64, color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 16),
            Text('No trips found', style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5)),
          columns: const [
            DataColumn(label: Text('Route', style: TextStyle(fontWeight: FontWeight.w600))),
            DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.w600))),
            DataColumn(label: Text('Vehicle', style: TextStyle(fontWeight: FontWeight.w600))),
            DataColumn(label: Text('Scheduled', style: TextStyle(fontWeight: FontWeight.w600))),
            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w600))),
          ],
          rows: trips.map((trip) {
            final status = trip['status'] ?? 'scheduled';
            final statusColor = _statusColor(status);
            final routeName = trip['routeName'] ?? trip['routeId'] ?? 'Unknown Route';
            final type = trip['type'] ?? 'N/A';
            final vehiclePlate = trip['vehiclePlate'] ?? '-';
            final scheduledTime = trip['scheduledTime']?.toString() ?? '';

            return DataRow(cells: [
              DataCell(Text(routeName, style: const TextStyle(fontWeight: FontWeight.w500))),
              DataCell(Text(type)),
              DataCell(Text(vehiclePlate)),
              DataCell(Text(scheduledTime.length >= 16 ? scheduledTime.substring(0, 16) : scheduledTime)),
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
                      Icon(_statusIcon(status), size: 14, color: statusColor),
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
    );
  }
}
