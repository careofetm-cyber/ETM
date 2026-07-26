import 'package:flutter/material.dart' hide Route;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

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

final _tripsProvider = FutureProvider<List<Trip>>((ref) async {
  final api = await ref.watch(tripApiProvider.future);
  return api.getTrips(limit: 50);
});

final _employeesListProvider = FutureProvider<List<Employee>>((ref) async {
  final api = await ref.watch(employeeApiProvider.future);
  return api.getEmployees(limit: 100);
});

class TransportManagerScreen extends ConsumerStatefulWidget {
  const TransportManagerScreen({super.key});

  @override
  ConsumerState<TransportManagerScreen> createState() => _TransportManagerScreenState();
}

class _TransportManagerScreenState extends ConsumerState<TransportManagerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Transport Manager',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Trip Scheduling', icon: Icon(Icons.schedule)),
                Tab(text: 'Cab Assignment', icon: Icon(Icons.directions_car)),
                Tab(text: 'Active Trips', icon: Icon(Icons.play_circle_outline)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTripSchedulingTab(),
                  _buildCabAssignmentTab(),
                  _buildActiveTripsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripSchedulingTab() {
    final tripsAsync = ref.watch(_tripsProvider);

    return Column(
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => _showScheduleTripDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Schedule Trip'),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () => _showAssignCabDialog(context),
              icon: const Icon(Icons.directions_car),
              label: const Text('Assign Cab'),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_tripsProvider),
              tooltip: 'Refresh',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: tripsAsync.when(
                data: (trips) {
                  final filtered = trips.where((t) =>
                      t.status == TripStatus.scheduled ||
                      t.status == TripStatus.inProgress).toList();
                  if (filtered.isEmpty) {
                    return const Center(child: Text('No upcoming or in-progress trips'));
                  }
                  return DataTable2(
                    columns: const [
                      DataColumn2(label: Text('Route'), size: ColumnSize.L),
                      DataColumn2(label: Text('Vehicle')),
                      DataColumn2(label: Text('Driver')),
                      DataColumn2(label: Text('Type')),
                      DataColumn2(label: Text('Time')),
                      DataColumn2(label: Text('Status')),
                      DataColumn2(label: Text('Actions'), size: ColumnSize.S),
                    ],
                    rows: filtered.map((trip) {
                      return DataRow2(cells: [
                        DataCell(Text(trip.routeId)),
                        DataCell(Text(trip.vehicleId)),
                        DataCell(Text(trip.driverId)),
                        DataCell(_buildTypeChip(trip.type)),
                        DataCell(Text(
                          '${trip.scheduledTime.hour}:${trip.scheduledTime.minute.toString().padLeft(2, '0')}',
                        )),
                        DataCell(_buildStatusChip(trip.status)),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility, size: 20),
                              onPressed: () => _showTripDetail(context, trip),
                            ),
                            if (trip.status == TripStatus.scheduled)
                              IconButton(
                                icon: const Icon(Icons.play_arrow, size: 20),
                                onPressed: () async {
                                  try {
                                    final api = await ref.read(tripApiProvider.future);
                                    await api.startTrip(trip.id);
                                    ref.invalidate(_tripsProvider);
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
                          ],
                        )),
                      ]);
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCabAssignmentTab() {
    final vehiclesAsync = ref.watch(_vehiclesListProvider);

    return Column(
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => _showAssignCabDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Assign Cab'),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_vehiclesListProvider),
              tooltip: 'Refresh',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: vehiclesAsync.when(
                data: (vehicles) {
                  if (vehicles.isEmpty) {
                    return const Center(child: Text('No vehicles found'));
                  }
                  return DataTable2(
                    columns: const [
                      DataColumn2(label: Text('Vehicle'), size: ColumnSize.L),
                      DataColumn2(label: Text('Plate Number')),
                      DataColumn2(label: Text('Capacity')),
                      DataColumn2(label: Text('Status')),
                      DataColumn2(label: Text('Assigned Driver')),
                      DataColumn2(label: Text('Today\'s Trips')),
                      DataColumn2(label: Text('Actions'), size: ColumnSize.S),
                    ],
                    rows: vehicles.map((vehicle) {
                      final statusStr = vehicle.status?.name ?? 'active';
                      return DataRow2(cells: [
                        DataCell(Text('${vehicle.brand} ${vehicle.model}')),
                        DataCell(Text(vehicle.plateNumber)),
                        DataCell(Text('${vehicle.seatingCapacity} seats')),
                        DataCell(_buildStatusChipVehicle(statusStr)),
                        DataCell(Text('Unassigned')),
                        DataCell(Text('0')),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => _showAssignCabDialog(context, vehicleId: vehicle.id),
                              tooltip: 'Assign Driver',
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveTripsTab() {
    final tripsAsync = ref.watch(_tripsProvider);

    return Column(
      children: [
        Row(
          children: [
            const Text('Real-time view of in-progress trips', style: TextStyle(color: AppColors.textSecondary)),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(_tripsProvider),
              tooltip: 'Refresh',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: tripsAsync.when(
                data: (trips) {
                  final active = trips.where((t) => t.status == TripStatus.inProgress).toList();
                  if (active.isEmpty) {
                    return const Center(child: Text('No active trips'));
                  }
                  return ListView.builder(
                    itemCount: active.length,
                    itemBuilder: (context, index) {
                      final trip = active[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.directions_bus, color: AppColors.success),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Trip ${trip.id.substring(0, 8)}...',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const Spacer(),
                                  _buildStatusChip(trip.status),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _detailRow('Vehicle', trip.vehicleId),
                              _detailRow('Driver', trip.driverId),
                              _detailRow('Route', trip.routeId),
                              _detailRow('Type', trip.type == TripType.pickup ? 'Pickup' : 'Dropoff'),
                              _detailRow('Passengers', '${trip.boardedPassengers ?? 0}/${trip.totalPassengers ?? 0}'),
                              _detailRow('OTP Status', 'Pending Verification'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeChip(TripType type) {
    return Chip(
      label: Text(type == TripType.pickup ? 'Pickup' : 'Dropoff'),
      backgroundColor: type == TripType.pickup
          ? AppColors.primary.withOpacity(0.1)
          : AppColors.secondary.withOpacity(0.1),
      padding: EdgeInsets.zero,
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

    return Chip(
      label: Text(label, style: TextStyle(color: color)),
      backgroundColor: color.withOpacity(0.1),
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildStatusChipVehicle(String status) {
    Color color;
    String label;

    switch (status) {
      case 'active':
        color = AppColors.success;
        label = 'Active';
        break;
      case 'inactive':
        color = AppColors.textSecondary;
        label = 'Inactive';
        break;
      case 'maintenance':
        color = AppColors.warning;
        label = 'Maintenance';
        break;
      default:
        color = AppColors.textSecondary;
        label = status;
    }

    return Chip(
      label: Text(label, style: TextStyle(color: color)),
      backgroundColor: color.withOpacity(0.1),
      padding: EdgeInsets.zero,
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
                            child: Text('${r.name} (${r.totalDistance.toStringAsFixed(1)} km)'),
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
                        ref.invalidate(_tripsProvider);
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

  void _showAssignCabDialog(BuildContext context, {String? vehicleId}) {
    String? selectedVehicle = vehicleId;
    String? selectedDriver;
    String? selectedRoute;
    final Set<String> selectedEmployees = {};

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Assign Cab'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      final vehiclesAsync = ref.watch(_vehiclesListProvider);
                      return vehiclesAsync.when(
                        data: (vehicles) => DropdownButtonFormField<String>(
                          value: selectedVehicle,
                          decoration: const InputDecoration(labelText: 'Vehicle *'),
                          items: vehicles.map<DropdownMenuItem<String>>((Vehicle v) => DropdownMenuItem<String>(
                            value: v.id,
                            child: Text('${v.brand} ${v.model} (${v.plateNumber})'),
                          )).toList(),
                          onChanged: (v) => setDialogState(() => selectedVehicle = v),
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
                          value: selectedDriver,
                          decoration: const InputDecoration(labelText: 'Driver *'),
                          items: drivers.map<DropdownMenuItem<String>>((Driver d) => DropdownMenuItem<String>(
                            value: d.id,
                            child: Text('${d.userId} ${d.licenseNumber != null ? '(${d.licenseNumber})' : ''}'),
                          )).toList(),
                          onChanged: (v) => setDialogState(() => selectedDriver = v),
                          validator: (v) => v == null ? 'Driver is required' : null,
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) => Text('Error loading drivers: $e'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Consumer(
                    builder: (context, ref, _) {
                      final routesAsync = ref.watch(_routesListProvider);
                      return routesAsync.when(
                        data: (routes) => DropdownButtonFormField<String>(
                          value: selectedRoute,
                          decoration: const InputDecoration(labelText: 'Route *'),
                          items: routes.map<DropdownMenuItem<String>>((Route r) => DropdownMenuItem<String>(
                            value: r.id,
                            child: Text('${r.name} (${r.totalDistance.toStringAsFixed(1)} km)'),
                          )).toList(),
                          onChanged: (v) => setDialogState(() => selectedRoute = v),
                          validator: (v) => v == null ? 'Route is required' : null,
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) => Text('Error loading routes: $e'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Assign Employees', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 8),
                  Consumer(
                    builder: (context, ref, _) {
                      final employeesAsync = ref.watch(_employeesListProvider);
                      return employeesAsync.when(
                        data: (employees) => Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: employees.length,
                            itemBuilder: (context, index) {
                              final emp = employees[index];
                              return CheckboxListTile(
                                value: selectedEmployees.contains(emp.id),
                                title: Text(emp.email ?? emp.id),
                                subtitle: Text(emp.department ?? ''),
                                onChanged: (checked) {
                                  setDialogState(() {
                                    if (checked == true) {
                                      selectedEmployees.add(emp.id);
                                    } else {
                                      selectedEmployees.remove(emp.id);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (e, _) => Text('Error loading employees: $e'),
                      );
                    },
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
              onPressed: (selectedVehicle == null || selectedDriver == null || selectedRoute == null)
                  ? null
                  : () async {
                      try {
                        final api = await ref.read(tripApiProvider.future);
                        await api.createTrip({
                          'routeId': selectedRoute,
                          'vehicleId': selectedVehicle,
                          'driverId': selectedDriver,
                          'type': 'pickup',
                          'scheduledTime': DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
                          'employeeIds': selectedEmployees.toList(),
                        });
                        if (context.mounted) Navigator.pop(context);
                        ref.invalidate(_tripsProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cab assigned successfully'), backgroundColor: AppColors.success),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to assign cab: $e'), backgroundColor: AppColors.error),
                          );
                        }
                      }
                    },
              child: const Text('Assign'),
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
              _detailRow('Passengers', '${trip.boardedPassengers ?? 0}/${trip.totalPassengers ?? 0}'),
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
}
