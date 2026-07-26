import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';
import '../../shared/widgets/stat_card.dart';

final billingTabProvider = StateProvider<int>((ref) => 0);
final billingCompanyFilterProvider = StateProvider<String>((ref) => 'all');
final billingBillableFilterProvider = StateProvider<String>((ref) => 'all');
final invoiceStatusFilterProvider = StateProvider<String>((ref) => 'all');
final invoiceCompanyFilterProvider = StateProvider<String>((ref) => 'all');

final billingRecordsProvider = FutureProvider<List<BillingRecord>>((ref) async {
  final api = await ref.watch(superAdminApiProvider.future);
  final company = ref.watch(billingCompanyFilterProvider);
  final billable = ref.watch(billingBillableFilterProvider);
  return api.getBillingRecords(
    companyId: company == 'all' ? null : company,
    billable: billable == 'all' ? null : billable == 'yes',
  );
});

final invoicesProvider = FutureProvider<List<Invoice>>((ref) async {
  final api = await ref.watch(superAdminApiProvider.future);
  final company = ref.watch(invoiceCompanyFilterProvider);
  final status = ref.watch(invoiceStatusFilterProvider);
  return api.getInvoices(
    companyId: company == 'all' ? null : company,
    status: status == 'all' ? null : status,
  );
});

final billingSummaryProvider = FutureProvider<List<CompanyBillingSummary>>((ref) async {
  final api = await ref.watch(superAdminApiProvider.future);
  return api.getBillingSummary();
});

final _billingCompaniesProvider = FutureProvider<List<Company>>((ref) async {
  final api = await ref.watch(superAdminApiProvider.future);
  return api.getCompanies();
});

