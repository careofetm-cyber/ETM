import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../../shared/providers/api_providers.dart';

class DriverDashboardScreen extends ConsumerStatefulWidget {
  const DriverDashboardScreen({super.key});
  @override
  ConsumerState<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends ConsumerState<DriverDashboardScreen> {
  String _driverName = 'Driver';
  bool _isLoading = true;
  Map<String, dynamic>? _dashboard;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      _driverName = prefs.getString('user_name') ?? 'Driver';
      final dio = ref.read(dioProvider);
      final resp = await dio.get('/dashboard/driver');
      _dashboard = resp.data;
    } on DioException catch (e) {
      setState(() => _error = e.response?.data?['error'] ?? 'Failed to load dashboard');
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
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good Morning' : hour < 17 ? 'Good Afternoon' : 'Good Evening';

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadData,
            child: ListView(
              padding: EdgeInsets.all(padding),
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cs.primary, cs.primary.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Text(
                          _driverName.isNotEmpty ? _driverName[0].toUpperCase() : 'D',
                          style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$greeting,',
                                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16)),
                            const SizedBox(height: 2),
                            Text(_driverName,
                                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      if (_dashboard?['assignedVehicle'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.directions_bus, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text(_dashboard!['assignedVehicle'],
                                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: cs.errorContainer, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: cs.onErrorContainer),
                        const SizedBox(width: 12),
                        Expanded(child: Text(_error!, style: TextStyle(color: cs.onErrorContainer, fontWeight: FontWeight.w500))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                Text("Today's Summary",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = constraints.maxWidth > 600
                        ? (constraints.maxWidth - 36) / 4
                        : (constraints.maxWidth - 12) / 2;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: _StatCard(
                              title: 'Total Trips',
                              value: '${_dashboard?['todayTrips'] ?? 0}',
                              icon: Icons.route_outlined,
                              color: cs.primary,
                              bgColor: cs.primaryContainer),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _StatCard(
                              title: 'Completed',
                              value: '${_dashboard?['completedTrips'] ?? 0}',
                              icon: Icons.check_circle_outlined,
                              color: Colors.green.shade700,
                              bgColor: Colors.green.shade50),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _StatCard(
                              title: 'Passengers',
                              value: '${_dashboard?['totalPassengers'] ?? 0}',
                              icon: Icons.people_outlined,
                              color: Colors.orange.shade700,
                              bgColor: Colors.orange.shade50),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _StatCard(
                              title: 'Distance',
                              value: '${(_dashboard?['totalDistance'] ?? 0).toStringAsFixed(1)} km',
                              icon: Icons.straighten,
                              color: Colors.purple.shade700,
                              bgColor: Colors.purple.shade50),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                if (_dashboard?['currentTripId'] != null) ...[
                  Text('Current Trip',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(color: cs.primaryContainer, borderRadius: BorderRadius.circular(14)),
                                child: Icon(Icons.directions_bus, color: cs.onPrimaryContainer, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Trip In Progress',
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 2),
                                    Text('Tap to view details',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () => context.push('/driver/trip/${_dashboard!['currentTripId']}'),
                              icon: const Icon(Icons.open_in_new),
                              label: const Text('View Trip'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                if (_dashboard?['nextScheduledTrip'] != null) ...[
                  Text('Next Scheduled Trip',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(14)),
                                child: Icon(Icons.schedule_outlined, color: Colors.orange.shade700, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_dashboard!['nextScheduledTrip']['routeName'] ?? 'Scheduled Trip',
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Time: ${(_dashboard!['nextScheduledTrip']['scheduledTime'] ?? '').toString().substring(11, 16)}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                Text('Quick Actions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final actionWidth = constraints.maxWidth > 600
                        ? (constraints.maxWidth - 24) / 3
                        : (constraints.maxWidth - 12) / 2;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: actionWidth,
                          child: _ActionTile(
                              icon: Icons.route_outlined,
                              label: 'My Trips',
                              color: cs.primary,
                              bgColor: cs.primaryContainer,
                              onTap: () => context.go('/driver/trips')),
                        ),
                        SizedBox(
                          width: actionWidth,
                          child: _ActionTile(
                              icon: Icons.person_outline,
                              label: 'Profile',
                              color: Colors.teal.shade700,
                              bgColor: Colors.teal.shade50,
                              onTap: () => context.go('/profile')),
                        ),
                        SizedBox(
                          width: actionWidth,
                          child: _ActionTile(
                              icon: Icons.notifications_outlined,
                              label: 'Notifications',
                              color: Colors.indigo.shade700,
                              bgColor: Colors.indigo.shade50,
                              onTap: () => context.go('/notifications')),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;
  const _StatCard(
      {required this.title, required this.value, required this.icon, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 14),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color.withOpacity(0.8))),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;
  const _ActionTile(
      {required this.icon, required this.label, required this.color, required this.bgColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
