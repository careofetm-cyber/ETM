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
      backgroundColor: const Color(0xFFF0F4F8),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Attendance',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_today_rounded, size: 18),
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
                    _buildSummaryCard('Present', present.toString(), AppColors.success, Icons.check_circle_outline),
                    const SizedBox(width: 16),
                    _buildSummaryCard('Absent', absent.toString(), AppColors.error, Icons.cancel_outlined),
                    const SizedBox(width: 16),
                    _buildSummaryCard('Late', late.toString(), AppColors.warning, Icons.access_time_rounded),
                    const SizedBox(width: 16),
                    _buildSummaryCard('On Leave', onLeave.toString(), AppColors.info, Icons.event_busy_outlined),
                  ],
                );
              },
              loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
              error: (error, stack) => SizedBox(height: 80, child: Center(child: Text('Error: $error'))),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDDE2E8)),
              ),
              child: DropdownButton<String>(
                value: ref.watch(attendanceStatusProvider),
                underline: const SizedBox(),
                isDense: true,
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
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE8ECF0), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: attendanceAsync.when(
                    data: (records) {
                      if (records.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline, size: 48, color: AppColors.textTertiary),
                              const SizedBox(height: 12),
                              Text(
                                'No attendance records found',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
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

  Widget _buildSummaryCard(String title, String count, Color color, IconData icon) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE8ECF0), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 18),
                  ),
                  const Spacer(),
                  Text(
                    count,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceTable(List<Attendance> records) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable2(
        columns: const [
          DataColumn2(label: Text('EMPLOYEE'), size: ColumnSize.L),
          DataColumn2(label: Text('STATUS')),
          DataColumn2(label: Text('CHECK IN')),
          DataColumn2(label: Text('CHECK OUT')),
          DataColumn2(label: Text('BOARDING')),
          DataColumn2(label: Text('TRIP')),
        ],
        rows: records.asMap().entries.map((entry) {
          final index = entry.key;
          final record = entry.value;
          return DataRow2(
            color: index % 2 == 0
                ? WidgetStateProperty.all(Colors.white)
                : WidgetStateProperty.all(const Color(0xFFF8FAFC)),
            cells: [
              DataCell(Text(record.employeeId, style: const TextStyle(fontWeight: FontWeight.w500))),
              DataCell(_buildStatusChip(record.status.name)),
              DataCell(Text(record.checkInTime != null
                  ? '${record.checkInTime!.hour}:${record.checkInTime!.minute.toString().padLeft(2, '0')}'
                  : '-')),
              DataCell(Text(record.checkOutTime != null
                  ? '${record.checkOutTime!.hour}:${record.checkOutTime!.minute.toString().padLeft(2, '0')}'
                  : '-')),
              DataCell(Text(record.boardingMethod?.name.toUpperCase() ?? '-')),
              DataCell(Text(record.tripId ?? '-')),
            ],
          );
        }).toList(),
      ),
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
