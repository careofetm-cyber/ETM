import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

      final empResp = await dio.get('/employees/$userId');
      final employeeId = empResp.data['id'] ?? '${userId}_emp';

      final otpResp = await dio.get('/otp/employee/$employeeId');
      _otpData = otpResp.data;
      _trip = otpResp.data['trip'];

      if (_trip != null) {
        final tripId = _trip!['id'];
        final passResp = await dio.get('/trips/$tripId/passengers');
        _passengers = passResp.data['data'] ?? [];
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
      appBar: AppBar(
        title: const Text('My Ride'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRideInfo,
          ),
        ],
      ),
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
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loadRideInfo, child: const Text('Retry')),
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
            Icon(Icons.directions_bus_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('No Active Trip', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text('You don\'t have an assigned cab right now.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpView() {
    final otp = _otpData!['otp'] ?? '';
    final expiresAt = _otpData!['expiresAt'] ?? '';
    final routeName = _trip!['routeName'] ?? _trip!['route_id'] ?? 'Unknown Route';
    final vehiclePlate = _trip!['vehiclePlate'] ?? _trip!['plate_number'] ?? '';
    final driverName = _trip!['driverName'] ?? '';
    final scheduledTime = (_trip!['scheduledTime'] ?? _trip!['scheduled_time'] ?? '').toString();
    final timePart = scheduledTime.length >= 16 ? scheduledTime.substring(11, 16) : scheduledTime;

    DateTime? expiry;
    try { expiry = DateTime.parse(expiresAt); } catch (_) {}
    final isExpired = expiry != null && DateTime.now().isAfter(expiry);
    final remaining = expiry != null ? expiry.difference(DateTime.now()) : Duration.zero;
    final remainingMin = remaining.inMinutes;

    return RefreshIndicator(
      onRefresh: _loadRideInfo,
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
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(10)),
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
                    ],
                  ),
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

          Card(
            color: isExpired ? Colors.red.shade50 : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    isExpired ? Icons.timer_off : Icons.pin,
                    size: 36,
                    color: isExpired ? Colors.red : Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isExpired ? 'OTP Expired' : 'Show this OTP to your driver',
                    style: TextStyle(
                      fontSize: 14,
                      color: isExpired ? Colors.red : Colors.grey.shade600,
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
                  const SizedBox(height: 12),
                  if (isExpired)
                    FilledButton.icon(
                      onPressed: _loadRideInfo,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Get New OTP'),
                    )
                  else
                    Text(
                      'Valid for $remainingMin min',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // SOS Button
          SizedBox(
            width: double.infinity,
            child: Card(
              color: Colors.red.shade50,
              child: InkWell(
                onTap: () => _showSOSDialog(),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.emergency, color: Colors.red, size: 24),
                      const SizedBox(width: 10),
                      Text('SOS - Emergency', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red.shade700)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (_passengers.isNotEmpty) ...[
            Text('Passengers (${_passengers.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: _passengers.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final p = entry.value;
                  final isBoarded = p['is_boarded'] == true;
                  final isDropped = p['is_dropped'] == true;
                  final firstName = p['first_name'] ?? '';
                  final lastName = p['last_name'] ?? '';
                  final name = '$firstName $lastName'.trim();
                  final cs = Theme.of(context).colorScheme;

                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isDropped ? Colors.green.withOpacity(0.15) : isBoarded ? Colors.orange.withOpacity(0.15) : cs.surfaceContainerHighest,
                          child: Icon(
                            isDropped ? Icons.check_circle : isBoarded ? Icons.person : Icons.person_outline,
                            color: isDropped ? Colors.green : isBoarded ? Colors.orange : cs.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        title: Text(name.isNotEmpty ? name : 'Unknown', style: const TextStyle(fontWeight: FontWeight.w500)),
                        trailing: Text(
                          isDropped ? 'Dropped' : isBoarded ? 'Boarded' : 'Pending',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDropped ? Colors.green : isBoarded ? Colors.orange : Colors.grey,
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
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('SEND SOS'),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text('Ride Verified!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 8),
            const Text('Your OTP has been verified. Trip is in progress.'),
            const SizedBox(height: 24),
            FilledButton(onPressed: _loadRideInfo, child: const Text('Refresh')),
          ],
        ),
      ),
    );
  }
}
