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
        final tripId = _activeTrip!['id'];
        final vehicleId = _activeTrip!['vehicleId'];
        if (vehicleId != null) {
          try {
            final locResp = await dio.get('/trips/$tripId/location');
            _gpsLogs = locResp.data['data'] ?? [];
          } catch (_) {
            try {
              final gpsResp = await dio.get('/trips/gps/$vehicleId');
              _gpsLogs = gpsResp.data['data'] ?? [];
            } catch (_) {}
          }
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

    final routeName = _activeTrip!['routeName'] ?? 'Unknown';
    final driverName = _activeTrip!['driverName'] ?? '';
    final vehiclePlate = _activeTrip!['vehiclePlate'] ?? '';
    final latestLog = _gpsLogs.isNotEmpty ? _gpsLogs.last : null;
    final cs = Theme.of(context).colorScheme;
    final scheduledTime = (_activeTrip!['scheduledTime'] ?? '').toString();
    final timePart = scheduledTime.length >= 16 ? scheduledTime.substring(11, 16) : scheduledTime;

    return Column(
      children: [
        // Map Placeholder
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Map background pattern
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _MapPlaceholderPainter(
                        gridColor: cs.outlineVariant.withOpacity(0.3),
                        routeColor: cs.primary.withOpacity(0.6),
                        vehicleColor: cs.error,
                      ),
                    ),
                  ),
                  // Pickup marker
                  if (latestLog != null)
                    Positioned(
                      top: 60,
                      left: 40,
                      child: _mapMarker(Icons.circle, 'Pickup', const Color(0xFF059669)),
                    ),
                  // Drop marker
                  if (latestLog != null)
                    Positioned(
                      bottom: 80,
                      right: 50,
                      child: _mapMarker(Icons.flag, 'Drop', const Color(0xFFDC2626)),
                    ),
                  // Vehicle marker
                  if (latestLog != null)
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.35,
                      left: MediaQuery.of(context).size.width * 0.4,
                      child: _mapMarker(Icons.directions_bus, 'Vehicle', cs.primary),
                    ),
                  // Route line
                  if (latestLog != null)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: CustomPaint(
                        painter: _RouteLinePainter(
                          color: cs.primary.withOpacity(0.4),
                        ),
                      ),
                    ),
                  // Overlay text
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 48, color: cs.outline.withOpacity(0.5)),
                        const SizedBox(height: 12),
                        Text(
                          'Live Map',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'GPS coordinates updating every 10s',
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurface.withOpacity(0.35),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Live badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'LIVE',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SOS Button
                  Positioned(
                    top: 12,
                    left: 12,
                    child: GestureDetector(
                      onTap: () => _showSOSDialog(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.emergency, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bottom Sheet - Trip Info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Trip header
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
                      ],
                    ),
                  ),
                  if (latestLog != null && latestLog['speed'] != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${latestLog['speed']} km/h',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cs.primary),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              // Info rows
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
              if (latestLog != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: cs.primary),
                    const SizedBox(width: 4),
                    Text(
                      '${latestLog['latitude']}, ${latestLog['longitude']}',
                      style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              // Track Trip button
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

  Widget _mapMarker(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: color)),
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

class _MapPlaceholderPainter extends CustomPainter {
  final Color gridColor;
  final Color routeColor;
  final Color vehicleColor;

  _MapPlaceholderPainter({
    required this.gridColor,
    required this.routeColor,
    required this.vehicleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw grid
    paint.color = gridColor;
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Draw route line (diagonal path)
    paint
      ..color = routeColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(60, 80)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.3, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.7, size.width - 60, size.height - 80);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RouteLinePainter extends CustomPainter {
  final Color color;

  _RouteLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(50, 80)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.35, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.65, size.width - 50, size.height - 80);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
