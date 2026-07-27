import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../providers.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});
  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _activeTrip;
  List<dynamic> _gpsLogs = [];
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _loadTracking();
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) => _loadTracking(silent: true));
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadTracking({bool silent = false}) async {
    if (!silent) setState(() { _isLoading = true; _error = null; });
    try {
      final dio = ref.read(dioProvider);
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final userId = prefs.getString('user_id');

      if (userId == null) {
        setState(() { _error = 'User not logged in'; _isLoading = false; });
        return;
      }

      final empResp = await dio.get('/employees/$userId');
      final employeeId = empResp.data['id'] ?? '${userId}_emp';

      try {
        final otpResp = await dio.get('/otp/employee/$employeeId');
        _activeTrip = otpResp.data['trip'];
      } catch (_) {}

      if (_activeTrip != null) {
        final vehicleId = _activeTrip!['vehicleId'] ?? _activeTrip!['vehicle_id'];
        if (vehicleId != null) {
          final gpsResp = await dio.get('/trips/gps/$vehicleId');
          _gpsLogs = gpsResp.data['data'] ?? [];
        }
      }
    } on DioException catch (e) {
      if (!silent) setState(() => _error = e.response?.data?['error'] ?? 'Failed to load tracking');
    } catch (e) {
      if (!silent) setState(() => _error = 'Network error: $e');
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Tracking'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => _loadTracking(), tooltip: 'Refresh'),
        ],
      ),
      body: SafeArea(
        child: _isLoading && _gpsLogs.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : _error != null && _gpsLogs.isEmpty
                ? _buildError()
                : _buildTrackingView(),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline, size: 48, color: Colors.red),
            ),
            const SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _loadTracking,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingView() {
    if (_activeTrip == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_off_outlined, size: 56, color: Theme.of(context).colorScheme.outline),
              ),
              const SizedBox(height: 20),
              Text('No Active Trip', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              Text('No trip is currently in progress to track.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade500)),
            ],
          ),
        ),
      );
    }

    final routeName = _activeTrip!['routeName'] ?? _activeTrip!['route_id'] ?? 'Unknown';
    final driverName = _activeTrip!['driverName'] ?? '';
    final vehiclePlate = _activeTrip!['vehiclePlate'] ?? _activeTrip!['plate_number'] ?? '';
    final latestLog = _gpsLogs.isNotEmpty ? _gpsLogs.last : null;
    final cs = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () => _loadTracking(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Trip Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.directions_bus, color: cs.onPrimaryContainer),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(routeName, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                            if (vehiclePlate.isNotEmpty)
                              Text('Vehicle: $vehiclePlate', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                            if (driverName.isNotEmpty)
                              Text('Driver: $driverName', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(color: Color(0xFF059669), shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'LIVE',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Location Card
          if (latestLog != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.location_on, color: cs.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text('Current Location', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    _locationRow('Latitude', '${latestLog['latitude']}'),
                    const SizedBox(height: 4),
                    _locationRow('Longitude', '${latestLog['longitude']}'),
                    if (latestLog['speed'] != null) ...[
                      const SizedBox(height: 4),
                      _locationRow('Speed', '${latestLog['speed']} km/h'),
                    ],
                    if (latestLog['heading'] != null) ...[
                      const SizedBox(height: 4),
                      _locationRow('Heading', '${latestLog['heading']}°'),
                    ],
                    const SizedBox(height: 4),
                    _locationRow('Last Updated', '${latestLog['timestamp'] ?? 'Unknown'}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // GPS History
          Row(
            children: [
              Icon(Icons.history, size: 20, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                'GPS History (${_gpsLogs.length} points)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_gpsLogs.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.gps_off, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text('No GPS data available yet', style: TextStyle(color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              ),
            )
          else
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _gpsLogs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final log = _gpsLogs[_gpsLogs.length - 1 - index];
                  final isLatest = index == 0;

                  return ListTile(
                    dense: true,
                    leading: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isLatest ? cs.primary.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isLatest ? Icons.location_on : Icons.circle,
                        size: isLatest ? 18 : 8,
                        color: isLatest ? cs.primary : Colors.grey,
                      ),
                    ),
                    title: Text(
                      '${log['latitude']}, ${log['longitude']}',
                      style: TextStyle(fontSize: 13, fontFamily: 'monospace', fontWeight: isLatest ? FontWeight.w600 : FontWeight.normal),
                    ),
                    subtitle: Text(
                      '${log['timestamp'] ?? ''}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: log['speed'] != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('${log['speed']} km/h', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                          )
                        : null,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _locationRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: 'monospace', fontSize: 13)),
      ],
    );
  }
}
