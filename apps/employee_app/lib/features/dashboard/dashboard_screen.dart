import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});
  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Map<String, dynamic>? _dashboard;
  bool _isLoading = true;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      _userName = prefs.getString('user_name') ?? 'Employee';
      final dio = ref.read(dioProvider);
      final userId = prefs.getString('user_id');
      if (userId != null) {
        final resp = await dio.get('/dashboard/employee/$userId');
        _dashboard = resp.data;
      }
    } catch (e) {
      debugPrint('Dashboard error: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome, $_userName', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(_dashboard?['message'] ?? 'View your transport details below', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_dashboard != null) ...[
                    Row(
                      children: [
                        Expanded(child: _buildStatCard('Today\'s Trips', '${_dashboard!['todayTrips'] ?? 0}', Icons.directions_bus, Colors.blue)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('This Week', '${_dashboard!['weekTrips'] ?? 0}', Icons.calendar_view_week, Colors.green)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildStatCard('Pending Requests', '${_dashboard!['pendingRequests'] ?? 0}', Icons.pending_actions, Colors.orange)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('Completed', '${_dashboard!['completedTrips'] ?? 0}', Icons.check_circle, Colors.teal)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildQuickAction(Icons.directions_bus, 'My Trips', () => context.go('/trips'))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildQuickAction(Icons.calendar_month, 'Roster', () => context.go('/roster'))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildQuickAction(Icons.swap_horiz, 'Requests', () => context.go('/request-adjustment'))),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: const Color(0xFF2563EB)),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
