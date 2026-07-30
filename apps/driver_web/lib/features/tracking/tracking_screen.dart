import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../providers.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  final String tripId;
  const TrackingScreen({super.key, required this.tripId});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  Map<String, dynamic>? _tripLocation;
  List<dynamic> _passengers = [];
  bool _isLoading = true;
  String? _error;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) => _loadData());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final dio = ref.read(dioProvider);
      final locResp = await dio.get('/trips/${widget.tripId}/location');
      final passResp = await dio.get('/trips/${widget.tripId}/passengers');
      if (mounted) {
        setState(() {
          _tripLocation = locResp.data;
          _passengers = passResp.data['data'] ?? [];
          _isLoading = false;
        });
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.response?.data?['error'] ?? 'Failed to load location';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
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
        await dio.post('/trips/${widget.tripId}/sos');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('SOS alert sent'), backgroundColor: Colors.red),
          );
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to send SOS'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    final padding = width < 600 ? 16.0 : width < 900 ? 24.0 : 32.0;
    final useWideLayout = width > 800;

    final driverLat = _tripLocation?['driverLatitude'] ?? _tripLocation?['driverLat'];
    final driverLng = _tripLocation?['driverLongitude'] ?? _tripLocation?['driverLng'];
    final stops = _tripLocation?['stops'] ?? [];
    final passengerCount = _passengers.length;
    final boardedCount = _passengers.where((p) => p['isBoarded'] == true).length;
    final droppedCount = _passengers.where((p) => p['isDropped'] == true).length;

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
                Text('LIVE',
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700, color: Colors.green)),
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
                      FilledButton.icon(
                        onPressed: _loadData,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : useWideLayout
                  ? _buildWideLayout(
                      driverLat, driverLng, stops, passengerCount, boardedCount, droppedCount, cs, padding)
                  : _buildNarrowLayout(
                      driverLat, driverLng, stops, passengerCount, boardedCount, droppedCount, cs, padding),
    );
  }

  Widget _buildWideLayout(dynamic driverLat, dynamic driverLng, List stops,
      int passengerCount, int boardedCount, int droppedCount, ColorScheme cs, double padding) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _buildMapArea(driverLat, driverLng, stops, cs, padding),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 2,
          child: _buildSidePanel(
              passengerCount, boardedCount, droppedCount, cs, padding),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(dynamic driverLat, dynamic driverLng, List stops,
      int passengerCount, int boardedCount, int droppedCount, ColorScheme cs, double padding) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: _buildMapArea(driverLat, driverLng, stops, cs, padding),
        ),
        const SizedBox(height: 12),
        Expanded(
          flex: 4,
          child: _buildSidePanel(
              passengerCount, boardedCount, droppedCount, cs, padding),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: _sendSos,
              icon: const Icon(Icons.emergency, size: 20),
              label: const Text('SOS Alert'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapArea(dynamic driverLat, dynamic driverLng, List stops, ColorScheme cs, double padding) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(padding, padding, padding, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            cs.primaryContainer,
            cs.primary.withOpacity(0.3),
            cs.tertiaryContainer.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _RoutePainter(color: cs.primary.withOpacity(0.5)),
            ),
          ),
          if (driverLat != null && driverLng != null)
            Positioned(
              top: 80,
              left: 120,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.directions_bus, color: Colors.white, size: 20),
              ),
            )
          else
            Positioned(
              top: 70,
              left: 110,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.directions_bus, color: Colors.white, size: 20),
              ),
            ),
          ...List.generate(stops.length, (i) {
            final stop = stops[i];
            final isCompleted = stop['isCompleted'] == true;
            final positions = [
              const {'top': 20.0, 'left': 30.0},
              const {'top': 40.0, 'left': 200.0},
              const {'top': 140.0, 'left': 220.0},
              const {'top': 180.0, 'left': 40.0},
              const {'top': 110.0, 'left': 180.0},
            ];
            final pos = positions[i % positions.length];
            return Positioned(
              top: pos['top'],
              left: pos['left'],
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green : Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  isCompleted ? Icons.check : Icons.location_on,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            );
          }),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.my_location, size: 14, color: cs.primary),
                  const SizedBox(width: 6),
                  Text(
                    driverLat != null
                        ? '${double.tryParse(driverLat.toString())?.toStringAsFixed(4)}, ${double.tryParse(driverLng.toString())?.toStringAsFixed(4)}'
                        : 'Location pending',
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600, color: cs.onSurface),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidePanel(int passengerCount, int boardedCount, int droppedCount,
      ColorScheme cs, double padding) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
      child: Column(
        children: [
          Row(
            children: [
              _TrackingStat(
                  icon: Icons.people_outlined,
                  label: 'Total',
                  value: '$passengerCount',
                  color: cs.primary,
                  bgColor: cs.primaryContainer),
              const SizedBox(width: 8),
              _TrackingStat(
                  icon: Icons.login,
                  label: 'Boarded',
                  value: '$boardedCount',
                  color: Colors.orange.shade700,
                  bgColor: Colors.orange.shade50),
              const SizedBox(width: 8),
              _TrackingStat(
                  icon: Icons.check_circle_outline,
                  label: 'Dropped',
                  value: '$droppedCount',
                  color: Colors.green.shade700,
                  bgColor: Colors.green.shade50),
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
                    child: Text('Passengers',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: _passengers.isEmpty
                        ? Center(
                            child: Text('No passengers',
                                style: TextStyle(color: cs.onSurfaceVariant)))
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _passengers.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final p = _passengers[index];
                              final firstName = p['firstName'] ?? '';
                              final lastName = p['lastName'] ?? '';
                              final name = '$firstName $lastName'.trim();
                              final isBoarded = p['isBoarded'] == true;
                              final isDropped = p['isDropped'] == true;

                              Color statusColor;
                              String statusLabel;
                              if (isDropped) {
                                statusColor = Colors.green;
                                statusLabel = 'Dropped';
                              } else if (isBoarded) {
                                statusColor = Colors.orange;
                                statusLabel = 'Boarded';
                              } else {
                                statusColor = cs.onSurfaceVariant;
                                statusLabel = 'Pending';
                              }

                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 2),
                                leading: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: statusColor.withOpacity(0.1),
                                  child: Icon(
                                    isDropped
                                        ? Icons.check_circle
                                        : isBoarded
                                            ? Icons.person
                                            : Icons.person_outline,
                                    color: statusColor,
                                    size: 16,
                                  ),
                                ),
                                title: Text(name.isNotEmpty ? name : 'Unknown',
                                    style: const TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.w500)),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(statusLabel,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: statusColor)),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: _sendSos,
              icon: const Icon(Icons.emergency, size: 20),
              label: const Text('SOS Alert'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
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

  const _TrackingStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
                Text(label,
                    style:
                        TextStyle(fontSize: 10, color: color.withOpacity(0.8))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  final Color color;
  _RoutePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.6,
      size.width * 0.5,
      size.height * 0.45,
    );
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.3,
      size.width * 0.9,
      size.height * 0.7,
    );
    canvas.drawPath(path, paint);

    final dashPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path2 = Path();
    path2.moveTo(size.width * 0.5, size.height * 0.45);
    path2.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.8,
      size.width * 0.85,
      size.height * 0.85,
    );
    canvas.drawPath(path2, dashPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
