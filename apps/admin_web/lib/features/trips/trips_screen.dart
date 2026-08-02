import 'package:flutter/material.dart' hide Route;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';
import '../../shared/widgets/column_selector.dart';

final tripsPageProvider = StateProvider<int>((ref) => 1);
final tripsStatusProvider = StateProvider<String>((ref) => 'all');
final tripsDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

const _tripColumnOptions = [
  ColumnOption(key: 'route', label: 'Route'),
  ColumnOption(key: 'vehicle', label: 'Vehicle'),
  ColumnOption(key: 'driver', label: 'Driver'),
  ColumnOption(key: 'type', label: 'Type'),
  ColumnOption(key: 'status', label: 'Status'),
  ColumnOption(key: 'scheduledTime', label: 'Scheduled Time'),
  ColumnOption(key: 'passengers', label: 'Passengers'),
];

final tripsSelectedColumnsProvider = StateProvider<Set<String>>((ref) => {
      'route',
      'vehicle',
      'driver',
      'type',
      'scheduledTime',
      'status',
      'passengers',
    });

final tripsProvider = FutureProvider<List<Trip>>((ref) async {
  final api = await ref.watch(tripApiProvider.future);
  final page = ref.watch(tripsPageProvider);
  final status = ref.watch(tripsStatusProvider);
  final date = ref.watch(tripsDateProvider);
  return api.getTrips(
    page: page,
    limit: 20,
    status: status == 'all' ? null : status,
    date: date,
  );
});

final _routesListProvider = FutureProvider<List<Route>>((ref) async {
  final api = await ref.watch(routeApiProvider.future);
  return api.getRoutes(limit: 100);
});

final _vehiclesListProvider = FutureProvider<List<Vehicle>>((ref) async {
  final api = await ref.watch(vehicleApiProvider.future);
  return api.getVehicles(limit: 100);
});

final _driversListProvider = FutureProvider<List<Driver>>((ref) async {
  final api = await ref.watch(driverApiProvider.future);
  return api.getDrivers(limit: 100);
});

class TripsScreen extends ConsumerStatefulWidget {
  const TripsScreen({super.key});

