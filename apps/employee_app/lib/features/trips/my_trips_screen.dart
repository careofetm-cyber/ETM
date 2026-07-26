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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Upcoming (${_upcomingTrips.length})'),
            Tab(text: 'Completed (${_completedTrips.length})'),
          ],
        ),
      ),
      body: SafeArea(
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
    );
  }

  Widget _buildTripList(List<dynamic> trips, {required bool isUpcoming}) {
    if (trips.isEmpty) {
      return Center(child: Text(isUpcoming ? 'No upcoming trips' : 'No completed trips'));
    }
    return RefreshIndicator(
      onRefresh: _loadTrips,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          final statusColor = trip['status'] == 'inProgress' ? Colors.orange
              : trip['status'] == 'completed' ? Colors.green : Colors.blue;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: statusColor, child: Icon(isUpcoming ? Icons.directions_bus : Icons.check, color: Colors.white)),
              title: Text(trip['routeName'] ?? trip['route_id'] ?? 'Unknown Route', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Type: ${trip['type'] ?? "N/A"} | Status: ${trip['status'] ?? "N/A"}'),
                  if (trip['vehiclePlate'] != null && trip['vehiclePlate'].toString().isNotEmpty)
                    Text('Vehicle: ${trip['vehiclePlate']}', style: const TextStyle(fontSize: 12)),
                  if (trip['scheduledTime'] != null)
                    Text(trip['scheduledTime'].toString().substring(0, 16), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              isThreeLine: true,
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
