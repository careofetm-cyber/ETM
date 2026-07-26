import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';

class RosterScreen extends ConsumerStatefulWidget {
  const RosterScreen({super.key});
  @override
  ConsumerState<RosterScreen> createState() => _RosterScreenState();
}

class _RosterScreenState extends ConsumerState<RosterScreen> {
  List<dynamic> _rosters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRosters();
  }

  Future<void> _loadRosters() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final userId = prefs.getString('user_id');
      if (userId != null) {
        final dio = ref.read(dioProvider);
        final now = DateTime.now();
        final monday = now.subtract(Duration(days: now.weekday - 1));
        final sunday = monday.add(const Duration(days: 6));
        final resp = await dio.get('/rosters/employee/${userId}_emp', queryParameters: {
          'startDate': monday.toIso8601String().substring(0, 10),
          'endDate': sunday.toIso8601String().substring(0, 10),
        });
        _rosters = resp.data['data'] ?? [];
      }
    } catch (e) {
      debugPrint('Roster error: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Roster')),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadRosters,
                child: _rosters.isEmpty
                    ? const Center(child: Text('No roster entries this week'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _rosters.length,
                        itemBuilder: (context, index) {
                          final roster = _rosters[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: roster['shiftType'] == 'morning' ? Colors.orange : Colors.indigo,
                                child: Icon(
                                  roster['shiftType'] == 'morning' ? Icons.wb_sunny : Icons.nightlight_round,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(roster['date'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Route: ${roster['routeId'] ?? "N/A"}'),
                                  Text('Stop: ${roster['stopId'] ?? "N/A"}'),
                                  Text('Shift: ${roster['shiftType'] ?? "N/A"} | Status: ${roster['status'] ?? "N/A"}'),
                                ],
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
