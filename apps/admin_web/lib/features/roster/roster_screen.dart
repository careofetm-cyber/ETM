import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

class RosterScreen extends ConsumerStatefulWidget {
  const RosterScreen({super.key});

  @override
  ConsumerState<RosterScreen> createState() => _RosterScreenState();
}

class _RosterScreenState extends ConsumerState<RosterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _rosters = [];
  List<dynamic> _requests = [];
  Map<String, dynamic>? _docAlerts;
  bool _isLoading = true;
  String _selectedWeekStart = '';
  String _selectedWeekEnd = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _calculateWeek();
    _loadData();
  }

  void _calculateWeek() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    _selectedWeekStart = monday.toIso8601String().substring(0, 10);
    _selectedWeekEnd = sunday.toIso8601String().substring(0, 10);
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final rosterApi = await ref.read(rosterApiProvider.future);
      _rosters = await rosterApi.getRosters(startDate: _selectedWeekStart, endDate: _selectedWeekEnd);
      _requests = await rosterApi.getRosterRequests();
    } catch (e) {
      debugPrint('Error: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Roster Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      final start = DateTime.parse(_selectedWeekStart);
                      final newStart = start.subtract(const Duration(days: 7));
                      final newEnd = newStart.add(const Duration(days: 6));
                      setState(() {
                        _selectedWeekStart = newStart.toIso8601String().substring(0, 10);
                        _selectedWeekEnd = newEnd.toIso8601String().substring(0, 10);
                      });
                      _loadData();
                    },
                  ),
                  Text('$_selectedWeekStart to $_selectedWeekEnd', style: const TextStyle(fontWeight: FontWeight.w500)),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      final start = DateTime.parse(_selectedWeekStart);
                      final newStart = start.add(const Duration(days: 7));
                      final newEnd = newStart.add(const Duration(days: 6));
                      setState(() {
                        _selectedWeekStart = newStart.toIso8601String().substring(0, 10);
                        _selectedWeekEnd = newEnd.toIso8601String().substring(0, 10);
                      });
                      _loadData();
                    },
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showBulkCreateDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Roster'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(text: 'Calendar View (${_rosters.length})'),
              Tab(text: 'Requests (${_requests.where((r) => r['status'] == 'pending').length} pending)'),
              const Tab(text: 'Bulk Operations'),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCalendarView(),
                      _buildRequestsView(),
                      _buildBulkOperationsView(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    if (_rosters.isEmpty) {
      return const Center(child: Text('No roster entries for this week'));
    }

    // Group rosters by date
    final Map<String, List<dynamic>> byDate = {};
    for (var r in _rosters) {
      final date = r['date']?.toString() ?? '';
      byDate.putIfAbsent(date, () => []).add(r);
    }

    // Get unique dates sorted
    final dates = byDate.keys.toList()..sort();

    return SingleChildScrollView(
      child: Card(
        child: DataTable(
          columns: [
            const DataColumn(label: Text('Employee', style: TextStyle(fontWeight: FontWeight.bold))),
            ...dates.map((d) => DataColumn(
              label: Text(d.length > 5 ? d.substring(5) : d, style: const TextStyle(fontWeight: FontWeight.bold)),
            )),
          ],
          rows: _buildCalendarRows(dates, byDate),
        ),
      ),
    );
  }

  List<DataRow> _buildCalendarRows(List<String> dates, Map<String, List<dynamic>> byDate) {
    // Get unique employee IDs
    final employeeIds = _rosters.map((r) => r['employee_id']?.toString() ?? '').toSet().toList();

    return employeeIds.map((empId) {
      return DataRow(cells: [
        DataCell(Text(empId.replaceAll('_emp', '').replaceAll('usr_', '').toUpperCase())),
        ...dates.map((date) {
          final entries = byDate[date]?.where((r) => r['employee_id'] == empId).toList() ?? [];
          if (entries.isEmpty) return const DataCell(Text('-'));
          final entry = entries.first;
          return DataCell(
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: entry['status'] == 'approved' ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry['shift_type'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  Text(entry['route_id'] ?? '', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
          );
        }),
      ]);
    }).toList();
  }

  Widget _buildRequestsView() {
    if (_requests.isEmpty) {
      return const Center(child: Text('No roster requests'));
    }

    return Card(
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Employee')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Current')),
            DataColumn(label: Text('Requested')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _requests.map((req) {
            final statusColor = req['status'] == 'approved'
                ? Colors.green
                : req['status'] == 'rejected'
                    ? Colors.red
                    : Colors.orange;
            return DataRow(cells: [
              DataCell(Text(req['employee_id'] ?? '')),
              DataCell(Chip(
                label: Text(req['request_type'] ?? 'change', style: const TextStyle(fontSize: 12)),
                backgroundColor: Colors.blue.shade50,
              )),
              DataCell(Text(req['current_date'] ?? '')),
              DataCell(Text(req['requested_date'] ?? '')),
              DataCell(Chip(
                label: Text(req['status'] ?? 'pending', style: const TextStyle(fontSize: 12, color: Colors.white)),
                backgroundColor: statusColor,
              )),
              DataCell(
                req['status'] == 'pending'
                    ? Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check_circle, color: Colors.green, size: 20),
                            onPressed: () => _approveRequest(req['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red, size: 20),
                            onPressed: () => _rejectRequest(req['id']),
                          ),
                        ],
                      )
                    : const Text(''),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBulkOperationsView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildActionCard(
                icon: Icons.upload_file,
                title: 'Import Roster',
                subtitle: 'Import from XLS/CSV',
                onTap: () => _showImportDialog(),
              ),
              const SizedBox(width: 16),
              _buildActionCard(
                icon: Icons.download,
                title: 'Export Roster',
                subtitle: 'Download as XLS/PDF',
                onTap: () => _showExportDialog(),
              ),
              const SizedBox(width: 16),
              _buildActionCard(
                icon: Icons.edit_calendar,
                title: 'Bulk Create',
                subtitle: 'Create multiple entries',
                onTap: () => _showBulkCreateDialog(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(icon, size: 48, color: AppColors.primary),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _approveRequest(String id) async {
    final rosterApi = await ref.read(rosterApiProvider.future);
    await rosterApi.approveRosterRequest(id);
    _loadData();
  }

  Future<void> _rejectRequest(String id) async {
    final rosterApi = await ref.read(rosterApiProvider.future);
    await rosterApi.rejectRosterRequest(id, reason: 'Rejected by admin');
    _loadData();
  }

  void _showBulkCreateDialog() {
    final employeeIdController = TextEditingController();
    final dateController = TextEditingController();
    final routeIdController = TextEditingController();
    final stopIdController = TextEditingController();
    String shiftType = 'morning';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Create Roster Entry'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: employeeIdController, decoration: const InputDecoration(labelText: 'Employee ID', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: dateController, decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: routeIdController, decoration: const InputDecoration(labelText: 'Route ID', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: stopIdController, decoration: const InputDecoration(labelText: 'Stop ID', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: shiftType,
                  items: const [
                    DropdownMenuItem(value: 'morning', child: Text('Morning')),
                    DropdownMenuItem(value: 'evening', child: Text('Evening')),
                  ],
                  onChanged: (v) => setDialogState(() => shiftType = v ?? 'morning'),
                  decoration: const InputDecoration(labelText: 'Shift Type', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final api = await ref.read(rosterApiProvider.future);
                await api.createRoster({
                  'employeeId': employeeIdController.text,
                  'date': dateController.text,
                  'routeId': routeIdController.text,
                  'stopId': stopIdController.text,
                  'shiftType': shiftType,
                });
                Navigator.pop(ctx);
                _loadData();
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Roster entry created'), backgroundColor: Colors.green));
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showImportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Import Roster'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Upload a CSV or XLS file with columns:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('employee_id, date, route_id, stop_id, shift_type'),
            const SizedBox(height: 16),
            const Text('Sample format:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
              child: const Text('usr_emp_01_emp, 2026-07-28, route_001, stop_001, morning\nusr_emp_02_emp, 2026-07-28, route_001, stop_002, morning', style: TextStyle(fontSize: 12, fontFamily: 'monospace')),
            ),
            const SizedBox(height: 16),
            const Text('Note: File upload requires the web file picker. Use Bulk Create for manual entry.', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showBulkCreateDialog();
            },
            child: const Text('Use Bulk Create Instead'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() async {
    try {
      final dio = ref.read(dioProvider);
      final resp = await dio.get('/rosters', queryParameters: {'startDate': _selectedWeekStart, 'endDate': _selectedWeekEnd, 'limit': 500});
      final rosters = resp.data['data'] as List? ?? [];

      String csv = 'Employee ID,Date,Route ID,Stop ID,Shift Type,Status\n';
      for (var r in rosters) {
        csv += '${r['employeeId'] ?? ''},${r['date'] ?? ''},${r['routeId'] ?? ''},${r['stopId'] ?? ''},${r['shiftType'] ?? ''},${r['status'] ?? ''}\n';
      }

      // For web, use html anchor to download
      // ignore: avoid_web_libraries_in_flutter
      // Since we can't easily use dart:html here, just copy to clipboard
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(title: const Text('Export Roster')),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Week: $_selectedWeekStart to $_selectedWeekEnd'),
                Text('Total entries: ${rosters.length}'),
                const SizedBox(height: 16),
                const Text('CSV Data (copy and save as .csv):', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                  child: SelectableText(csv, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                )),
              ],
            ),
          ),
        ),
      ));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
