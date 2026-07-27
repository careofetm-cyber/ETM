import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:etm_core/etm_core.dart';
import 'package:file_saver/file_saver.dart';
import '../../shared/providers/api_providers.dart';

final employeesPageProvider = StateProvider<int>((ref) => 1);
final employeesSearchProvider = StateProvider<String>((ref) => '');

final employeesProvider = FutureProvider<List<Employee>>((ref) async {
  final api = await ref.watch(employeeApiProvider.future);
  final page = ref.watch(employeesPageProvider);
  final search = ref.watch(employeesSearchProvider);
  return api.getEmployees(
    page: page,
    limit: 20,
    search: search.isEmpty ? null : search,
  );
});

class EmployeesScreen extends ConsumerStatefulWidget {
  const EmployeesScreen({super.key});

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
  final _searchController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _departmentController = TextEditingController();
  final _designationController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _designationController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeesProvider);

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
                  'Employees',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () => _exportXLS(employeesAsync),
                  icon: const Icon(Icons.table_chart_outlined, size: 18),
                  label: const Text('Export XLS'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _exportPDF(employeesAsync),
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: const Text('Export PDF'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _showBulkImportDialog(context),
                  icon: const Icon(Icons.upload_file_rounded, size: 18),
                  label: const Text('Import CSV'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _showBulkUploadDialog(context),
                  icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                  label: const Text('Bulk Upload'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showAddEmployeeDialog(context),
                  icon: const Icon(Icons.person_add_rounded, size: 18),
                  label: const Text('Add Employee'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 320,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search employees...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(employeesSearchProvider.notifier).state = '';
                            ref.read(employeesPageProvider.notifier).state = 1;
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  ref.read(employeesSearchProvider.notifier).state = value;
                  ref.read(employeesPageProvider.notifier).state = 1;
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
                  child: employeesAsync.when(
                    data: (employees) {
                      if (employees.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people_outline, size: 48, color: AppColors.textTertiary),
                              const SizedBox(height: 12),
                              Text(
                                'No employees found',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return _buildEmployeesTable(employees);
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

  Widget _buildEmployeesTable(List<Employee> employees) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable2(
        columns: [
          DataColumn2(label: Row(children: [Icon(Icons.person_outline, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('EMPLOYEE')]), size: ColumnSize.L),
          DataColumn2(label: Row(children: [Icon(Icons.badge_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('CODE')])),
          DataColumn2(label: Row(children: [Icon(Icons.business_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('DEPARTMENT')])),
          DataColumn2(label: Row(children: [Icon(Icons.email_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('EMAIL')])),
          DataColumn2(label: Row(children: [Icon(Icons.directions_bus_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('TRANSPORT')])),
          DataColumn2(label: Row(children: [Icon(Icons.settings_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('ACTIONS')]), size: ColumnSize.S),
        ],
        rows: employees.asMap().entries.map((entry) {
          final index = entry.key;
          final employee = entry.value;
          return DataRow2(
            color: index % 2 == 0
                ? WidgetStateProperty.all(Colors.white)
                : WidgetStateProperty.all(const Color(0xFFF8FAFC)),
            cells: [
              DataCell(Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      (employee.userId.isNotEmpty ? employee.userId.substring(0, 1).toUpperCase() : 'U'),
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.userId,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          employee.email ?? '-',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
              DataCell(Text(employee.employeeCode ?? '-')),
              DataCell(Text(employee.department ?? '-')),
              DataCell(Text(employee.email ?? '-')),
              DataCell(Switch(
                value: employee.isTransportRequired ?? false,
                onChanged: (value) async {
                  final api = await ref.read(employeeApiProvider.future);
                  await api.updateEmployee(employee.id, {
                    'isTransportRequired': value,
                  });
                  ref.invalidate(employeesProvider);
                },
              )),
              DataCell(Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: 'View',
                    child: IconButton(
                      icon: Icon(Icons.visibility_outlined, size: 18, color: AppColors.info),
                      onPressed: () {},
                    ),
                  ),
                  Tooltip(
                    message: 'Edit',
                    child: IconButton(
                      icon: Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                      onPressed: () => _showEditEmployeeDialog(context, employee),
                    ),
                  ),
                  Tooltip(
                    message: 'Delete',
                    child: IconButton(
                      icon: Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                      onPressed: () => _showDeleteConfirmation(context, employee),
                    ),
                  ),
                ],
              )),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _departmentController.clear();
    _designationController.clear();
    _codeController.clear();

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Employee'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name *'),
                    validator: (v) => v == null || v.isEmpty ? 'First name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name *'),
                    validator: (v) => v == null || v.isEmpty ? 'Last name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email *'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Email is required';
                      if (!v.contains('@') || !v.contains('.')) return 'Invalid email format';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _codeController,
                    decoration: const InputDecoration(labelText: 'Employee Code *'),
                    validator: (v) => v == null || v.isEmpty ? 'Employee code is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _departmentController,
                    decoration: const InputDecoration(labelText: 'Department *'),
                    validator: (v) => v == null || v.isEmpty ? 'Department is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _designationController,
                    decoration: const InputDecoration(labelText: 'Designation'),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                final api = await ref.read(employeeApiProvider.future);
                await api.createEmployee({
                  'firstName': _firstNameController.text,
                  'lastName': _lastNameController.text,
                  'email': _emailController.text,
                  'employeeCode': _codeController.text,
                  'phone': _phoneController.text,
                  'department': _departmentController.text,
                  'designation': _designationController.text,
                });
                if (context.mounted) Navigator.pop(context);
                ref.invalidate(employeesProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Employee added successfully'), backgroundColor: AppColors.success),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add employee: $e'), backgroundColor: AppColors.error),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditEmployeeDialog(BuildContext context, Employee employee) {
    _codeController.text = employee.employeeCode ?? '';
    _emailController.text = employee.email ?? '';
    _phoneController.text = employee.phone ?? '';
    _departmentController.text = employee.department ?? '';
    _designationController.text = employee.designation ?? '';

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Employee'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(labelText: 'Employee Code *'),
                  validator: (v) => v == null || v.isEmpty ? 'Employee code is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return null;
                    if (!v.contains('@') || !v.contains('.')) return 'Invalid email format';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _departmentController,
                  decoration: const InputDecoration(labelText: 'Department *'),
                  validator: (v) => v == null || v.isEmpty ? 'Department is required' : null,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _designationController,
                  decoration: const InputDecoration(labelText: 'Designation'),
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
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                final api = await ref.read(employeeApiProvider.future);
                await api.updateEmployee(employee.id, {
                  'employeeCode': _codeController.text,
                  'email': _emailController.text,
                  'phone': _phoneController.text,
                  'department': _departmentController.text,
                  'designation': _designationController.text,
                });
                if (context.mounted) Navigator.pop(context);
                ref.invalidate(employeesProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Employee updated successfully'), backgroundColor: AppColors.success),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update employee: $e'), backgroundColor: AppColors.error),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: Text('Are you sure you want to delete ${employee.employeeCode ?? employee.userId}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              try {
                final api = await ref.read(employeeApiProvider.future);
                await api.deleteEmployee(employee.id);
                if (context.mounted) Navigator.pop(context);
                ref.invalidate(employeesProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Employee deleted'), backgroundColor: AppColors.success),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete employee: $e'), backgroundColor: AppColors.error),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
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

  void _exportXLS(AsyncValue<List<Employee>> employeesAsync) {
    employeesAsync.whenData((employees) {
      final excel = Excel.createExcel();
      final sheet = excel['Employees'];

      sheet.appendRow([
        TextCellValue('Employee Code'),
        TextCellValue('First Name'),
        TextCellValue('Last Name'),
        TextCellValue('Email'),
        TextCellValue('Phone'),
        TextCellValue('Department'),
        TextCellValue('Designation'),
        TextCellValue('Status'),
      ]);

      for (final emp in employees) {
        sheet.appendRow([
          TextCellValue(emp.employeeCode ?? ''),
          TextCellValue(emp.userId),
          TextCellValue(''),
          TextCellValue(emp.email ?? ''),
          TextCellValue(emp.phone ?? ''),
          TextCellValue(emp.department ?? ''),
          TextCellValue(emp.designation ?? ''),
          TextCellValue(emp.isActive == true ? 'Active' : 'Inactive'),
        ]);
      }

      final bytes = excel.encode();
      if (bytes != null) {
        _downloadBytes(Uint8List.fromList(bytes), 'employees_export.xlsx');
      }
    });
  }

  Future<void> _exportPDF(AsyncValue<List<Employee>> employeesAsync) async {
    employeesAsync.whenData((employees) async {
      final pdf = pw.Document();
      final tableHeaders = [
        'Code',
        'Name',
        'Email',
        'Phone',
        'Department',
        'Designation',
      ];
      final tableData = employees.map((emp) => [
        emp.employeeCode ?? '',
        emp.userId,
        emp.email ?? '',
        emp.phone ?? '',
        emp.department ?? '',
        emp.designation ?? '',
      ]).toList();

      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(text: 'Employee List'),
          pw.TableHelper.fromTextArray(
            headers: tableHeaders,
            data: tableData,
          ),
        ],
      ));

      final bytes = await pdf.save();
      _downloadBytes(Uint8List.fromList(bytes), 'employees_export.pdf');
    });
  }

  void _showBulkImportDialog(BuildContext context) {
    final csvController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    List<Map<String, dynamic>>? importResults;
    int successCount = 0;
    int errorCount = 0;
    bool isImporting = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Import Employees from CSV'),
          content: SizedBox(
            width: 600,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Paste CSV data with headers:\nfirstName, lastName, email, phone, department, designation, employeeCode',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          final template = const ListToCsvConverter().convert([
                            ['firstName', 'lastName', 'email', 'phone', 'department', 'designation', 'employeeCode'],
                            ['John', 'Doe', 'john.doe@example.com', '1234567890', 'Engineering', 'Manager', 'EMP001'],
                            ['Jane', 'Smith', 'jane.smith@example.com', '0987654321', 'HR', 'Coordinator', 'EMP002'],
                          ]);
                          final bytes = Uint8List.fromList(template.codeUnits);
                          FileSaver.instance.saveFile(
                            name: 'employee_import_template.csv',
                            bytes: bytes,
                            mimeType: MimeType.csv,
                          );
                        },
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text('Download Template'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: csvController,
                    maxLines: 12,
                    decoration: const InputDecoration(
                      hintText: 'firstName,lastName,email,phone,department,designation,employeeCode\nJohn,Doe,john@example.com,1234567890,Engineering,Manager,EMP001',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'CSV data is required';
                      return null;
                    },
                  ),
                  if (importResults != null) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Results: $successCount succeeded, $errorCount failed',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: errorCount > 0 ? Colors.orange : Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: importResults!.length,
                        itemBuilder: (context, index) {
                          final result = importResults![index];
                          final isError = result['error'] != null;
                          return ListTile(
                            dense: true,
                            leading: Icon(
                              isError ? Icons.error : Icons.check_circle,
                              color: isError ? Colors.red : Colors.green,
                              size: 20,
                            ),
                            title: Text(
                              result['employeeCode'] ?? result['email'] ?? 'Row ${index + 1}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            subtitle: Text(
                              isError ? result['error'] : 'Imported successfully',
                              style: TextStyle(
                                fontSize: 11,
                                color: isError ? Colors.red : Colors.green,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            if (importResults == null)
              ElevatedButton(
                onPressed: isImporting
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) return;
                        setDialogState(() => isImporting = true);
                        try {
                          final rows = const CsvToListConverter().convert(
                            csvController.text.trim(),
                          );
                          if (rows.length < 2) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('CSV must have a header row and at least one data row')),
                            );
                            setDialogState(() => isImporting = false);
                            return;
                          }
                          final headers = rows.first.map((e) => e.toString().trim()).toList();
                          final employees = <Map<String, dynamic>>[];
                          for (var i = 1; i < rows.length; i++) {
                            final row = rows[i];
                            final Map<String, dynamic> employee = {};
                            for (var j = 0; j < headers.length && j < row.length; j++) {
                              employee[headers[j]] = row[j].toString();
                            }
                            employees.add(employee);
                          }

                          final dio = ref.read(dioProvider);
                          final response = await dio.post(
                            '/bulk-upload/employees',
                            data: {'employees': employees},
                          );
                          final data = response.data;
                          final results = (data['results'] as List?)
                                  ?.map((e) => Map<String, dynamic>.from(e))
                                  .toList() ??
                              [];
                          setDialogState(() {
                            importResults = results;
                            successCount = results.where((r) => r['error'] == null).length;
                            errorCount = results.where((r) => r['error'] != null).length;
                            isImporting = false;
                          });
                          ref.invalidate(employeesProvider);
                        } catch (e) {
                          setDialogState(() => isImporting = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Import failed: $e')),
                          );
                        }
                      },
                child: isImporting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Import'),
              ),
          ],
        ),
      ),
    );
  }

  void _showBulkUploadDialog(BuildContext context) {
    final csvController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    List<Map<String, dynamic>>? uploadResults;
    int successCount = 0;
    int errorCount = 0;
    bool isUploading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Bulk Upload Employees'),
          content: SizedBox(
            width: 600,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Paste CSV with headers:\nfirstName, lastName, email, phone, department, designation, employeeCode',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          final template = const ListToCsvConverter().convert([
                            ['firstName', 'lastName', 'email', 'phone', 'department', 'designation', 'employeeCode'],
                            ['John', 'Doe', 'john.doe@example.com', '1234567890', 'Engineering', 'Manager', 'EMP001'],
                            ['Jane', 'Smith', 'jane.smith@example.com', '0987654321', 'HR', 'Coordinator', 'EMP002'],
                          ]);
                          final bytes = Uint8List.fromList(template.codeUnits);
                          FileSaver.instance.saveFile(
                            name: 'employee_bulk_upload_template.csv',
                            bytes: bytes,
                            mimeType: MimeType.csv,
                          );
                        },
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text('Download Template'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: csvController,
                    maxLines: 12,
                    decoration: const InputDecoration(
                      hintText: 'firstName,lastName,email,phone,department,designation,employeeCode\nJohn,Doe,john@example.com,1234567890,Engineering,Manager,EMP001',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'CSV data is required';
                      return null;
                    },
                  ),
                  if (uploadResults != null) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Results: $successCount succeeded, $errorCount failed',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: errorCount > 0 ? Colors.orange : Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: uploadResults!.length,
                        itemBuilder: (context, index) {
                          final result = uploadResults![index];
                          final isError = result['error'] != null;
                          return ListTile(
                            dense: true,
                            leading: Icon(
                              isError ? Icons.error : Icons.check_circle,
                              color: isError ? Colors.red : Colors.green,
                              size: 20,
                            ),
                            title: Text(
                              result['employeeCode'] ?? result['email'] ?? 'Row ${index + 1}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            subtitle: Text(
                              isError ? result['error'] : 'Uploaded successfully',
                              style: TextStyle(
                                fontSize: 11,
                                color: isError ? Colors.red : Colors.green,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            if (uploadResults == null)
              ElevatedButton(
                onPressed: isUploading
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) return;
                        setDialogState(() => isUploading = true);
                        try {
                          final rows = const CsvToListConverter().convert(
                            csvController.text.trim(),
                          );
                          if (rows.length < 2) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('CSV must have a header row and at least one data row')),
                            );
                            setDialogState(() => isUploading = false);
                            return;
                          }
                          final headers = rows.first.map((e) => e.toString().trim()).toList();
                          final employees = <Map<String, dynamic>>[];
                          for (var i = 1; i < rows.length; i++) {
                            final row = rows[i];
                            final Map<String, dynamic> employee = {};
                            for (var j = 0; j < headers.length && j < row.length; j++) {
                              employee[headers[j]] = row[j].toString();
                            }
                            employees.add(employee);
                          }

                          final dio = ref.read(dioProvider);
                          final response = await dio.post(
                            '/bulk-upload/employees',
                            data: {'employees': employees},
                          );
                          final data = response.data;
                          final results = (data['results'] as List?)
                                  ?.map((e) => Map<String, dynamic>.from(e))
                                  .toList() ??
                              [];
                          setDialogState(() {
                            uploadResults = results;
                            successCount = results.where((r) => r['error'] == null).length;
                            errorCount = results.where((r) => r['error'] != null).length;
                            isUploading = false;
                          });
                          ref.invalidate(employeesProvider);
                        } catch (e) {
                          setDialogState(() => isUploading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Upload failed: $e')),
                          );
                        }
                      },
                child: isUploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Upload'),
              ),
          ],
        ),
      ),
    );
  }
}
