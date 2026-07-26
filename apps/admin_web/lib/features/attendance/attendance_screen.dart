import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

final attendancePageProvider = StateProvider<int>((ref) => 1);
final attendanceStatusProvider = StateProvider<String>((ref) => 'all');
final attendanceDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final attendanceProvider = FutureProvider<List<Attendance>>((ref) async {
  final api = await ref.watch(attendanceApiProvider.future);
  final page = ref.watch(attendancePageProvider);
  final status = ref.watch(attendanceStatusProvider);
  final date = ref.watch(attendanceDateProvider);
  return api.getAttendance(
    page: page,
    limit: 20,
    date: date,
    status: status == 'all' ? null : status,
  );
});

final attendanceAllProvider = FutureProvider<List<Attendance>>((ref) async {
  final api = await ref.watch(attendanceApiProvider.future);
  final status = ref.watch(attendanceStatusProvider);
  final date = ref.watch(attendanceDateProvider);
  return api.getAttendance(
    limit: 10000,
    date: date,
    status: status == 'all' ? null : status,
  );
});

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    final attendanceAsync = ref.watch(attendanceProvider);
    final attendanceAllAsync = ref.watch(attendanceAllProvider);
    final selectedDate = ref.watch(attendanceDateProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Attendance',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            attendanceAllAsync.when(
              data: (allRecords) {
                final present = allRecords.where((a) => a.status == AttendanceStatus.present).length;
                final absent = allRecords.where((a) => a.status == AttendanceStatus.absent).length;
                final late = allRecords.where((a) => a.status == AttendanceStatus.late).length;
                final onLeave = allRecords.where((a) => a.status == AttendanceStatus.onLeave).length;
                return Row(
                  children: [
                    _buildSummaryCard('Present', present.toString(), AppColors.success),
                    const SizedBox(width: 16),
                    _buildSummaryCard('Absent', absent.toString(), AppColors.error),
                    const SizedBox(width: 16),
                    _buildSummaryCard('Late', late.toString(), AppColors.warning),
                    const SizedBox(width: 16),
                    _buildSummaryCard('On Leave', onLeave.toString(), AppColors.info),
                  ],
                );
              },
              loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
              error: (error, stack) => SizedBox(height: 80, child: Center(child: Text('Error: $error'))),
            ),
            const SizedBox(height: 24),
            DropdownButton<String>(
              value: ref.watch(attendanceStatusProvider),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Status')),
                DropdownMenuItem(value: 'present', child: Text('Present')),
                DropdownMenuItem(value: 'absent', child: Text('Absent')),
                DropdownMenuItem(value: 'late', child: Text('Late')),
                DropdownMenuItem(value: 'onLeave', child: Text('On Leave')),
              ],
              onChanged: (value) {
                ref.read(attendanceStatusProvider.notifier).state = value!;
                ref.read(attendancePageProvider.notifier).state = 1;
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: attendanceAsync.when(
                    data: (records) {
                      if (records.isEmpty) {
                        return const Center(child: Text('No attendance records found'));
                      }
                      return _buildAttendanceTable(records);
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(child: Text('Error: $error')),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String count, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceTable(List<Attendance> records) {
    return DataTable2(
      columns: const [
        DataColumn2(label: Text('Employee'), size: ColumnSize.L),
        DataColumn2(label: Text('Status')),
        DataColumn2(label: Text('Check In')),
        DataColumn2(label: Text('Check Out')),
        DataColumn2(label: Text('Boarding')),
        DataColumn2(label: Text('Trip')),
      ],
      rows: records.map((record) {
        return DataRow2(cells: [
          DataCell(Text(record.employeeId)),
          DataCell(_buildStatusChip(record.status.name)),
          DataCell(Text(record.checkInTime != null
              ? '${record.checkInTime!.hour}:${record.checkInTime!.minute.toString().padLeft(2, '0')}'
              : '-')),
          DataCell(Text(record.checkOutTime != null
              ? '${record.checkOutTime!.hour}:${record.checkOutTime!.minute.toString().padLeft(2, '0')}'
              : '-')),
          DataCell(Text(record.boardingMethod?.name.toUpperCase() ?? '-')),
          DataCell(Text(record.tripId ?? '-')),
        ]);
      }).toList(),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'present':
        color = AppColors.success;
        label = 'Present';
        break;
      case 'absent':
        color = AppColors.error;
        label = 'Absent';
        break;
      case 'late':
        color = AppColors.warning;
        label = 'Late';
        break;
      case 'onLeave':
        color = AppColors.info;
        label = 'On Leave';
        break;
      case 'halfDay':
        color = AppColors.warning;
        label = 'Half Day';
        break;
      default:
        color = AppColors.textSecondary;
        label = status;
    }

    return Chip(
      label: Text(label, style: TextStyle(color: color)),
      backgroundColor: color.withOpacity(0.1),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ref.read(attendanceDateProvider),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      ref.read(attendanceDateProvider.notifier).state = picked;
      ref.read(attendancePageProvider.notifier).state = 1;
    }
  }
}
