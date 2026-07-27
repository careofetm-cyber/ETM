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

      // Get employee info to find current trip
      final empResp = await dio.get('/employees/$userId');
      final employeeId = empResp.data['id'] ?? '${userId}_emp';

      // Try to get OTP/trip info
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
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => _loadTracking()),
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
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loadTracking, child: const Text('Retry')),
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
              Icon(Icons.location_off_outlined, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text('No Active Trip', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              const Text('No trip is currently in progress to track.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    final routeName = _activeTrip!['routeName'] ?? _activeTrip!['route_id'] ?? 'Unknown';
    final driverName = _activeTrip!['driverName'] ?? '';
    final vehiclePlate = _activeTrip!['vehiclePlate'] ?? _activeTrip!['plate_number'] ?? '';
    final latestLog = _gpsLogs.isNotEmpty ? _gpsLogs.last : null;

    return RefreshIndicator(
      onRefresh: () => _loadTracking(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.directions_bus, color: Theme.of(context).colorScheme.onPrimaryContainer),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            const Text('LIVE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
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

          if (latestLog != null) ...[
            Card(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current Location', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _locationRow('Latitude', '${latestLog['latitude']}'),
                    _locationRow('Longitude', '${latestLog['longitude']}'),
                    if (latestLog['speed'] != null)
                      _locationRow('Speed', '${latestLog['speed']} km/h'),
                    if (latestLog['heading'] != null)
                      _locationRow('Heading', '${latestLog['heading']}°'),
                    _locationRow('Last Updated', '${latestLog['timestamp'] ?? 'Unknown'}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          Text('GPS History (${_gpsLogs.length} points)', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (_gpsLogs.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('No GPS data available yet')),
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
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      index == 0 ? Icons.location_on : Icons.circle,
                      size: index == 0 ? 24 : 8,
                      color: index == 0 ? Colors.red : Colors.grey,
                    ),
                    title: Text(
                      '${log['latitude']}, ${log['longitude']}',
                      style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
                    ),
                    subtitle: Text(
                      '${log['timestamp'] ?? ''}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: log['speed'] != null
                        ? Text('${log['speed']} km/h', style: const TextStyle(fontSize: 12))
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: 'monospace', fontSize: 13)),
        ],
      ),
    );
  }
}
