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
    final width = MediaQuery.of(context).size.width;
    final padding = width < 600 ? 16.0 : width < 900 ? 24.0 : 32.0;

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: cs.error),
                        const SizedBox(height: 12),
                        Text(_error!, style: TextStyle(color: cs.error, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 16),
                        FilledButton.icon(onPressed: _loadTrips, icon: const Icon(Icons.refresh), label: const Text('Retry')),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(padding, padding, padding, 0),
                        child: TabBar(
                          controller: _tabController,
                          labelColor: cs.primary,
                          unselectedLabelColor: cs.onSurfaceVariant,
                          indicatorColor: cs.primary,
                          dividerColor: Colors.transparent,
                          tabs: [
                            Tab(text: 'Today (${_todayTrips.length})'),
                            Tab(text: 'Upcoming (${_upcomingTrips.length})'),
                            Tab(text: 'Completed (${_completedTrips.length})'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildTripList(_todayTrips, showAction: true, padding: padding),
                            _buildTripList(_upcomingTrips, showAction: false, padding: padding),
                            _buildCompletedList(_completedTrips, padding: padding),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildTripList(List<dynamic> trips, {required bool showAction, double padding = 16}) {
    final cs = Theme.of(context).colorScheme;
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.route_outlined, size: 56, color: cs.onSurfaceVariant.withOpacity(0.4)),
            const SizedBox(height: 12),
            Text('No trips found', style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTrips,
      child: ListView.builder(
        padding: EdgeInsets.all(padding),
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

          Color statusColor;
          String statusLabel;
          switch (status) {
            case 'inProgress':
              statusColor = Colors.orange;
              statusLabel = 'In Progress';
              break;
            case 'completed':
              statusColor = Colors.green;
              statusLabel = 'Completed';
              break;
            case 'cancelled':
              statusColor = Colors.red;
              statusLabel = 'Cancelled';
              break;
            default:
              statusColor = cs.primary;
              statusLabel = 'Scheduled';
          }

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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: (isPickup ? cs.primary : cs.tertiary).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPickup ? Icons.arrow_upward : Icons.arrow_downward,
                              size: 12,
                              color: isPickup ? cs.primary : cs.tertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isPickup ? 'Pickup' : 'Dropoff',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isPickup ? cs.primary : cs.tertiary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              status == 'inProgress'
                                  ? Icons.play_circle_outline
                                  : status == 'completed'
                                      ? Icons.check_circle_outline
                                      : status == 'cancelled'
                                          ? Icons.cancel_outlined
                                          : Icons.schedule_outlined,
                              size: 11,
                              color: statusColor,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              statusLabel,
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(timePart, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.route, size: 18, color: cs.primary),
                      const SizedBox(width: 8),
                      Expanded(child: Text(routeName, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600))),
                    ],
                  ),
                  if (vehiclePlate.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.directions_bus, size: 18, color: cs.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Text(vehiclePlate, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.people_outlined, size: 16, color: cs.onSurfaceVariant),
                            const SizedBox(width: 6),
                            Text('$boardedCount/$passengerCount pax', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (showAction) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => context.push('/trip/${trip['id']}'),
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: const Text('View Trip'),
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

  Widget _buildCompletedList(List<dynamic> trips, {double padding = 16}) {
    final cs = Theme.of(context).colorScheme;
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outlined, size: 56, color: cs.onSurfaceVariant.withOpacity(0.4)),
            const SizedBox(height: 12),
            Text('No completed trips', style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTrips,
      child: ListView.builder(
        padding: EdgeInsets.all(padding),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.check_circle, color: Colors.green.shade600, size: 22),
              ),
              title: Text(routeName, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('$datePart  •  $timePart', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
                  const SizedBox(width: 8),
                  Icon(Icons.people_outlined, size: 14, color: cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('$passengerCount pax', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 12, color: Colors.green.shade700),
                    const SizedBox(width: 4),
                    Text('Done', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.green.shade700)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


