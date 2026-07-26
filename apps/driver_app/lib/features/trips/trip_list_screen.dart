import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../providers.dart';

class TripListScreen extends ConsumerStatefulWidget {
  const TripListScreen({super.key});
  @override
  ConsumerState<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends ConsumerState<TripListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _todayTrips = [];
  List<dynamic> _upcomingTrips = [];
  List<dynamic> _completedTrips = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      final dio = ref.read(dioProvider);
      final resp = await dio.get('/trips/driver');
      final trips = resp.data['data'] ?? [];
      final now = DateTime.now();
      final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      _todayTrips = trips.where((t) {
        final st = (t['scheduled_time'] ?? '').toString();
        return st.startsWith(todayStr) && t['status'] != 'completed' && t['status'] != 'cancelled';
      }).toList();

      _upcomingTrips = trips.where((t) {
        final st = (t['scheduled_time'] ?? '').toString();
        return !st.startsWith(todayStr) && (t['status'] == 'scheduled');
      }).toList();

      _completedTrips = trips.where((t) => t['status'] == 'completed').toList();
    } on DioException catch (e) {
      setState(() => _error = e.response?.data?['error'] ?? 'Failed to load trips');
    } catch (e) {
      setState(() => _error = 'Network error');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips'),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Today (${_todayTrips.length})'),
            Tab(text: 'Upcoming (${_upcomingTrips.length})'),
            Tab(text: 'Completed (${_completedTrips.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: cs.error),
                      const SizedBox(height: 12),
                      Text(_error!, style: TextStyle(color: cs.error)),
                      const SizedBox(height: 16),
                      FilledButton(onPressed: _loadTrips, child: const Text('Retry')),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTripList(_todayTrips, showAction: true),
                    _buildTripList(_upcomingTrips, showAction: false),
                    _buildCompletedList(_completedTrips),
                  ],
                ),
    );
  }

  Widget _buildTripList(List<dynamic> trips, {required bool showAction}) {
    final cs = Theme.of(context).colorScheme;
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.route_outlined, size: 56, color: cs.onSurfaceVariant.withOpacity(0.4)),
            const SizedBox(height: 12),
            Text('No trips', style: TextStyle(color: cs.onSurfaceVariant)),
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
          final tripType = trip['type'] ?? 'pickup';
          final isPickup = tripType == 'pickup';
          final status = trip['status'] ?? 'scheduled';
          final routeName = trip['routeName'] ?? trip['route_id'] ?? 'Unknown Route';
          final scheduledTime = (trip['scheduled_time'] ?? '').toString();
          final timePart = scheduledTime.length >= 16 ? scheduledTime.substring(11, 16) : '';
          final passengerCount = trip['passengerCount'] ?? 0;
          final boardedCount = trip['boardedCount'] ?? 0;
          final vehiclePlate = trip['vehiclePlate'] ?? '';

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (isPickup ? cs.primary : cs.tertiary).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isPickup ? 'Pickup' : 'Dropoff',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isPickup ? cs.primary : cs.tertiary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: status == 'inProgress' ? Colors.orange.withOpacity(0.1) : cs.surfaceContainerHighest.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: status == 'inProgress' ? Colors.orange : cs.onSurfaceVariant),
                        ),
                      ),
                      const Spacer(),
                      Text(timePart, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(routeName, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                  if (vehiclePlate.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Vehicle: $vehiclePlate', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _InfoPill(icon: Icons.people_outlined, label: '$boardedCount/$passengerCount pax'),
                    ],
                  ),
                  if (showAction) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => context.push('/trip/${trip['id']}'),
                        child: const Text('View Trip'),
                      ),
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

  Widget _buildCompletedList(List<dynamic> trips) {
    final cs = Theme.of(context).colorScheme;
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outlined, size: 56, color: cs.onSurfaceVariant.withOpacity(0.4)),
            const SizedBox(height: 12),
            Text('No completed trips', style: TextStyle(color: cs.onSurfaceVariant)),
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
          final routeName = trip['routeName'] ?? trip['route_id'] ?? 'Unknown Route';
          final scheduledTime = (trip['scheduled_time'] ?? '').toString();
          final datePart = scheduledTime.length >= 10 ? scheduledTime.substring(0, 10) : '';
          final timePart = scheduledTime.length >= 16 ? scheduledTime.substring(11, 16) : '';
          final passengerCount = trip['passengerCount'] ?? 0;

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: cs.tertiary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.check_circle_outlined, color: cs.tertiary, size: 22),
              ),
              title: Text(routeName, style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('$datePart \u2022 $timePart \u2022 $passengerCount passengers'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: cs.tertiary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text('Done', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: cs.tertiary)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
