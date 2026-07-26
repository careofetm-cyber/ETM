import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';
import '../../shared/widgets/stat_card.dart';

final superDashboardProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final api = await ref.watch(superAdminApiProvider.future);
  return api.getDashboard();
});

final billingSummaryForDashboardProvider = FutureProvider<List<CompanyBillingSummary>>((ref) async {
  final api = await ref.watch(superAdminApiProvider.future);
  return api.getBillingSummary();
});

class SuperDashboardScreen extends ConsumerWidget {
  const SuperDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(superDashboardProvider);
    final summaryAsync = ref.watch(billingSummaryForDashboardProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Super Admin Dashboard',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    ref.invalidate(superDashboardProvider);
                    ref.invalidate(billingSummaryForDashboardProvider);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            dashboardAsync.when(
              data: (data) => Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  StatCard(
                    title: 'Total Companies',
                    value: '${data['totalCompanies'] ?? 0}',
                    icon: Icons.business,
                    color: AppColors.primary,
                  ),
                  StatCard(
                    title: 'Active Companies',
                    value: '${data['activeCompanies'] ?? 0}',
                    icon: Icons.check_circle,
                    color: AppColors.success,
                  ),
                  StatCard(
                    title: 'Total Trips This Month',
                    value: '${data['totalTripsThisMonth'] ?? 0}',
                    icon: Icons.trip_origin,
                    color: AppColors.info,
                  ),
                  StatCard(
                    title: 'Total Revenue',
                    value: '\$${((data['totalRevenue'] ?? 0) as num).toStringAsFixed(2)}',
                    icon: Icons.attach_money,
                    color: AppColors.accent,
                  ),
                  StatCard(
                    title: 'Total Drivers',
                    value: '${data['totalDrivers'] ?? 0}',
                    icon: Icons.person,
                    color: AppColors.secondary,
                  ),
                  StatCard(
                    title: 'Total Vehicles',
                    value: '${data['totalVehicles'] ?? 0}',
                    icon: Icons.directions_bus,
                    color: AppColors.warning,
                  ),
                  StatCard(
                    title: 'Total Employees',
                    value: '${data['totalEmployees'] ?? 0}',
                    icon: Icons.people,
                    color: AppColors.info,
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Revenue by Company', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 16),
                            Expanded(
                              child: summaryAsync.when(
                                data: (summaries) {
                                  if (summaries.isEmpty) {
                                    return const Center(child: Text('No data'));
                                  }
                                  return BarChart(
                                    BarChartData(
                                      barGroups: summaries.asMap().entries.map((entry) {
                                        return BarChartGroupData(
                                          x: entry.key,
                                          barRods: [
                                            BarChartRodData(
                                              toY: entry.value.totalAmountThisMonth,
                                              color: AppColors.primary,
                                              width: 20,
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                      titlesData: FlTitlesData(
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              final idx = value.toInt();
                                              if (idx < summaries.length) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(top: 8),
                                                  child: Text(
                                                    summaries[idx].companyName.length > 10
                                                        ? '${summaries[idx].companyName.substring(0, 10)}...'
                                                        : summaries[idx].companyName,
                                                    style: const TextStyle(fontSize: 10),
                                                  ),
                                                );
                                              }
                                              return const Text('');
                                            },
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 60,
                                            getTitlesWidget: (value, meta) {
                                              return Text('\$${value.toInt()}', style: const TextStyle(fontSize: 10));
                                            },
                                          ),
                                        ),
                                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      gridData: const FlGridData(show: true),
                                    ),
                                  );
                                },
                                loading: () => const Center(child: CircularProgressIndicator()),
                                error: (e, _) => Center(child: Text('Error: $e')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Top Companies by Trips', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 16),
                            Expanded(
                              child: summaryAsync.when(
                                data: (summaries) {
                                  if (summaries.isEmpty) {
                                    return const Center(child: Text('No data'));
                                  }
                                  final sorted = List<CompanyBillingSummary>.from(summaries)
                                    ..sort((a, b) => b.totalTripsThisMonth.compareTo(a.totalTripsThisMonth));
                                  final top = sorted.take(5).toList();
                                  return ListView.builder(
                                    itemCount: top.length,
                                    itemBuilder: (context, index) {
                                      final s = top[index];
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: AppColors.primary.withOpacity(0.1),
                                          child: Text('${index + 1}', style: const TextStyle(color: AppColors.primary)),
                                        ),
                                        title: Text(s.companyName),
                                        subtitle: Text('${s.totalTripsThisMonth} trips'),
                                        trailing: Text('\$${s.totalAmountThisMonth.toStringAsFixed(2)}'),
                                      );
                                    },
                                  );
                                },
                                loading: () => const Center(child: CircularProgressIndicator()),
                                error: (e, _) => Center(child: Text('Error: $e')),
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
          ],
        ),
      ),
    );
  }
}
