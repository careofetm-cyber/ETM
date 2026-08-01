import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../../providers.dart';

class RideScreen extends ConsumerStatefulWidget {
  const RideScreen({super.key});
  @override
  ConsumerState<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends ConsumerState<RideScreen> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _otpData;
  Map<String, dynamic>? _trip;
  List<dynamic> _passengers = [];

  @override
  void initState() {
    super.initState();
    _loadRideInfo();
  }

  Future<void> _loadRideInfo() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final dio = ref.read(dioProvider);
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final userId = prefs.getString('user_id');
      if (userId == null) {
        setState(() { _error = 'User not logged in'; _isLoading = false; });
        return;
      }

      final employeeId = '${userId}_emp';

      try {
        final otpResp = await dio.get('/otp/employee/$employeeId');
        _otpData = otpResp.data;
        _trip = otpResp.data['trip'];

        if (_trip != null) {
          final tripId = _trip!['id'];
          final passResp = await dio.get('/trips/$tripId/passengers');
          _passengers = passResp.data['data'] ?? [];
        }
      } on DioException catch (otpErr) {
        if (otpErr.response?.statusCode == 404 || otpErr.type == DioExceptionType.badResponse) {
          try {
            final dashResp = await dio.get('/dashboard/employee');
            final dashData = dashResp.data;
            if (dashData['nextTrip'] != null) {
              _trip = dashData['nextTrip'];
              if (_trip != null) {
                final tripId = _trip!['id'];
                final passResp = await dio.get('/trips/$tripId/passengers');
                _passengers = passResp.data['data'] ?? [];
                _otpData = {'otp': 'Check with driver', 'verified': false, 'trip': _trip};
              }
            }
          } catch (_) {
            _otpData = null;
            _trip = null;
          }
        } else {
          setState(() => _error = 'Failed to load ride info');
          return;
        }
      }
    } on DioException catch (e) {
      setState(() => _error = e.response?.data?['error'] ?? 'Failed to load ride info');
    } catch (e) {
      setState(() => _error = 'Network error: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _buildError()
                : _otpData == null || _trip == null
                    ? _buildNoTrip()
                    : _otpData!['verified'] == true
                        ? _buildVerified()
                        : _buildOtpView(),
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
              onPressed: _loadRideInfo,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoTrip() {
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
              child: Icon(Icons.directions_bus_outlined, size: 56, color: Theme.of(context).colorScheme.outline),
            ),
            const SizedBox(height: 20),
            Text('No Active Trip', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              'You don\'t have an assigned cab right now.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _loadRideInfo,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpView() {
    final otp = _otpData!['otp'] ?? '';
    final expiresAt = _otpData!['expiresAt'] ?? '';
    final routeName = _trip!['routeName'] ?? _trip!['routeId'] ?? 'Unknown Route';
    final vehiclePlate = _trip!['vehiclePlate'] ?? _trip!['plateNumber'] ?? '';
    final driverName = _trip!['driverName'] ?? '';
    final scheduledTime = (_trip!['scheduledTime'] ?? '').toString();
    final timePart = scheduledTime.length >= 16 ? scheduledTime.substring(11, 16) : scheduledTime;

    DateTime? expiry;
    try { expiry = DateTime.parse(expiresAt); } catch (_) {}
    final isExpired = expiry != null && DateTime.now().isAfter(expiry);
    final remaining = expiry != null ? expiry.difference(DateTime.now()) : Duration.zero;
    final remainingMin = remaining.inMinutes;
    final cs = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: _loadRideInfo,
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
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text('Scheduled: $timePart', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // OTP Display Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: isExpired
                  ? LinearGradient(colors: [Colors.red.shade50, Colors.red.shade100])
                  : LinearGradient(
                      colors: [cs.primaryContainer.withOpacity(0.5), cs.primaryContainer.withOpacity(0.2)],
                    ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isExpired ? Colors.red.withOpacity(0.3) : cs.primary.withOpacity(0.15),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isExpired ? Colors.red.withOpacity(0.15) : cs.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isExpired ? Icons.timer_off : Icons.pin,
                    size: 32,
                    color: isExpired ? Colors.red : cs.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isExpired ? 'OTP Expired' : 'Show this OTP to your driver',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isExpired ? Colors.red : cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  otp,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 12,
                    color: isExpired ? Colors.red : null,
                  ),
                ),
                const SizedBox(height: 16),
                if (isExpired)
                  FilledButton.icon(
                    onPressed: _loadRideInfo,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Get New OTP'),
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Valid for $remainingMin min',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: cs.primary),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // SOS Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showSOSDialog(),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDC2626).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emergency, color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Text(
                      'SOS - Emergency',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Passengers
          if (_passengers.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.people, size: 20, color: cs.primary),
                const SizedBox(width: 8),
                Text(
                  'Passengers (${_passengers.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: _passengers.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final p = entry.value;
                  final isBoarded = p['isBoarded'] == true;
                  final isDropped = p['isDropped'] == true;
                  final firstName = p['firstName'] ?? '';
                  final lastName = p['lastName'] ?? '';
                  final name = '$firstName $lastName'.trim();

                  final statusColor = isDropped ? const Color(0xFF059669) : isBoarded ? const Color(0xFFD97706) : Colors.grey;
                  final statusText = isDropped ? 'Dropped' : isBoarded ? 'Boarded' : 'Pending';
                  final statusIcon = isDropped ? Icons.check_circle : isBoarded ? Icons.person : Icons.person_outline;

                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: statusColor.withOpacity(0.12),
                          child: Icon(statusIcon, color: statusColor, size: 20),
                        ),
                        title: Text(name.isNotEmpty ? name : 'Unknown', style: const TextStyle(fontWeight: FontWeight.w500)),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                          ),
                        ),
                      ),
                      if (idx < _passengers.length - 1) const Divider(height: 1, indent: 56),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
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
      final tripId = _trip?['id'];
      await dio.post('/sos/', data: {
        'message': 'Emergency SOS alert from employee',
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

  Widget _buildVerified() {
    final tripStatus = _trip?['status'] ?? '';
    final isInProgress = tripStatus == 'inProgress';
    final cs = Theme.of(context).colorScheme;
    final routeName = _trip!['routeName'] ?? 'Assigned Route';
    final vehiclePlate = _trip!['vehiclePlate'] ?? '';
    final driverName = _trip!['driverName'] ?? '';

    return RefreshIndicator(
      onRefresh: _loadRideInfo,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isInProgress
                    ? [const Color(0xFF059669).withOpacity(0.1), const Color(0xFF059669).withOpacity(0.05)]
                    : [const Color(0xFF059669).withOpacity(0.1), const Color(0xFF059669).withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF059669).withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isInProgress ? Icons.directions_bus : Icons.check_circle,
                    size: 48,
                    color: const Color(0xFF059669),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isInProgress ? 'Trip In Progress' : 'Ride Verified!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF059669),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isInProgress
                      ? 'Your driver is on the way. Track your trip live.'
                      : 'Your OTP has been verified. Trip is in progress.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Trip Info
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
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Track Trip Button (only when in progress)
          if (isInProgress) ...[
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: () => context.push('/tracking'),
                icon: const Icon(Icons.location_on),
                label: const Text('Track Trip Live'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // SOS Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showSOSDialog(),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emergency, color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Text(
                      'SOS - Emergency',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Passengers
          if (_passengers.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.people, size: 20, color: cs.primary),
                const SizedBox(width: 8),
                Text(
                  'Passengers (${_passengers.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: _passengers.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final p = entry.value;
                  final isBoarded = p['isBoarded'] == true;
                  final isDropped = p['isDropped'] == true;
                  final firstName = p['firstName'] ?? '';
                  final lastName = p['lastName'] ?? '';
                  final name = '$firstName $lastName'.trim();

                  final statusColor = isDropped ? const Color(0xFF059669) : isBoarded ? const Color(0xFFD97706) : Colors.grey;
                  final statusText = isDropped ? 'Dropped' : isBoarded ? 'Boarded' : 'Pending';
                  final statusIcon = isDropped ? Icons.check_circle : isBoarded ? Icons.person : Icons.person_outline;

                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: statusColor.withOpacity(0.12),
                          child: Icon(statusIcon, color: statusColor, size: 20),
                        ),
                        title: Text(name.isNotEmpty ? name : 'Unknown', style: const TextStyle(fontWeight: FontWeight.w500)),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                          ),
                        ),
                      ),
                      if (idx < _passengers.length - 1) const Divider(height: 1, indent: 56),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
