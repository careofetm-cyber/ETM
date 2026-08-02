import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../providers.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  final String tripId;
  const TrackingScreen({super.key, required this.tripId});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  List<dynamic> _passengers = [];
  bool _isLoading = true;
  String? _error;
  Timer? _refreshTimer;
  Timer? _gpsTimer;
  Position? _currentPosition;
  final MapController _mapController = MapController();
  LatLng? _driverLatLng;
  List<LatLng> _routePoints = [];
  List<dynamic> _stops = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) => _loadData(silent: true));
    _initGps();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _gpsTimer?.cancel();
    super.dispose();
  }

  Future<void> _initGps() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    _gpsTimer = Timer.periodic(const Duration(seconds: 30), (_) => _sendGpsUpdate());
    _sendGpsUpdate();
  }

  Future<void> _sendGpsUpdate() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      _currentPosition = position;
      _driverLatLng = LatLng(position.latitude, position.longitude);
      _routePoints.add(_driverLatLng!);

      final dio = ref.read(dioProvider);
      await dio.post('/trips/location', data: {
        'tripId': widget.tripId,
        'vehicleId': _passengers.isNotEmpty ? null : null,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'speed': position.speed,
        'heading': position.heading,
      });

      if (mounted) {
        try { _mapController.move(_driverLatLng!, _mapController.camera.zoom); } catch (_) {}
        setState(() {});
      }
    } catch (e) {
      debugPrint('GPS update failed: $e');
    }
  }

  Future<void> _loadData({bool silent = false}) async {
    try {
      final dio = ref.read(dioProvider);
      final locResp = await dio.get('/trips/${widget.tripId}/location');
      final passResp = await dio.get('/trips/${widget.tripId}/passengers');
      final stopsResp = await dio.get('/trips/${widget.tripId}/stops');

      final locData = locResp.data['data'];

      if (locData != null) {
        final lat = locData['latitude'];
        final lng = locData['longitude'];
        if (lat != null && lng != null) {
          final pos = LatLng(
            (lat is num) ? lat.toDouble() : double.tryParse('$lat') ?? 0,
            (lng is num) ? lng.toDouble() : double.tryParse('$lng') ?? 0,
          );
          _driverLatLng = pos;
          if (!_routePoints.contains(pos)) _routePoints.add(pos);
        }
      }

      if (mounted) {
        setState(() {
          _passengers = passResp.data['data'] ?? [];
          _stops = stopsResp.data['data'] ?? [];
          _isLoading = false;
        });
        if (_driverLatLng != null) {
          try { _mapController.move(_driverLatLng!, 15); } catch (_) {}
        }
      }
    } on DioException catch (e) {
      if (!silent && mounted) {
        setState(() {
          _error = e.response?.data?['error'] ?? 'Failed to load tracking';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!silent && mounted) {
        setState(() {
          _error = 'Network error';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendSos() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
        title: const Text('Send SOS Alert?'),
        content: const Text('This will alert the admin and emergency contacts immediately.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Send SOS'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      try {
        final dio = ref.read(dioProvider);
        await dio.post('/sos/', data: {
          'message': 'Emergency SOS alert from driver',
          'tripId': widget.tripId,
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('SOS alert sent'), backgroundColor: Colors.red),
          );
        }
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final passengerCount = _passengers.length;
    final boardedCount = _passengers.where((p) => p['isBoarded'] == true).length;
    final droppedCount = _passengers.where((p) => p['isDropped'] == true).length;

    final defaultCenter = LatLng(19.0760, 72.8777);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Tracking'),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 8, color: Colors.green),
                SizedBox(width: 6),
                Text('LIVE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: cs.error),
                      const SizedBox(height: 12),
                      Text(_error!, style: TextStyle(color: cs.error)),
                      const SizedBox(height: 16),
                      FilledButton.icon(onPressed: _loadData, icon: const Icon(Icons.refresh), label: const Text('Retry')),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: _driverLatLng ?? defaultCenter,
                            initialZoom: 15,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.etm.driverapp',
                            ),
                            if (_routePoints.length > 1)
                              PolylineLayer(
                                polylines: [
                                  Polyline(
                                    points: _routePoints,
                                    color: cs.primary,
                                    strokeWidth: 4,
                                  ),
                                ],
                              ),
                            MarkerLayer(
                              markers: [
                                if (_driverLatLng != null)
                                  Marker(
                                    point: _driverLatLng!,
                                    width: 40,
                                    height: 40,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: cs.primary,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(color: cs.primary.withOpacity(0.4), blurRadius: 12, spreadRadius: 2),
                                        ],
                                      ),
                                      child: const Icon(Icons.directions_car, color: Colors.white, size: 20),
                                    ),
                                  ),
                                ..._stops.map((stop) {
                                  final lat = (stop['latitude'] as num?)?.toDouble();
                                  final lng = (stop['longitude'] as num?)?.toDouble();
                                  if (lat == null || lng == null) return null;
                                  return Marker(
                                    point: LatLng(lat, lng),
                                    width: 28,
                                    height: 28,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.location_on, color: Colors.white, size: 14),
                                    ),
                                  );
                                }).whereType<Marker>(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      flex: 4,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _TrackingStat(icon: Icons.people_outlined, label: 'Total', value: '$passengerCount', color: cs.primary, bgColor: cs.primaryContainer),
                                const SizedBox(width: 8),
                                _TrackingStat(icon: Icons.login, label: 'Boarded', value: '$boardedCount', color: Colors.orange.shade700, bgColor: Colors.orange.shade50),
                                const SizedBox(width: 8),
                                _TrackingStat(icon: Icons.check_circle_outline, label: 'Dropped', value: '$droppedCount', color: Colors.green.shade700, bgColor: Colors.green.shade50),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: Card(
                                margin: EdgeInsets.zero,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                                      child: Text('Passengers', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(
                                      child: _passengers.isEmpty
                                          ? Center(child: Text('No passengers', style: TextStyle(color: cs.onSurfaceVariant)))
                                          : ListView.separated(
                                              padding: const EdgeInsets.symmetric(horizontal: 16),
                                              itemCount: _passengers.length,
                                              separatorBuilder: (_, __) => const Divider(height: 1),
                                              itemBuilder: (context, index) {
                                                final p = _passengers[index];
                                                final name = '${p['firstName'] ?? ''} ${p['lastName'] ?? ''}'.trim();
                                                final isBoarded = p['isBoarded'] == true;
                                                final isDropped = p['isDropped'] == true;
                                                final statusColor = isDropped ? Colors.green : isBoarded ? Colors.orange : cs.onSurfaceVariant;
                                                final statusLabel = isDropped ? 'Dropped' : isBoarded ? 'Boarded' : 'Pending';

                                                return ListTile(
                                                  dense: true,
                                                  contentPadding: const EdgeInsets.symmetric(vertical: 2),
                                                  leading: CircleAvatar(
                                                    radius: 14,
                                                    backgroundColor: statusColor.withOpacity(0.1),
                                                    child: Icon(isDropped ? Icons.check_circle : isBoarded ? Icons.person : Icons.person_outline, color: statusColor, size: 16),
                                                  ),
                                                  title: Text(name.isNotEmpty ? name : 'Unknown', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                                  trailing: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                    decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                                    child: Text(statusLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton.icon(
                          onPressed: _sendSos,
                          icon: const Icon(Icons.emergency, size: 20),
                          label: const Text('SOS Alert'),
                          style: FilledButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _TrackingStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  const _TrackingStat({required this.icon, required this.label, required this.value, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
                Text(label, style: TextStyle(fontSize: 10, color: color.withOpacity(0.8))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