  @override
  ConsumerState<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends ConsumerState<TripsScreen> {
  @override
  Widget build(BuildContext context) {
    final tripsAsync = ref.watch(tripsProvider);
    final selectedDate = ref.watch(tripsDateProvider);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Trips',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: isMobile ? 20 : 24,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showScheduleTripDialog(context),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Schedule Trip'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_today_rounded, size: 18),
                  label: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDDE2E8)),
                  ),
                  child: DropdownButton<String>(
                    value: ref.watch(tripsStatusProvider),
                    underline: const SizedBox(),
                    isDense: true,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All Status')),
                      DropdownMenuItem(value: 'scheduled', child: Text('Scheduled')),
                      DropdownMenuItem(value: 'inProgress', child: Text('In Progress')),
                      DropdownMenuItem(value: 'completed', child: Text('Completed')),
                      DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                    ],
                    onChanged: (value) {
                      ref.read(tripsStatusProvider.notifier).state = value!;
                      ref.read(tripsPageProvider.notifier).state = 1;
                    },
                  ),
                ),
                ColumnSelector(
                  tooltip: 'Select columns',
                  allColumns: _tripColumnOptions,
                  selectedKeys: ref.watch(tripsSelectedColumnsProvider),
                  onChanged: (keys) =>
                      ref.read(tripsSelectedColumnsProvider.notifier).state = keys,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE8ECF0), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: tripsAsync.when(
                    data: (trips) {
                      if (trips.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.trip_origin_outlined, size: 48, color: AppColors.textTertiary),
                              const SizedBox(height: 12),
                              Text(
                                'No trips found',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return _buildTripsTable(trips);
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(child: Text('Error: $error')),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripsTable(List<Trip> trips) {
    final selected = ref.watch(tripsSelectedColumnsProvider);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: const Color(0xFFF1F5F9),
          child: Row(
            children: [
              if (selected.contains('route')) const Expanded(flex: 2, child: Text('ROUTE', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('vehicle')) const Expanded(flex: 2, child: Text('VEHICLE', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('driver')) const Expanded(flex: 2, child: Text('DRIVER', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('type')) const Expanded(child: Text('TYPE', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('scheduledTime')) const Expanded(child: Text('TIME', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('status')) const Expanded(child: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('passengers')) const Expanded(child: Text('PAX', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              const SizedBox(width: 120, child: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: index % 2 == 0 ? Colors.white : const Color(0xFFF8FAFC),
                child: Row(
                  children: [
                    if (selected.contains('route')) Expanded(flex: 2, child: Text(trip.routeId, style: const TextStyle(fontWeight: FontWeight.w500))),
                    if (selected.contains('vehicle')) Expanded(flex: 2, child: Text(trip.vehicleId)),
                    if (selected.contains('driver')) Expanded(flex: 2, child: Text(trip.driverId)),
                    if (selected.contains('type')) Expanded(child: _buildTypeChip(trip.type)),
                    if (selected.contains('scheduledTime')) Expanded(
                      child: Text('${trip.scheduledTime.hour}:${trip.scheduledTime.minute.toString().padLeft(2, '0')}'),
                    ),
                    if (selected.contains('status')) Expanded(child: _buildStatusChip(trip.status)),
                    if (selected.contains('passengers')) Expanded(
                      child: Text('${trip.boardedPassengers ?? 0}/${trip.totalPassengers ?? 0}'),
                    ),
                    SizedBox(
                      width: 120,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.visibility_outlined, size: 18, color: AppColors.primary),
                            onPressed: () => _showTripDetail(context, trip),
                          ),
                          if (trip.status == TripStatus.scheduled)
                            IconButton(
                              icon: Icon(Icons.play_circle_outline_rounded, size: 18, color: AppColors.success),
                              onPressed: () async {
                                try {
                                  final api = await ref.read(tripApiProvider.future);
                                  await api.startTrip(trip.id);
                                  ref.invalidate(tripsProvider);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Trip started'), backgroundColor: AppColors.success),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to start trip: $e'), backgroundColor: AppColors.error),
                                    );
                                  }
                                }
                              },
                            ),
                          if (trip.status == TripStatus.inProgress)
                            IconButton(
                              icon: Icon(Icons.check_circle_outline_rounded, size: 18, color: AppColors.success),
                              onPressed: () async {
                                try {
                                  final api = await ref.read(tripApiProvider.future);
                                  await api.completeTrip(trip.id);
                                  ref.invalidate(tripsProvider);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Trip completed'), backgroundColor: AppColors.success),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to complete trip: $e'), backgroundColor: AppColors.error),
                                    );
                                  }
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTypeChip(TripType type) {
    final isPickup = type == TripType.pickup;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(isPickup ? Icons.login_rounded : Icons.logout_rounded, size: 14, color: isPickup ? AppColors.primary : AppColors.secondary),
        const SizedBox(width: 4),
        Text(isPickup ? 'Pickup' : 'Dropoff', style: TextStyle(color: isPickup ? AppColors.primary : AppColors.secondary, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatusChip(TripStatus status) {
    Color color;
    String label;

    switch (status) {
      case TripStatus.scheduled:
        color = AppColors.info;
        label = 'Scheduled';
        break;
      case TripStatus.inProgress:
        color = AppColors.success;
        label = 'In Progress';
        break;
      case TripStatus.completed:
        color = AppColors.secondary;
        label = 'Completed';
        break;
      case TripStatus.cancelled:
        color = AppColors.error;
        label = 'Cancelled';
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(status == TripStatus.scheduled ? Icons.schedule_outlined : status == TripStatus.inProgress ? Icons.play_circle_outline_rounded : status == TripStatus.completed ? Icons.check_circle_outline_rounded : Icons.cancel_outlined, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ref.read(tripsDateProvider),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      ref.read(tripsDateProvider.notifier).state = picked;
      ref.read(tripsPageProvider.notifier).state = 1;
    }
  }

  void _showScheduleTripDialog(BuildContext context) {
    String? selectedRouteId;
    String? selectedVehicleId;
    String? selectedDriverId;
    TripType selectedType = TripType.pickup;
    DateTime scheduledTime = DateTime.now().add(const Duration(hours: 1));
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Schedule Trip'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      final routesAsync = ref.watch(_routesListProvider);
                      return routesAsync.when(
                        data: (routes) => DropdownButtonFormField<String>(
                          value: selectedRouteId,
                          decoration: const InputDecoration(labelText: 'Route *'),
                          items: routes.map<DropdownMenuItem<String>>((Route r) => DropdownMenuItem<String>(
                            value: r.id,
                            child: Text('${r.name} (${r.totalDistance?.toStringAsFixed(1) ?? '0.0'} km)'),
                          )).toList(),
                          onChanged: (v) => setDialogState(() => selectedRouteId = v),
                          validator: (v) => v == null ? 'Route is required' : null,
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) => Text('Error loading routes: $e'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Consumer(
                    builder: (context, ref, _) {
                      final vehiclesAsync = ref.watch(_vehiclesListProvider);
                      return vehiclesAsync.when(
                        data: (vehicles) => DropdownButtonFormField<String>(
                          value: selectedVehicleId,
                          decoration: const InputDecoration(labelText: 'Vehicle *'),
                          items: vehicles.map<DropdownMenuItem<String>>((Vehicle v) => DropdownMenuItem<String>(
                            value: v.id,
                            child: Text('${v.brand} ${v.model} (${v.plateNumber})'),
                          )).toList(),
                          onChanged: (v) => setDialogState(() => selectedVehicleId = v),
                          validator: (v) => v == null ? 'Vehicle is required' : null,
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) => Text('Error loading vehicles: $e'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Consumer(
                    builder: (context, ref, _) {
                      final driversAsync = ref.watch(_driversListProvider);
                      return driversAsync.when(
                        data: (drivers) => DropdownButtonFormField<String>(
                          value: selectedDriverId,
                          decoration: const InputDecoration(labelText: 'Driver *'),
                          items: drivers.map<DropdownMenuItem<String>>((Driver d) => DropdownMenuItem<String>(
                            value: d.id,
                            child: Text('${d.userId} ${d.licenseNumber != null ? '(${d.licenseNumber})' : ''}'),
                          )).toList(),
                          onChanged: (v) => setDialogState(() => selectedDriverId = v),
                          validator: (v) => v == null ? 'Driver is required' : null,
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) => Text('Error loading drivers: $e'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TripType>(
                    value: selectedType,
                    decoration: const InputDecoration(labelText: 'Trip Type'),
                    items: const [
                      DropdownMenuItem(value: TripType.pickup, child: Text('Pickup')),
                      DropdownMenuItem(value: TripType.dropoff, child: Text('Dropoff')),
                    ],
                    onChanged: (v) => setDialogState(() => selectedType = v!),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Scheduled Time'),
                    subtitle: Text(
                      '${scheduledTime.day}/${scheduledTime.month}/${scheduledTime.year} '
                      '${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: scheduledTime,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(scheduledTime),
                        );
                        setDialogState(() {
                          scheduledTime = DateTime(
                            date.year, date.month, date.day,
                            time?.hour ?? scheduledTime.hour,
                            time?.minute ?? scheduledTime.minute,
                          );
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: notesController,
                    decoration: const InputDecoration(labelText: 'Notes (optional)'),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: (selectedRouteId == null || selectedVehicleId == null || selectedDriverId == null)
                  ? null
                  : () async {
                      try {
                        final api = await ref.read(tripApiProvider.future);
                        await api.createTrip({
                          'routeId': selectedRouteId,
                          'vehicleId': selectedVehicleId,
                          'driverId': selectedDriverId,
                          'type': selectedType.name,
                          'scheduledTime': scheduledTime.toIso8601String(),
                          'notes': notesController.text.isEmpty ? null : notesController.text,
                        });
                        if (context.mounted) Navigator.pop(context);
                        ref.invalidate(tripsProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Trip scheduled successfully'), backgroundColor: AppColors.success),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to schedule trip: $e'), backgroundColor: AppColors.error),
                          );
                        }
                      }
                    },
              child: const Text('Schedule'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTripDetail(BuildContext context, Trip trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Trip Details'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('Route ID', trip.routeId),
              _detailRow('Vehicle ID', trip.vehicleId),
              _detailRow('Driver ID', trip.driverId),
              _detailRow('Type', trip.type == TripType.pickup ? 'Pickup' : 'Dropoff'),
              _detailRow('Status', trip.statusDisplay),
              _detailRow('Scheduled', '${trip.scheduledTime.day}/${trip.scheduledTime.month}/${trip.scheduledTime.year} '
                  '${trip.scheduledTime.hour}:${trip.scheduledTime.minute.toString().padLeft(2, '0')}'),
              if (trip.actualStartTime != null)
                _detailRow('Started', '${trip.actualStartTime!.day}/${trip.actualStartTime!.month}/${trip.actualStartTime!.year} '
                    '${trip.actualStartTime!.hour}:${trip.actualStartTime!.minute.toString().padLeft(2, '0')}'),
              if (trip.actualEndTime != null)
                _detailRow('Ended', '${trip.actualEndTime!.day}/${trip.actualEndTime!.month}/${trip.actualEndTime!.year} '
                    '${trip.actualEndTime!.hour}:${trip.actualEndTime!.minute.toString().padLeft(2, '0')}'),
              _detailRow('Passengers', '${trip.boardedPassengers ?? 0}/${trip.totalPassengers ?? 0}'),
              if (trip.totalDistance != null)
                _detailRow('Distance', '${trip.totalDistance!.toStringAsFixed(1)} km'),
              if (trip.notes != null && trip.notes!.isNotEmpty)
                _detailRow('Notes', trip.notes!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
