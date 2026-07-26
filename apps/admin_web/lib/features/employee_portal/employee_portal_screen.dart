import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

final _employeeIdProvider = StateProvider<String>((ref) => '');

final _employeeTripsProvider = FutureProvider<List<Trip>>((ref) async {
  final employeeId = ref.watch(_employeeIdProvider);
  if (employeeId.isEmpty) return [];
  final api = await ref.watch(tripApiProvider.future);
  return api.getTrips(limit: 50);
});

final _employeesListProvider = FutureProvider<List<Employee>>((ref) async {
  final api = await ref.watch(employeeApiProvider.future);
  return api.getEmployees(limit: 100);
});

class EmployeePortalScreen extends ConsumerStatefulWidget {
  const EmployeePortalScreen({super.key});

  @override
  ConsumerState<EmployeePortalScreen> createState() => _EmployeePortalScreenState();
}

class _EmployeePortalScreenState extends ConsumerState<EmployeePortalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Employee Portal',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                SizedBox(
                  width: 300,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final employeesAsync = ref.watch(_employeesListProvider);
                      return employeesAsync.when(
                        data: (employees) => DropdownButtonFormField<String>(
                          value: ref.watch(_employeeIdProvider).isEmpty ? null : ref.watch(_employeeIdProvider),
                          decoration: const InputDecoration(
                            hintText: 'Select Employee',
                            prefixIcon: Icon(Icons.person_search),
                          ),
                          items: employees.map<DropdownMenuItem<String>>((emp) => DropdownMenuItem<String>(
                            value: emp.id,
                            child: Text(emp.email ?? emp.id),
                          )).toList(),
                          onChanged: (v) {
                            ref.read(_employeeIdProvider.notifier).state = v ?? '';
                          },
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) => Text('Error: $e'),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'My Trips', icon: Icon(Icons.route)),
                Tab(text: 'Roster View', icon: Icon(Icons.calendar_view_week)),
                Tab(text: 'Ride History', icon: Icon(Icons.history)),
                Tab(text: 'Adjustments', icon: Icon(Icons.swap_horiz)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMyTripsTab(),
                  _buildRosterViewTab(),
                  _buildRideHistoryTab(),
                  _buildAdjustmentsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyTripsTab() {
    final employeeId = ref.watch(_employeeIdProvider);

    if (employeeId.isEmpty) {
      return const Center(child: Text('Select an employee to view trips'));
    }

    final tripsAsync = ref.watch(_employeeTripsProvider);

    return tripsAsync.when(
      data: (trips) {
        final upcoming = trips.where((t) =>
            t.status == TripStatus.scheduled ||
            t.status == TripStatus.inProgress).toList();
        if (upcoming.isEmpty) {
          return const Center(child: Text('No upcoming trips'));
        }
        return ListView.builder(
          itemCount: upcoming.length,
          itemBuilder: (context, index) {
            final trip = upcoming[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          trip.type == TripType.pickup ? Icons.arrow_upward : Icons.arrow_downward,
                          color: trip.type == TripType.pickup ? AppColors.primary : AppColors.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          trip.type == TripType.pickup ? 'Pickup Trip' : 'Dropoff Trip',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Spacer(),
                        _buildStatusChip(trip.status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _detailRow('Vehicle', trip.vehicleId),
                    _detailRow('Driver', trip.driverId),
                    _detailRow('Route', trip.routeId),
                    _detailRow('Scheduled', '${trip.scheduledTime.day}/${trip.scheduledTime.month}/${trip.scheduledTime.year} '
                        '${trip.scheduledTime.hour}:${trip.scheduledTime.minute.toString().padLeft(2, '0')}'),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildRosterViewTab() {
    final employeeId = ref.watch(_employeeIdProvider);

    if (employeeId.isEmpty) {
      return const Center(child: Text('Select an employee to view roster'));
    }

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final days = List.generate(7, (i) => startOfWeek.add(Duration(days: i)));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Schedule - ${startOfWeek.day}/${startOfWeek.month}/${startOfWeek.year}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1.2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 7,
                itemBuilder: (context, index) {
                  final day = days[index];
                  final isToday = day.year == now.year && day.month == now.month && day.day == now.day;
                  return Card(
                    color: isToday ? AppColors.primaryLight.withOpacity(0.1) : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _dayName(day.weekday),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: isToday ? AppColors.primary : null,
                            ),
                          ),
                          Text(
                            '${day.day}/${day.month}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isToday ? AppColors.primary : AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Scheduled',
                              style: TextStyle(fontSize: 10, color: AppColors.success),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRideHistoryTab() {
    final employeeId = ref.watch(_employeeIdProvider);

    if (employeeId.isEmpty) {
      return const Center(child: Text('Select an employee to view ride history'));
    }

    final tripsAsync = ref.watch(_employeeTripsProvider);

    return tripsAsync.when(
      data: (trips) {
        final completed = trips.where((t) => t.status == TripStatus.completed).toList();
        if (completed.isEmpty) {
          return const Center(child: Text('No completed trips'));
        }
        return ListView.builder(
          itemCount: completed.length,
          itemBuilder: (context, index) {
            final trip = completed[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  trip.type == TripType.pickup ? Icons.arrow_upward : Icons.arrow_downward,
                  color: AppColors.textSecondary,
                ),
                title: Text('Route ${trip.routeId}'),
                subtitle: Text('Vehicle ${trip.vehicleId} - Driver ${trip.driverId}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildStatusChip(trip.status),
                    if (trip.totalDistance != null)
                      Text(
                        '${trip.totalDistance!.toStringAsFixed(1)} km',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildAdjustmentsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.swap_horiz, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          const Text(
            'Request Cab Assignment Adjustment',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Request changes to your cab assignment, route, or schedule.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAdjustmentRequestDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Request Adjustment'),
          ),
        ],
      ),
    );
  }

  void _showAdjustmentRequestDialog(BuildContext context) {
    String adjustmentType = 'cab_change';
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Request Adjustment'),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: adjustmentType,
                    decoration: const InputDecoration(labelText: 'Adjustment Type'),
                    items: const [
                      DropdownMenuItem(value: 'cab_change', child: Text('Change Cab Assignment')),
                      DropdownMenuItem(value: 'route_change', child: Text('Change Route')),
                      DropdownMenuItem(value: 'schedule_change', child: Text('Change Schedule')),
                      DropdownMenuItem(value: 'other', child: Text('Other')),
                    ],
                    onChanged: (v) => setDialogState(() => adjustmentType = v!),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: reasonController,
                    decoration: const InputDecoration(
                      labelText: 'Reason *',
                      hintText: 'Explain why you need this adjustment',
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: reasonController.text.isEmpty ? null : () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Adjustment request submitted'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(TripStatus status) {
    Color color;
    String label;

    switch (status) {
      case TripStatus.scheduled:
        color = AppColors.info;
        label = 'Scheduled';
        break;
      case TripStatus.inProgress:
        color = AppColors.success;
        label = 'In Progress';
        break;
      case TripStatus.completed:
        color = AppColors.secondary;
        label = 'Completed';
        break;
      case TripStatus.cancelled:
        color = AppColors.error;
        label = 'Cancelled';
        break;
    }

    return Chip(
      label: Text(label, style: TextStyle(color: color, fontSize: 12)),
      backgroundColor: color.withOpacity(0.1),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  String _dayName(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }
}