class BillingScreen extends ConsumerWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(billingTabProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Billing',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Trip Billing Records')),
                ButtonSegment(value: 1, label: Text('Invoices')),
              ],
              selected: {tabIndex},
              onSelectionChanged: (v) => ref.read(billingTabProvider.notifier).state = v.first,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: tabIndex == 0
                  ? const _BillingRecordsTab()
                  : const _InvoicesTab(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillingRecordsTab extends ConsumerWidget {
  const _BillingRecordsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(billingRecordsProvider);
    final summaryAsync = ref.watch(billingSummaryProvider);

    return Column(
      children: [
        summaryAsync.when(
          data: (summaries) {
            int totalTrips = 0;
            int billableTrips = 0;
            int discardedTrips = 0;
            double totalRevenue = 0;
            for (final s in summaries) {
              totalTrips += s.totalTripsThisMonth;
              billableTrips += s.billableTripsThisMonth;
              discardedTrips += s.discardedTripsThisMonth;
              totalRevenue += s.totalAmountThisMonth;
            }
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                StatCard(title: 'Total Trips', value: totalTrips.toString(), icon: Icons.trip_origin, color: AppColors.primary),
                StatCard(title: 'Billable Trips', value: billableTrips.toString(), icon: Icons.check_circle, color: AppColors.success),
                StatCard(title: 'Discarded Trips', value: discardedTrips.toString(), icon: Icons.cancel, color: AppColors.error),
                StatCard(title: 'Total Revenue', value: '\$${totalRevenue.toStringAsFixed(2)}', icon: Icons.attach_money, color: AppColors.accent),
              ],
            );
          },
          loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
          error: (e, _) => SizedBox(height: 100, child: Center(child: Text('Error: $e'))),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Consumer(
              builder: (context, ref, _) {
                final companiesAsync = ref.watch(_billingCompaniesProvider);
                return companiesAsync.when(
                  data: (companies) => DropdownButton<String>(
                    value: ref.watch(billingCompanyFilterProvider),
                    items: [
                      const DropdownMenuItem(value: 'all', child: Text('All Companies')),
                      ...companies.map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name),
                      )),
                    ],
                    onChanged: (v) => ref.read(billingCompanyFilterProvider.notifier).state = v!,
                  ),
                  loading: () => const SizedBox(width: 200, child: LinearProgressIndicator()),
                  error: (_, __) => DropdownButton<String>(
                    value: 'all',
                    items: const [DropdownMenuItem(value: 'all', child: Text('All Companies'))],
                    onChanged: (v) => ref.read(billingCompanyFilterProvider.notifier).state = v!,
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            DropdownButton<String>(
              value: ref.watch(billingBillableFilterProvider),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'yes', child: Text('Billable')),
                DropdownMenuItem(value: 'no', child: Text('Non-Billable')),
              ],
              onChanged: (v) => ref.read(billingBillableFilterProvider.notifier).state = v!,
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.invalidate(billingRecordsProvider);
                ref.invalidate(billingSummaryProvider);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: recordsAsync.when(
                data: (records) {
                  if (records.isEmpty) {
                    return const Center(child: Text('No billing records found'));
                  }
                  return DataTable2(
                    columns: const [
                      DataColumn2(label: Text('Company'), size: ColumnSize.L),
                      DataColumn2(label: Text('Trip ID')),
                      DataColumn2(label: Text('Distance')),
                      DataColumn2(label: Text('Cost')),
                      DataColumn2(label: Text('Billable')),
                      DataColumn2(label: Text('Discard Reason')),
                      DataColumn2(label: Text('Date')),
                    ],
                    rows: records.map((record) {
                      return DataRow2(cells: [
                        DataCell(Text(record.companyId)),
                        DataCell(Text(record.tripId)),
                        DataCell(Text('${record.distance.toStringAsFixed(2)} km')),
                        DataCell(Text('\$${record.tripCost.toStringAsFixed(2)}')),
                        DataCell(Chip(
                          label: Text(record.isBillable == true ? 'Yes' : 'No'),
                          backgroundColor: (record.isBillable == true ? AppColors.success : AppColors.textSecondary).withOpacity(0.1),
                        )),
                        DataCell(Text(record.discardReason ?? '-')),
                        DataCell(Text(record.completedAt != null
                            ? '${record.completedAt!.day}/${record.completedAt!.month}/${record.completedAt!.year}'
                            : '-')),
                      ]);
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InvoicesTab extends ConsumerWidget {
  const _InvoicesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(invoicesProvider);

    return Column(
      children: [
        Row(
          children: [
            Consumer(
              builder: (context, ref, _) {
                final companiesAsync = ref.watch(_billingCompaniesProvider);
                return companiesAsync.when(
                  data: (companies) => DropdownButton<String>(
                    value: ref.watch(invoiceCompanyFilterProvider),
                    items: [
                      const DropdownMenuItem(value: 'all', child: Text('All Companies')),
                      ...companies.map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name),
                      )),
                    ],
                    onChanged: (v) => ref.read(invoiceCompanyFilterProvider.notifier).state = v!,
                  ),
                  loading: () => const SizedBox(width: 200, child: LinearProgressIndicator()),
                  error: (_, __) => DropdownButton<String>(
                    value: 'all',
                    items: const [DropdownMenuItem(value: 'all', child: Text('All Companies'))],
                    onChanged: (v) => ref.read(invoiceCompanyFilterProvider.notifier).state = v!,
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            DropdownButton<String>(
              value: ref.watch(invoiceStatusFilterProvider),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Status')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'paid', child: Text('Paid')),
                DropdownMenuItem(value: 'overdue', child: Text('Overdue')),
              ],
              onChanged: (v) => ref.read(invoiceStatusFilterProvider.notifier).state = v!,
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(invoicesProvider),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: invoicesAsync.when(
                data: (invoices) {
                  if (invoices.isEmpty) {
                    return const Center(child: Text('No invoices found'));
                  }
                  return DataTable2(
                    columns: const [
                      DataColumn2(label: Text('Company'), size: ColumnSize.L),
                      DataColumn2(label: Text('Month')),
                      DataColumn2(label: Text('Total Trips')),
                      DataColumn2(label: Text('Billable Trips')),
                      DataColumn2(label: Text('Amount')),
                      DataColumn2(label: Text('Status')),
                      DataColumn2(label: Text('Due Date')),
                      DataColumn2(label: Text('Actions'), size: ColumnSize.S),
                    ],
                    rows: invoices.map((invoice) {
                      return DataRow2(cells: [
                        DataCell(Text(invoice.companyId)),
                        DataCell(Text(invoice.month)),
                        DataCell(Text('${invoice.totalTrips}')),
                        DataCell(Text('${invoice.billableTrips}')),
                        DataCell(Text('\$${invoice.totalAmount.toStringAsFixed(2)}')),
                        DataCell(_buildInvoiceStatusChip(invoice.status)),
                        DataCell(Text(invoice.dueDate != null
                            ? '${invoice.dueDate!.day}/${invoice.dueDate!.month}/${invoice.dueDate!.year}'
                            : '-')),
                        DataCell(
                          invoice.status != 'paid'
                              ? IconButton(
                                  icon: const Icon(Icons.check_circle, size: 20, color: AppColors.success),
                                  onPressed: () async {
                                    final api = await ref.read(superAdminApiProvider.future);
                                    await api.updateInvoice(invoice.id, {'status': 'paid'});
                                    ref.invalidate(invoicesProvider);
                                  },
                                )
                              : const Icon(Icons.check, color: AppColors.success, size: 20),
                        ),
                      ]);
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceStatusChip(String status) {
    Color color;
    switch (status) {
      case 'paid':
        color = AppColors.success;
        break;
      case 'overdue':
        color = AppColors.error;
        break;
      case 'pending':
        color = AppColors.warning;
        break;
      default:
        color = AppColors.textSecondary;
    }
    return Chip(
      label: Text(status[0].toUpperCase() + status.substring(1), style: TextStyle(color: color)),
      backgroundColor: color.withOpacity(0.1),
    );
  }
}
