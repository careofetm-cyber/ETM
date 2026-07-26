import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../providers.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});
  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
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
    final greeting = DateTime.now().hour < 12 ? 'Good Morning' : DateTime.now().hour < 17 ? 'Good Afternoon' : 'Good Evening';

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), centerTitle: false),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: cs.primaryContainer,
                            child: Text(
                              _driverName.isNotEmpty ? _driverName[0].toUpperCase() : 'D',
                              style: TextStyle(color: cs.onPrimaryContainer, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$greeting, $_driverName', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                if (_dashboard?['assigned_vehicle'] != null)
                                  Text(_dashboard!['assigned_vehicle'], style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text("Today's Summary", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _StatCard(title: 'Total Trips', value: '${_dashboard?['today_trips'] ?? 0}', icon: Icons.route_outlined, color: cs.primary),
                      const SizedBox(width: 10),
                      _StatCard(title: 'Completed', value: '${_dashboard?['completed_trips'] ?? 0}', icon: Icons.check_circle_outlined, color: cs.tertiary),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _StatCard(title: 'Passengers', value: '${_dashboard?['total_passengers'] ?? 0}', icon: Icons.people_outlined, color: cs.secondary),
                      const SizedBox(width: 10),
                      _StatCard(title: 'Distance', value: '${(_dashboard?['total_distance'] ?? 0).toStringAsFixed(1)} km', icon: Icons.straighten, color: cs.tertiary),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (_error != null) ...[
                    Card(
                      color: cs.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: cs.onErrorContainer),
                            const SizedBox(width: 12),
                            Expanded(child: Text(_error!, style: TextStyle(color: cs.onErrorContainer))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  if (_dashboard?['current_trip_id'] != null) ...[
                    Text('Current Trip', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: cs.primaryContainer, borderRadius: BorderRadius.circular(10)),
                                  child: Icon(Icons.directions_bus, color: cs.onPrimaryContainer),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Trip In Progress', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                                      Text('Tap to view details', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.tonal(
                                onPressed: () => context.push('/trip/${_dashboard!['current_trip_id']}'),
                                child: const Text('View Trip'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _ActionTile(icon: Icons.route_outlined, label: 'My Trips', color: cs.primary, onTap: () => context.go('/trips'))),
                      const SizedBox(width: 10),
                      Expanded(child: _ActionTile(icon: Icons.person_outline, label: 'Profile', color: cs.tertiary, onTap: () => context.go('/profile'))),
                      const SizedBox(width: 10),
                      Expanded(child: _ActionTile(icon: Icons.emergency_outlined, label: 'SOS', color: cs.error, onTap: () {})),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 10),
              Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionTile({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
