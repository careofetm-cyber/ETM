import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_saver/file_saver.dart';
import '../../shared/providers/api_providers.dart';

final employeeReportProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final api = await ref.watch(exportReportApiProvider.future);
  return api.exportEmployees();
});

final tripReportProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final api = await ref.watch(exportReportApiProvider.future);
  return api.exportTrips();
});

final billingReportProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final api = await ref.watch(exportReportApiProvider.future);
  return api.exportBilling();
});

final attendanceReportProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final api = await ref.watch(exportReportApiProvider.future);
  return api.exportAttendance();
});

final vehicleReportProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final api = await ref.watch(exportReportApiProvider.future);
  return api.exportVehicles();
});

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  List<CellValue> _toCells(List<String> values) {
    return values.map((v) => TextCellValue(v)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reports',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.5,
                children: [
                  _buildReportCard(
                    context,
                    icon: Icons.people,
                    title: 'Employee Report',
                    description: 'Export employee list with details',
                    provider: employeeReportProvider,
                    onExportXls: _exportEmployeeXls,
                    onExportPdf: _exportEmployeePdf,
                  ),
                  _buildReportCard(
                    context,
                    icon: Icons.route,
                    title: 'Trip Report',
                    description: 'Export trip data and history',
                    provider: tripReportProvider,
                    onExportXls: _exportTripXls,
                    onExportPdf: _exportTripPdf,
                  ),
                  _buildReportCard(
                    context,
                    icon: Icons.receipt_long,
                    title: 'Billing Report',
                    description: 'Export billing records and invoices',
                    provider: billingReportProvider,
                    onExportXls: _exportBillingXls,
                    onExportPdf: _exportBillingPdf,
                  ),
                  _buildReportCard(
                    context,
                    icon: Icons.check_circle,
                    title: 'Attendance Report',
                    description: 'Export attendance data and summaries',
                    provider: attendanceReportProvider,
                    onExportXls: _exportAttendanceXls,
                    onExportPdf: _exportAttendancePdf,
                  ),
                  _buildReportCard(
                    context,
                    icon: Icons.directions_bus,
                    title: 'Vehicle Report',
                    description: 'Export vehicle list and maintenance data',
                    provider: vehicleReportProvider,
                    onExportXls: _exportVehicleXls,
                    onExportPdf: _exportVehiclePdf,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required FutureProvider<List<Map<String, dynamic>>> provider,
    required Function(List<Map<String, dynamic>>) onExportXls,
    required Function(List<Map<String, dynamic>>) onExportPdf,
  }) {
    final dataAsync = ref.watch(provider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  dataAsync.when(
                    data: (data) => Text(
                      '${data.length} records',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                    loading: () => const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (_, __) => const Text('Error loading', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
            dataAsync.when(
              data: (data) => Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => onExportXls(data),
                    icon: const Icon(Icons.table_chart, size: 16),
                    label: const Text('Export XLS'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => onExportPdf(data),
                    icon: const Icon(Icons.picture_as_pdf, size: 16),
                    label: const Text('Export PDF'),
                  ),
                ],
              ),
              loading: () => const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(),
              ),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadBytes(Uint8List bytes, String fileName) async {
    await FileSaver.instance.saveFile(
      name: fileName,
      bytes: bytes,
      mimeType: MimeType.other,
    );
  }

  // Employee Export
  void _exportEmployeeXls(List<Map<String, dynamic>> data) {
    final excel = Excel.createExcel();
    final sheet = excel['Employees'];

    sheet.appendRow(_toCells(['Name', 'Email', 'Phone', 'Department', 'Designation', 'Employee Code', 'Status']));

    for (final row in data) {
      sheet.appendRow(_toCells([
        '${row['firstName'] ?? ''} ${row['lastName'] ?? ''}',
        row['email'] ?? '',
        row['phone'] ?? '',
        row['department'] ?? '',
        row['designation'] ?? '',
        row['employeeCode'] ?? '',
        row['isActive'] == true ? 'Active' : 'Inactive',
      ]));
    }

    final bytes = excel.encode();
    if (bytes != null) {
      _downloadBytes(Uint8List.fromList(bytes), 'employees_report.xlsx');
    }
  }

  Future<void> _exportEmployeePdf(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();
    final tableHeaders = ['Name', 'Email', 'Phone', 'Department'];
    final tableData = data.map((row) => [
      '${row['firstName'] ?? ''} ${row['lastName'] ?? ''}',
      row['email'] ?? '',
      row['phone'] ?? '',
      row['department'] ?? '',
    ]).toList();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Header(text: 'Employee Report'),
        pw.Table.fromTextArray(
          headers: tableHeaders,
          data: tableData,
        ),
      ],
    ));

    final bytes = await pdf.save();
    _downloadBytes(Uint8List.fromList(bytes), 'employees_report.pdf');
  }

  // Trip Export
  void _exportTripXls(List<Map<String, dynamic>> data) {
    final excel = Excel.createExcel();
    final sheet = excel['Trips'];

    sheet.appendRow(_toCells(['Route', 'Driver', 'Vehicle', 'Date', 'Status', 'Passengers']));

    for (final row in data) {
      sheet.appendRow(_toCells([
        row['routeName'] ?? row['route'] ?? '',
        row['driver'] ?? '',
        row['vehiclePlate'] ?? row['vehicle'] ?? '',
        row['scheduledTime'] ?? row['date'] ?? '',
        row['status'] ?? '',
        (row['totalPassengers'] ?? row['passengers'] ?? 0).toString(),
      ]));
    }

    final bytes = excel.encode();
    if (bytes != null) {
      _downloadBytes(Uint8List.fromList(bytes), 'trips_report.xlsx');
    }
  }

  Future<void> _exportTripPdf(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();
    final tableHeaders = ['Route', 'Driver', 'Vehicle', 'Date', 'Status'];
    final tableData = data.map((row) => [
      row['route'] ?? '',
      row['driver'] ?? '',
      row['vehicle'] ?? '',
      row['date'] ?? '',
      row['status'] ?? '',
    ]).toList();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Header(text: 'Trip Report'),
        pw.Table.fromTextArray(
          headers: tableHeaders,
          data: tableData,
        ),
      ],
    ));

    final bytes = await pdf.save();
    _downloadBytes(Uint8List.fromList(bytes), 'trips_report.pdf');
  }

  // Billing Export
  void _exportBillingXls(List<Map<String, dynamic>> data) {
    final excel = Excel.createExcel();
    final sheet = excel['Billing'];

    sheet.appendRow(_toCells(['Invoice', 'Company', 'Amount', 'Date', 'Status']));

    for (final row in data) {
      sheet.appendRow(_toCells([
        row['tripId'] ?? row['invoice'] ?? '',
        row['companyName'] ?? row['company'] ?? '',
        (row['tripCost'] ?? row['amount'] ?? 0).toString(),
        row['month'] ?? row['date'] ?? '',
        row['isBillable'] == true ? 'Billable' : row['status'] ?? '',
      ]));
    }

    final bytes = excel.encode();
    if (bytes != null) {
      _downloadBytes(Uint8List.fromList(bytes), 'billing_report.xlsx');
    }
  }

  Future<void> _exportBillingPdf(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();
    final tableHeaders = ['Invoice', 'Company', 'Amount', 'Date', 'Status'];
    final tableData = data.map((row) => [
      row['invoice'] ?? '',
      row['company'] ?? '',
      row['amount']?.toString() ?? '0',
      row['date'] ?? '',
      row['status'] ?? '',
    ]).toList();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Header(text: 'Billing Report'),
        pw.Table.fromTextArray(
          headers: tableHeaders,
          data: tableData,
        ),
      ],
    ));

    final bytes = await pdf.save();
    _downloadBytes(Uint8List.fromList(bytes), 'billing_report.pdf');
  }

  // Attendance Export
  void _exportAttendanceXls(List<Map<String, dynamic>> data) {
    final excel = Excel.createExcel();
    final sheet = excel['Attendance'];

    sheet.appendRow(_toCells(['Employee', 'Date', 'Check In', 'Check Out', 'Status']));

    for (final row in data) {
      sheet.appendRow(_toCells([
        row['employeeName'] ?? row['employee'] ?? '',
        row['date'] ?? '',
        row['checkInTime'] ?? row['checkIn'] ?? '',
        row['checkOut'] ?? '',
        row['status'] ?? '',
      ]));
    }

    final bytes = excel.encode();
    if (bytes != null) {
      _downloadBytes(Uint8List.fromList(bytes), 'attendance_report.xlsx');
    }
  }

  Future<void> _exportAttendancePdf(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();
    final tableHeaders = ['Employee', 'Date', 'Check In', 'Check Out', 'Status'];
    final tableData = data.map((row) => [
      row['employee'] ?? '',
      row['date'] ?? '',
      row['checkIn'] ?? '',
      row['checkOut'] ?? '',
      row['status'] ?? '',
    ]).toList();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Header(text: 'Attendance Report'),
        pw.Table.fromTextArray(
          headers: tableHeaders,
          data: tableData,
        ),
      ],
    ));

    final bytes = await pdf.save();
    _downloadBytes(Uint8List.fromList(bytes), 'attendance_report.pdf');
  }

  // Vehicle Export
  void _exportVehicleXls(List<Map<String, dynamic>> data) {
    final excel = Excel.createExcel();
    final sheet = excel['Vehicles'];

    sheet.appendRow(_toCells(['Plate Number', 'Model', 'Capacity', 'Status', 'Brand']));

    for (final row in data) {
      sheet.appendRow(_toCells([
        row['plateNumber'] ?? '',
        row['model'] ?? '',
        (row['seatingCapacity'] ?? row['capacity'] ?? 0).toString(),
        row['status'] ?? '',
        row['brand'] ?? row['assignedDriver'] ?? '',
      ]));
    }

    final bytes = excel.encode();
    if (bytes != null) {
      _downloadBytes(Uint8List.fromList(bytes), 'vehicles_report.xlsx');
    }
  }

  Future<void> _exportVehiclePdf(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();
    final tableHeaders = ['Plate Number', 'Type', 'Capacity', 'Status'];
    final tableData = data.map((row) => [
      row['plateNumber'] ?? '',
      row['type'] ?? '',
      row['capacity']?.toString() ?? '0',
      row['status'] ?? '',
    ]).toList();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Header(text: 'Vehicle Report'),
        pw.Table.fromTextArray(
          headers: tableHeaders,
          data: tableData,
        ),
      ],
    ));

    final bytes = await pdf.save();
    _downloadBytes(Uint8List.fromList(bytes), 'vehicles_report.pdf');
  }
}
