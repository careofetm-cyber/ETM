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
      backgroundColor: const Color(0xFFF0F4F8),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () {
                    ref.invalidate(dashboardStatsProvider);
                    ref.invalidate(activeTripsProvider);
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Refresh'),
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
                    icon: Icons.directions_bus_outlined,
                    color: AppColors.primary,
                  ),
                  StatCard(
                    title: 'Active Vehicles',
                    value: stats.activeVehicles.toString(),
                    icon: Icons.check_circle_outline,
                    color: AppColors.success,
                  ),
                  StatCard(
                    title: 'Active Trips',
                    value: stats.activeTrips.toString(),
                    icon: Icons.trip_origin_outlined,
                    color: AppColors.accent,
                  ),
                  StatCard(
                    title: 'Total Employees',
                    value: stats.totalEmployees.toString(),
                    icon: Icons.people_outline,
                    color: AppColors.info,
                  ),
                  StatCard(
                    title: 'Completed Today',
                    value: stats.completedTripsToday.toString(),
                    icon: Icons.done_all_rounded,
                    color: AppColors.secondary,
                  ),
                  StatCard(
                    title: 'Pending Requests',
                    value: stats.pendingRequests.toString(),
                    icon: Icons.pending_actions_rounded,
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
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE8ECF0), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.trip_origin_outlined, size: 20, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Active Trips',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ref.watch(activeTripsProvider).when(
                          data: (trips) {
                            if (trips.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.trip_origin_outlined, size: 48, color: AppColors.textTertiary),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No active trips',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return DataTable2(
                              columns: const [
                                DataColumn2(label: Text('Route'), size: ColumnSize.L),
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
                                    label: Text(
                                      trip.statusDisplay,
                                      style: TextStyle(
                                        color: AppColors.success,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    backgroundColor: AppColors.success.withOpacity(0.08),
                                    side: BorderSide.none,
                                    padding: EdgeInsets.zero,
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
