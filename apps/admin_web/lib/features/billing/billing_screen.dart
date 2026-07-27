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
      backgroundColor: const Color(0xFFF0F4F8),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Billing',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
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
                StatCard(title: 'Total Trips', value: totalTrips.toString(), icon: Icons.trip_origin_outlined, color: AppColors.primary),
                StatCard(title: 'Billable Trips', value: billableTrips.toString(), icon: Icons.check_circle_outline, color: AppColors.success),
                StatCard(title: 'Discarded Trips', value: discardedTrips.toString(), icon: Icons.cancel_outlined, color: AppColors.error),
                StatCard(title: 'Total Revenue', value: '\$${totalRevenue.toStringAsFixed(2)}', icon: Icons.attach_money_rounded, color: AppColors.accent),
              ],
            );
          },
          loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
          error: (e, _) => SizedBox(height: 100, child: Center(child: Text('Error: $e'))),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Consumer(
              builder: (context, ref, _) {
                final companiesAsync = ref.watch(_billingCompaniesProvider);
                return companiesAsync.when(
                  data: (companies) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFDDE2E8)),
                    ),
                    child: DropdownButton<String>(
                      value: ref.watch(billingCompanyFilterProvider),
                      underline: const SizedBox(),
                      isDense: true,
                      items: [
                        const DropdownMenuItem(value: 'all', child: Text('All Companies')),
                        ...companies.map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name),
                        )),
                      ],
                      onChanged: (v) => ref.read(billingCompanyFilterProvider.notifier).state = v!,
                    ),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDDE2E8)),
              ),
              child: DropdownButton<String>(
                value: ref.watch(billingBillableFilterProvider),
                underline: const SizedBox(),
                isDense: true,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(value: 'yes', child: Text('Billable')),
                  DropdownMenuItem(value: 'no', child: Text('Non-Billable')),
                ],
                onChanged: (v) => ref.read(billingBillableFilterProvider.notifier).state = v!,
              ),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () {
                ref.invalidate(billingRecordsProvider);
                ref.invalidate(billingSummaryProvider);
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Refresh'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE8ECF0), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: recordsAsync.when(
                data: (records) {
                  if (records.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textTertiary),
                          const SizedBox(height: 12),
                          Text(
                            'No billing records found',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                    return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable2(
                      columns: [
                        DataColumn2(label: Row(children: [Icon(Icons.business_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('COMPANY')]), size: ColumnSize.L),
                        DataColumn2(label: Row(children: [Icon(Icons.trip_origin_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('TRIP ID')])),
                        DataColumn2(label: Row(children: [Icon(Icons.straighten, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('DISTANCE')])),
                        DataColumn2(label: Row(children: [Icon(Icons.attach_money_rounded, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('COST')])),
                        DataColumn2(label: Row(children: [Icon(Icons.receipt_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('BILLABLE')])),
                        DataColumn2(label: Row(children: [Icon(Icons.cancel_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('DISCARD REASON')])),
                        DataColumn2(label: Row(children: [Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('DATE')])),
                      ],
                      rows: records.asMap().entries.map((entry) {
                        final index = entry.key;
                        final record = entry.value;
                        return DataRow2(
                          color: index % 2 == 0
                              ? WidgetStateProperty.all(Colors.white)
                              : WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                          cells: [
                            DataCell(Text(record.companyId)),
                            DataCell(Text(record.tripId)),
                            DataCell(Text('${record.distance.toStringAsFixed(2)} km')),
                            DataCell(Row(
                children: [
                  Icon(Icons.attach_money_rounded, size: 14, color: AppColors.accent),
                  const SizedBox(width: 4),
                  Text(
                    '\$${record.tripCost.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              )),
                            DataCell(Row(
                              children: [
                                Icon(record.isBillable == true ? Icons.check_circle_outline : Icons.cancel_outlined, size: 14, color: record.isBillable == true ? AppColors.success : AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  record.isBillable == true ? 'Yes' : 'No',
                                  style: TextStyle(
                                    color: record.isBillable == true ? AppColors.success : AppColors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )),
                            DataCell(Text(record.discardReason ?? '-')),
                            DataCell(Text(record.completedAt != null
                                ? '${record.completedAt!.day}/${record.completedAt!.month}/${record.completedAt!.year}'
                                : '-')),
                          ],
                        );
                      }).toList(),
                    ),
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
                  data: (companies) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFDDE2E8)),
                    ),
                    child: DropdownButton<String>(
                      value: ref.watch(invoiceCompanyFilterProvider),
                      underline: const SizedBox(),
                      isDense: true,
                      items: [
                        const DropdownMenuItem(value: 'all', child: Text('All Companies')),
                        ...companies.map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name),
                        )),
                      ],
                      onChanged: (v) => ref.read(invoiceCompanyFilterProvider.notifier).state = v!,
                    ),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDDE2E8)),
              ),
              child: DropdownButton<String>(
                value: ref.watch(invoiceStatusFilterProvider),
                underline: const SizedBox(),
                isDense: true,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All Status')),
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'paid', child: Text('Paid')),
                  DropdownMenuItem(value: 'overdue', child: Text('Overdue')),
                ],
                onChanged: (v) => ref.read(invoiceStatusFilterProvider.notifier).state = v!,
              ),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () => ref.invalidate(invoicesProvider),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Refresh'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE8ECF0), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: invoicesAsync.when(
                data: (invoices) {
                  if (invoices.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_outlined, size: 48, color: AppColors.textTertiary),
                          const SizedBox(height: 12),
                          Text(
                            'No invoices found',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                    return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable2(
                      columns: [
                        DataColumn2(label: Row(children: [Icon(Icons.business_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('COMPANY')]), size: ColumnSize.L),
                        DataColumn2(label: Row(children: [Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('MONTH')])),
                        DataColumn2(label: Row(children: [Icon(Icons.trip_origin_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('TOTAL TRIPS')])),
                        DataColumn2(label: Row(children: [Icon(Icons.receipt_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('BILLABLE TRIPS')])),
                        DataColumn2(label: Row(children: [Icon(Icons.attach_money_rounded, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('AMOUNT')])),
                        DataColumn2(label: Row(children: [Icon(Icons.flag_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('STATUS')])),
                        DataColumn2(label: Row(children: [Icon(Icons.event_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('DUE DATE')])),
                        DataColumn2(label: Row(children: [Icon(Icons.settings_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('ACTIONS')]), size: ColumnSize.S),
                      ],
                      rows: invoices.asMap().entries.map((entry) {
                        final index = entry.key;
                        final invoice = entry.value;
                        return DataRow2(
                          color: index % 2 == 0
                              ? WidgetStateProperty.all(Colors.white)
                              : WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                          cells: [
                            DataCell(Text(invoice.companyId)),
                            DataCell(Text(invoice.month)),
                            DataCell(Text('${invoice.totalTrips}')),
                            DataCell(Text('${invoice.billableTrips}')),
                            DataCell(Text(
                              '\$${invoice.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            )),
                            DataCell(_buildInvoiceStatusChip(invoice.status)),
                            DataCell(Text(invoice.dueDate != null
                                ? '${invoice.dueDate!.day}/${invoice.dueDate!.month}/${invoice.dueDate!.year}'
                                : '-')),
                            DataCell(
                              invoice.status != 'paid'
                                  ? Tooltip(
                                      message: 'Mark as Paid',
                                      child: IconButton(
                                        icon: Icon(Icons.check_circle_outline_rounded, size: 18, color: AppColors.success),
                                        onPressed: () async {
                                          final api = await ref.read(superAdminApiProvider.future);
                                          await api.updateInvoice(invoice.id, {'status': 'paid'});
                                          ref.invalidate(invoicesProvider);
                                        },
                                      ),
                                    )
                                  : Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
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
      avatar: Icon(status == 'paid' ? Icons.check_circle : status == 'overdue' ? Icons.warning_amber_rounded : Icons.schedule, size: 14, color: color),
      label: Text(status[0].toUpperCase() + status.substring(1), style: TextStyle(color: color)),
      backgroundColor: color.withOpacity(0.1),
    );
  }
}
