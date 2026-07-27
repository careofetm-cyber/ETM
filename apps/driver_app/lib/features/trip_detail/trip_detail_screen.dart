import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../providers.dart';

class TripDetailScreen extends ConsumerStatefulWidget {
  final String tripId;
  const TripDetailScreen({super.key, required this.tripId});

  @override
  ConsumerState<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen> {
  Map<String, dynamic>? _trip;
  List<dynamic> _passengers = [];
  final _otpController = TextEditingController();
  bool _isLoading = true;
  bool _isVerifyingOtp = false;
  bool _isCompleting = false;
  String? _error;
  String? _otpError;

  @override
  void initState() {
    super.initState();
    _loadTrip();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _loadTrip() async {
    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      final tripResp = await dio.get('/trips/${widget.tripId}');
      _trip = tripResp.data;

      final passResp = await dio.get('/trips/${widget.tripId}/passengers');
      _passengers = passResp.data['data'] ?? [];
    } on DioException catch (e) {
      setState(() => _error = e.response?.data?['error'] ?? 'Failed to load trip');
    } catch (e) {
      setState(() => _error = 'Network error');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      setState(() => _otpError = 'Enter 6-digit OTP');
      return;
    }
    setState(() { _isVerifyingOtp = true; _otpError = null; });
    try {
      final dio = ref.read(dioProvider);
      await dio.post('/otp/verify', data: {
        'tripId': widget.tripId,
        'otp': otp,
      });
      await _loadTrip();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP verified! Trip started'), backgroundColor: Colors.green),
        );
      }
    } on DioException catch (e) {
      setState(() => _otpError = e.response?.data?['error'] ?? 'Verification failed');
    } catch (e) {
      setState(() => _otpError = 'Network error');
    }
    setState(() => _isVerifyingOtp = false);
  }

  Future<void> _completeTrip() async {
    setState(() => _isCompleting = true);
    try {
      final dio = ref.read(dioProvider);
      await dio.post('/trips/${widget.tripId}/complete', data: {});
      await _loadTrip();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip completed'), backgroundColor: Colors.green),
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.response?.data?['error'] ?? 'Failed to complete trip'), backgroundColor: Theme.of(context).colorScheme.error));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error'), backgroundColor: Colors.red));
      }
    }
    setState(() => _isCompleting = false);
  }

  Future<void> _boardPassenger(String employeeId) async {
    try {
      final dio = ref.read(dioProvider);
      await dio.post('/trips/${widget.tripId}/passengers/$employeeId/board');
      await _loadTrip();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to board passenger'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _dropPassenger(String employeeId) async {
    try {
      final dio = ref.read(dioProvider);
      await dio.post('/trips/${widget.tripId}/passengers/$employeeId/drop');
      await _loadTrip();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to drop passenger'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final status = _trip?['status'] ?? 'scheduled';
    final routeName = _trip?['routeName'] ?? _trip?['route_id'] ?? 'Unknown Route';
    final vehiclePlate = _trip?['plate_number'] ?? _trip?['vehiclePlate'] ?? '';
    final scheduledTime = (_trip?['scheduled_time'] ?? '').toString();
    final timePart = scheduledTime.length >= 16 ? scheduledTime.substring(11, 16) : '';
    final distance = _trip?['total_distance'];

    final statusLabels = {
      'scheduled': 'Scheduled',
      'in_progress': 'In Progress',
      'inProgress': 'In Progress',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
    };

    final width = MediaQuery.of(context).size.width;
    final padding = width < 600 ? 16.0 : width < 900 ? 24.0 : 32.0;

    final statusColors = {
      'scheduled': cs.primary,
      'in_progress': Colors.orange,
      'inProgress': Colors.orange,
      'completed': Colors.green,
      'cancelled': Colors.red,
    };

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Trip #${widget.tripId.substring(0, widget.tripId.length > 8 ? 8 : widget.tripId.length)}'),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: (statusColors[status] ?? cs.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 8, color: statusColors[status] ?? cs.primary),
                const SizedBox(width: 6),
                Text(statusLabels[status] ?? status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColors[status] ?? cs.primary)),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
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
                        FilledButton(onPressed: _loadTrip, child: const Text('Retry')),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadTrip,
                    child: ListView(
                      padding: EdgeInsets.all(padding),
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
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [cs.primary, cs.primary.withOpacity(0.8)],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.directions_bus, color: Colors.white, size: 24),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(routeName, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                                        if (vehiclePlate.isNotEmpty)
                                          Text('Vehicle: $vehiclePlate', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _TripStat(icon: Icons.access_time, label: 'Time', value: timePart),
                                  _TripStat(icon: Icons.people_outlined, label: 'Passengers', value: '${_passengers.length}'),
                                  _TripStat(icon: Icons.straighten, label: 'Distance', value: distance != null ? '${double.tryParse(distance.toString())?.toStringAsFixed(1) ?? distance} km' : 'N/A'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (status == 'scheduled') ...[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: cs.primaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.lock_outline, size: 32, color: cs.onPrimaryContainer),
                                ),
                                const SizedBox(height: 12),
                                Text('Enter OTP to Start Trip', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text('Ask the passenger for their OTP', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _otpController,
                                  decoration: InputDecoration(
                                    hintText: '• • • • • •',
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.pin_outlined),
                                    errorText: _otpError,
                                    filled: true,
                                    fillColor: cs.surfaceContainerHighest.withOpacity(0.3),
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
                                  maxLength: 6,
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: FilledButton.icon(
                                    onPressed: _isVerifyingOtp ? null : _verifyOtp,
                                    icon: _isVerifyingOtp
                                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                        : const Icon(Icons.check_circle_outline),
                                    label: const Text('Verify OTP & Start Trip'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      if (status == 'in_progress' || status == 'inProgress') ...[
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton.icon(
                            onPressed: _isCompleting ? null : _completeTrip,
                            icon: _isCompleting
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Icon(Icons.check_circle_outline),
                            label: const Text('Complete Trip'),
                            style: FilledButton.styleFrom(backgroundColor: Colors.green.shade600),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      if (status == 'completed') ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, color: Colors.green.shade600),
                              const SizedBox(width: 8),
                              Text('Trip Completed', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      Row(
                        children: [
                          Icon(Icons.people_outlined, color: cs.primary, size: 20),
                          const SizedBox(width: 8),
                          Text('Passengers (${_passengers.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_passengers.isEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.people_outline, size: 36, color: cs.onSurfaceVariant.withOpacity(0.4)),
                                  const SizedBox(height: 8),
                                  Text('No passengers assigned', style: TextStyle(color: cs.onSurfaceVariant)),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
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
                              final employeeId = p['employee_id'] ?? '';

                              return Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    leading: CircleAvatar(
                                      backgroundColor: isDropped ? Colors.green.shade50 : isBoarded ? Colors.orange.shade50 : cs.surfaceContainerHighest,
                                      child: Icon(
                                        isDropped ? Icons.check_circle : isBoarded ? Icons.person : Icons.person_outline,
                                        color: isDropped ? Colors.green.shade600 : isBoarded ? Colors.orange.shade600 : cs.onSurfaceVariant,
                                        size: 20,
                                      ),
                                    ),
                                    title: Text(name.isNotEmpty ? name : 'Unknown', style: const TextStyle(fontWeight: FontWeight.w600)),
                                    subtitle: Text(
                                      isDropped ? 'Dropped' : isBoarded ? 'Boarded' : 'Pending',
                                      style: TextStyle(
                                        color: isDropped ? Colors.green.shade600 : isBoarded ? Colors.orange.shade600 : cs.onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: (status == 'in_progress' || status == 'inProgress')
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (!isBoarded)
                                                FilledButton.tonalIcon(
                                                  onPressed: () => _boardPassenger(employeeId),
                                                  icon: const Icon(Icons.login, size: 16),
                                                  label: const Text('Board'),
                                                ),
                                              if (isBoarded && !isDropped)
                                                FilledButton.tonalIcon(
                                                  onPressed: () => _dropPassenger(employeeId),
                                                  icon: const Icon(Icons.logout, size: 16),
                                                  label: const Text('Drop'),
                                                  style: FilledButton.styleFrom(backgroundColor: Colors.green.shade50),
                                                ),
                                            ],
                                          )
                                        : null,
                                  ),
                                  if (idx < _passengers.length - 1) const Divider(height: 1, indent: 56),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
    );
  }
}

class _TripStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _TripStat({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: cs.onPrimaryContainer, size: 20),
        ),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
      ],
    );
  }
}
