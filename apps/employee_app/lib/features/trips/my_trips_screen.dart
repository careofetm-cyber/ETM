import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

class MyTripsScreen extends ConsumerStatefulWidget {
  const MyTripsScreen({super.key});
  @override
  ConsumerState<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends ConsumerState<MyTripsScreen> with SingleTickerProviderStateMixin {
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

  Future<void> _loadTrips() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final userId = prefs.getString('user_id');
      if (userId != null) {
        final dio = ref.read(dioProvider);
        final resp = await dio.get('/trips/employee/$userId');
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
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
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTripList(_upcomingTrips, isUpcoming: true),
                        _buildTripList(_completedTrips, isUpcoming: false),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripList(List<dynamic> trips, {required bool isUpcoming}) {
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.event_available : Icons.task_alt,
              size: 64,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? 'No upcoming trips' : 'No completed trips',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadTrips,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          final status = trip['status'] ?? 'scheduled';
          final statusColor = _statusColor(status);
          final routeName = trip['routeName'] ?? trip['route_id'] ?? 'Unknown Route';
          final type = trip['type'] ?? 'N/A';
          final vehiclePlate = trip['vehiclePlate'] ?? '';
          final scheduledTime = trip['scheduledTime']?.toString() ?? '';

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
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(_statusIcon(status), color: statusColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(routeName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                            const SizedBox(height: 2),
                            Text('Type: $type', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_statusIcon(status), size: 12, color: statusColor),
                            const SizedBox(width: 4),
                            Text(
                              status[0].toUpperCase() + status.substring(1),
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (vehiclePlate.isNotEmpty || scheduledTime.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (vehiclePlate.isNotEmpty) ...[
                          Icon(Icons.directions_car, size: 16, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(vehiclePlate, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                          const SizedBox(width: 16),
                        ],
                        if (scheduledTime.isNotEmpty) ...[
                          Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            scheduledTime.length >= 16 ? scheduledTime.substring(0, 16) : scheduledTime,
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
