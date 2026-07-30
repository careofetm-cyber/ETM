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

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
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
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  _buildGreeting(),
                  const SizedBox(height: 20),
                  if (_dashboard != null) ...[
                    _buildStatGrid(),
                    const SizedBox(height: 24),
                    if (_dashboard!['hasUpcomingTrip'] == true) ...[
                      _buildNextTripCard(),
                      const SizedBox(height: 24),
                    ],
                    _buildSOSButton(),
                    const SizedBox(height: 24),
                    _buildQuickActionsHeader(),
                    const SizedBox(height: 12),
                    _buildQuickActionsGrid(),
                  ],
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_greeting,',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _userName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: _userName.isNotEmpty
              ? Text(
                  _userName[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : Icon(Icons.person, size: 24, color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }

  Widget _buildStatGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard(
              'Today\'s Trips', '${_dashboard!['todayTrips'] ?? 0}',
              Icons.directions_bus, const Color(0xFF2563EB), const Color(0xFFDBEAFE),
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard(
              'This Week', '${_dashboard!['weekTrips'] ?? 0}',
              Icons.calendar_view_week, const Color(0xFF059669), const Color(0xFFD1FAE5),
            )),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatCard(
              'Pending', '${_dashboard!['pendingRequests'] ?? 0}',
              Icons.pending_actions, const Color(0xFFD97706), const Color(0xFFFEF3C7),
            )),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard(
              'Completed', '${_dashboard!['completedTrips'] ?? 0}',
              Icons.check_circle, const Color(0xFF7C3AED), const Color(0xFFEDE9FE),
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 13, color: color.withOpacity(0.7), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildNextTripCard() {
    final cs = Theme.of(context).colorScheme;
    final trip = _dashboard!['nextTrip'];
    if (trip == null) return const SizedBox.shrink();
    final routeName = trip['routeName'] ?? 'Assigned Route';
    final vehiclePlate = trip['vehiclePlate'] ?? '';
    final driverName = trip['driverName'] ?? '';
    final scheduledTime = (trip['scheduledTime'] ?? '').toString();
    final timePart = scheduledTime.length >= 16 ? scheduledTime.substring(11, 16) : scheduledTime;
    final datePart = scheduledTime.length >= 10 ? scheduledTime.substring(0, 10) : '';

    return Card(
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
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.directions_bus, color: cs.onPrimaryContainer),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Next Assigned Trip', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(routeName, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                if (vehiclePlate.isNotEmpty) ...[
                  Icon(Icons.directions_car, size: 16, color: cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(vehiclePlate, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
                  const SizedBox(width: 16),
                ],
                if (driverName.isNotEmpty) ...[
                  Icon(Icons.person, size: 16, color: cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(driverName, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
                  const SizedBox(width: 16),
                ],
                if (timePart.isNotEmpty) ...[
                  Icon(Icons.access_time, size: 16, color: cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('$datePart $timePart', style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSOSButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showSOSDialog(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFDC2626).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emergency, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                'SOS - Emergency Alert',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsHeader() {
    return Text(
      'Quick Actions',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildQuickActionsGrid() {
    final actions = [
      _QuickAction(Icons.route, 'My Trips', () => context.go('/trips'), const Color(0xFF2563EB)),
      _QuickAction(Icons.calendar_month, 'Roster', () => context.go('/roster'), const Color(0xFF7C3AED)),
      _QuickAction(Icons.swap_horiz, 'Requests', () => context.push('/request-adjustment'), const Color(0xFFD97706)),
      _QuickAction(Icons.warning_amber, 'Incidents', () => context.push('/incidents'), const Color(0xFFDC2626)),
      _QuickAction(Icons.location_on, 'Tracking', () => context.push('/tracking'), const Color(0xFF059669)),
      _QuickAction(Icons.notifications, 'Alerts', () => context.push('/notifications'), const Color(0xFF6366F1)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final a = actions[index];
        return _buildQuickActionCard(a);
      },
    );
  }

  Widget _buildQuickActionCard(_QuickAction action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: action.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(action.icon, size: 24, color: action.color),
              ),
              const SizedBox(height: 8),
              Text(
                action.label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSOSDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.red),
        title: const Text('Send SOS Alert?'),
        content: const Text('This will immediately alert your transport manager and emergency contacts. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            icon: const Icon(Icons.send),
            label: const Text('SEND SOS'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      final dio = ref.read(dioProvider);
      await dio.post('/sos/', data: {'message': 'Emergency SOS alert from employee'});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SOS alert sent successfully'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send SOS: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  const _QuickAction(this.icon, this.label, this.onTap, this.color);
}
