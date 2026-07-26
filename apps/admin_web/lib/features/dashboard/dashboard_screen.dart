import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';
import '../../shared/widgets/stat_card.dart';

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final api = await ref.watch(dashboardApiProvider.future);
  return api.getAdminDashboard();
});

final activeTripsProvider = FutureProvider<List<Trip>>((ref) async {
  final api = await ref.watch(tripApiProvider.future);
  return api.getTrips(status: 'inProgress');
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    ref.invalidate(dashboardStatsProvider);
                    ref.invalidate(activeTripsProvider);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            statsAsync.when(
              data: (stats) => Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  StatCard(
                    title: 'Total Vehicles',
                    value: stats.totalVehicles.toString(),
                    icon: Icons.directions_bus,
                    color: AppColors.primary,
                  ),
                  StatCard(
                    title: 'Active Vehicles',
                    value: stats.activeVehicles.toString(),
                    icon: Icons.check_circle,
                    color: AppColors.success,
                  ),
                  StatCard(
                    title: 'Active Trips',
                    value: stats.activeTrips.toString(),
                    icon: Icons.trip_origin,
                    color: AppColors.accent,
                  ),
                  StatCard(
                    title: 'Total Employees',
                    value: stats.totalEmployees.toString(),
                    icon: Icons.people,
                    color: AppColors.info,
                  ),
                  StatCard(
                    title: 'Completed Today',
                    value: stats.completedTripsToday.toString(),
                    icon: Icons.done_all,
                    color: AppColors.secondary,
                  ),
                  StatCard(
                    title: 'Pending Requests',
                    value: stats.pendingRequests.toString(),
                    icon: Icons.pending_actions,
                    color: AppColors.warning,
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Trips',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ref.watch(activeTripsProvider).when(
                          data: (trips) {
                            if (trips.isEmpty) {
                              return const Center(child: Text('No active trips'));
                            }
                            return DataTable2(
                              columns: const [
                                DataColumn2(label: Text('Route')),
                                DataColumn2(label: Text('Vehicle')),
                                DataColumn2(label: Text('Driver')),
                                DataColumn2(label: Text('Type')),
                                DataColumn2(label: Text('Status')),
                                DataColumn2(label: Text('Passengers')),
                              ],
                              rows: trips.map((trip) {
                                return DataRow2(cells: [
                                  DataCell(Text(trip.routeId)),
                                  DataCell(Text(trip.vehicleId)),
                                  DataCell(Text(trip.driverId)),
                                  DataCell(Text(trip.type == TripType.pickup ? 'Pickup' : 'Dropoff')),
                                  DataCell(Chip(
                                    label: Text(trip.statusDisplay),
                                    backgroundColor: AppColors.success.withOpacity(0.1),
                                  )),
                                  DataCell(Text(
                                    '${trip.boardedPassengers ?? 0}/${trip.totalPassengers ?? 0}',
                                  )),
                                ]);
                              }).toList(),
                            );
                          },
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (error, stack) => Center(child: Text('Error: $error')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
