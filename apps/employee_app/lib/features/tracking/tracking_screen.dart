import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
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
  LatLng? _driverLatLng;
  LatLng? _employeeLatLng;
  List<LatLng> _routePoints = [];
  List<dynamic> _stops = [];
  Timer? _pollTimer;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _loadTracking();
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) => _loadTracking(silent: true));
    _fetchEmployeeLocation();
  }

  Future<void> _fetchEmployeeLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      if (mounted) {
        setState(() => _employeeLatLng = LatLng(position.latitude, position.longitude));
      }
    } catch (_) {}
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

      try {
        final dashResp = await dio.get('/dashboard/employee');
        final dashData = dashResp.data;
        if (dashData['nextTrip'] != null) {
          _activeTrip = dashData['nextTrip'];
        }
      } catch (_) {}

      if (_activeTrip != null) {
        final tripId = _activeTrip!['id'];
        final vehicleId = _activeTrip!['vehicleId'];
        if (vehicleId != null) {
          try {
            final locResp = await dio.get('/trips/$tripId/location');
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
          } catch (_) {}
        }

        try {
          final stopsResp = await dio.get('/trips/${_activeTrip!['id']}/stops');
          _stops = stopsResp.data['data'] ?? [];
        } catch (_) {}
      }
    } on DioException catch (e) {
      if (!silent) setState(() => _error = e.response?.data?['error'] ?? 'Failed to load tracking');
    } catch (e) {
      if (!silent) setState(() => _error = 'Network error: $e');
    }
    if (mounted) {
      setState(() => _isLoading = false);
      if (_driverLatLng != null) {
        try { _mapController.move(_driverLatLng!, 15); } catch (_) {}
      }
    }
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
        child: _isLoading && _activeTrip == null
            ? const Center(child: CircularProgressIndicator())
            : _error != null && _activeTrip == null
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
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.error_outline, size: 48, color: Colors.red),
            ),
            const SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            FilledButton.icon(onPressed: _loadTracking, icon: const Icon(Icons.refresh), label: const Text('Retry')),
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

    final routeName = _activeTrip!['routeName'] ?? 'Unknown';
    final driverName = _activeTrip!['driverName'] ?? '';
    final vehiclePlate = _activeTrip!['vehiclePlate'] ?? '';
    final cs = Theme.of(context).colorScheme;
    final scheduledTime = (_activeTrip!['scheduledTime'] ?? '').toString();
    final timePart = scheduledTime.length >= 16 ? scheduledTime.substring(11, 16) : scheduledTime;
    final defaultCenter = LatLng(19.0760, 72.8777);

    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _driverLatLng ?? defaultCenter,
                    initialZoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.etm.employeeapp',
                    ),
                    if (_routePoints.length > 1)
                      PolylineLayer(
                        polylines: [
                          Polyline(points: _routePoints, color: cs.primary, strokeWidth: 4),
                        ],
                      ),
                    MarkerLayer(
                      markers: [
                        if (_employeeLatLng != null)
                          Marker(
                            point: _employeeLatLng!,
                            width: 36,
                            height: 36,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.4), blurRadius: 10, spreadRadius: 2)],
                              ),
                              child: const Icon(Icons.person, color: Colors.white, size: 18),
                            ),
                          ),
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
                                boxShadow: [BoxShadow(color: cs.primary.withOpacity(0.4), blurRadius: 12, spreadRadius: 2)],
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
                              decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                              child: const Icon(Icons.location_on, color: Colors.white, size: 14),
                            ),
                          );
                        }).whereType<Marker>(),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: const Color(0xFF059669), borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 8, color: Colors.white),
                        SizedBox(width: 6),
                        Text('LIVE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: () => _showSOSDialog(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: const Color(0xFFDC2626), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.emergency, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -4))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: cs.outlineVariant, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: cs.primaryContainer, borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.directions_car, color: cs.onPrimaryContainer),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(routeName, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                        if (vehiclePlate.isNotEmpty)
                          Text('Vehicle: $vehiclePlate', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (driverName.isNotEmpty) ...[
                    Icon(Icons.person, size: 16, color: cs.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(driverName, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
                    const SizedBox(width: 16),
                  ],
                  if (timePart.isNotEmpty) ...[
                    Icon(Icons.access_time, size: 16, color: cs.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text('ETA: $timePart', style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant, fontWeight: FontWeight.w500)),
                  ],
                ],
              ),
              if (_driverLatLng != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: cs.primary),
                    const SizedBox(width: 4),
                    Text(
                      '${_driverLatLng!.latitude.toStringAsFixed(4)}, ${_driverLatLng!.longitude.toStringAsFixed(4)}',
                      style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _loadTracking,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Location'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showSOSDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.red),
        title: const Text('Send SOS Alert?'),
        content: const Text('This will immediately alert your transport manager. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            icon: const Icon(Icons.send),
            label: const Text('SEND SOS'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      final dio = ref.read(dioProvider);
      final tripId = _activeTrip?['id'];
      await dio.post('/sos/', data: {
        'message': 'Emergency SOS alert from employee during tracking',
        if (tripId != null) 'tripId': tripId,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SOS alert sent successfully'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send SOS: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
