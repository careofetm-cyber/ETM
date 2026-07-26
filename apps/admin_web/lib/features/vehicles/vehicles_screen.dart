import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

final vehiclesPageProvider = StateProvider<int>((ref) => 1);
final vehiclesStatusProvider = StateProvider<String>((ref) => 'all');
final vehiclesSearchProvider = StateProvider<String>((ref) => '');

final vehiclesProvider = FutureProvider<List<Vehicle>>((ref) async {
  final api = await ref.watch(vehicleApiProvider.future);
  final page = ref.watch(vehiclesPageProvider);
  final status = ref.watch(vehiclesStatusProvider);
  return api.getVehicles(
    page: page,
    limit: 10,
    status: status == 'all' ? null : status,
  );
});

class VehiclesScreen extends ConsumerStatefulWidget {
  const VehiclesScreen({super.key});

  @override
  ConsumerState<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends ConsumerState<VehiclesScreen> {
  final _searchController = TextEditingController();
  final _plateController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _capacityController = TextEditingController();
  final _colorController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _plateController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _capacityController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Vehicles',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showAddVehicleDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Vehicle'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search vehicles...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      ref.read(vehiclesSearchProvider.notifier).state = value;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: ref.watch(vehiclesStatusProvider),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Status')),
                    DropdownMenuItem(value: 'active', child: Text('Active')),
                    DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                    DropdownMenuItem(value: 'maintenance', child: Text('Maintenance')),
                  ],
                  onChanged: (value) {
                    ref.read(vehiclesStatusProvider.notifier).state = value!;
                    ref.read(vehiclesPageProvider.notifier).state = 1;
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: vehiclesAsync.when(
                          data: (vehicles) {
                            final query = ref.read(vehiclesSearchProvider).toLowerCase();
                            final filtered = query.isEmpty
                                ? vehicles
                                : vehicles.where((v) =>
                                    v.plateNumber.toLowerCase().contains(query) ||
                                    v.brand.toLowerCase().contains(query) ||
                                    v.model.toLowerCase().contains(query)).toList();
                            if (filtered.isEmpty) {
                              return const Center(child: Text('No vehicles found'));
                            }
                            return _buildVehiclesTable(filtered);
                          },
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (error, stack) => Center(child: Text('Error: $error')),
                        ),
                      ),
                      _buildPagination(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehiclesTable(List<Vehicle> vehicles) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable2(
        columns: const [
          DataColumn2(label: Text('Vehicle'), size: ColumnSize.L),
          DataColumn2(label: Text('Plate Number')),
          DataColumn2(label: Text('Capacity')),
          DataColumn2(label: Text('Status')),
          DataColumn2(label: Text('Actions'), size: ColumnSize.S),
        ],
        rows: vehicles.map((vehicle) {
          final statusStr = vehicle.status?.name ?? 'active';
          return DataRow2(cells: [
            DataCell(Text('${vehicle.brand} ${vehicle.model}')),
            DataCell(Text(vehicle.plateNumber)),
            DataCell(Text('${vehicle.seatingCapacity} seats')),
            DataCell(_buildStatusChip(statusStr)),
            DataCell(Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showEditVehicleDialog(context, vehicle),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: AppColors.error),
                  onPressed: () => _showDeleteConfirmation(context, vehicle),
                ),
              ],
            )),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
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

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Page ${ref.watch(vehiclesPageProvider)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: ref.read(vehiclesPageProvider) > 1
                  ? () => ref.read(vehiclesPageProvider.notifier).state--
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => ref.read(vehiclesPageProvider.notifier).state++,
            ),
          ],
        ),
      ],
    );
  }

  void _showAddVehicleDialog(BuildContext context) {
    _plateController.clear();
    _brandController.clear();
    _modelController.clear();
    _yearController.clear();
    _capacityController.clear();
    _colorController.clear();

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Vehicle'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _plateController,
                  decoration: const InputDecoration(labelText: 'Plate Number *'),
                  validator: (v) => v == null || v.isEmpty ? 'Plate number is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(labelText: 'Brand *'),
                  validator: (v) => v == null || v.isEmpty ? 'Brand is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _modelController,
                  decoration: const InputDecoration(labelText: 'Model *'),
                  validator: (v) => v == null || v.isEmpty ? 'Model is required' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _yearController,
                        decoration: const InputDecoration(labelText: 'Year *'),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Year is required';
                          if (int.tryParse(v) == null) return 'Must be a number';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _capacityController,
                        decoration: const InputDecoration(labelText: 'Seating Capacity *'),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Capacity is required';
                          if (int.tryParse(v) == null) return 'Must be a number';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _colorController,
                  decoration: const InputDecoration(labelText: 'Color (optional)'),
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
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                final api = await ref.read(vehicleApiProvider.future);
                await api.createVehicle({
                  'plateNumber': _plateController.text,
                  'brand': _brandController.text,
                  'model': _modelController.text,
                  'year': int.tryParse(_yearController.text) ?? 2024,
                  'seatingCapacity': int.tryParse(_capacityController.text) ?? 20,
                  'color': _colorController.text.isEmpty ? null : _colorController.text,
                });
                if (context.mounted) Navigator.pop(context);
                ref.invalidate(vehiclesProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vehicle added successfully'), backgroundColor: AppColors.success),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add vehicle: $e'), backgroundColor: AppColors.error),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditVehicleDialog(BuildContext context, Vehicle vehicle) {
    _plateController.text = vehicle.plateNumber;
    _brandController.text = vehicle.brand;
    _modelController.text = vehicle.model;
    _yearController.text = vehicle.year.toString();
    _capacityController.text = vehicle.seatingCapacity.toString();
    _colorController.text = vehicle.color ?? '';

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Vehicle'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _plateController,
                  decoration: const InputDecoration(labelText: 'Plate Number *'),
                  validator: (v) => v == null || v.isEmpty ? 'Plate number is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(labelText: 'Brand *'),
                  validator: (v) => v == null || v.isEmpty ? 'Brand is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _modelController,
                  decoration: const InputDecoration(labelText: 'Model *'),
                  validator: (v) => v == null || v.isEmpty ? 'Model is required' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _yearController,
                        decoration: const InputDecoration(labelText: 'Year *'),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Year is required';
                          if (int.tryParse(v) == null) return 'Must be a number';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _capacityController,
                        decoration: const InputDecoration(labelText: 'Seating Capacity *'),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Capacity is required';
                          if (int.tryParse(v) == null) return 'Must be a number';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _colorController,
                  decoration: const InputDecoration(labelText: 'Color (optional)'),
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
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                final api = await ref.read(vehicleApiProvider.future);
                await api.updateVehicle(vehicle.id, {
                  'plateNumber': _plateController.text,
                  'brand': _brandController.text,
                  'model': _modelController.text,
                  'year': int.tryParse(_yearController.text) ?? vehicle.year,
                  'seatingCapacity': int.tryParse(_capacityController.text) ?? vehicle.seatingCapacity,
                  'color': _colorController.text.isEmpty ? null : _colorController.text,
                });
                if (context.mounted) Navigator.pop(context);
                ref.invalidate(vehiclesProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vehicle updated successfully'), backgroundColor: AppColors.success),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update vehicle: $e'), backgroundColor: AppColors.error),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: Text('Are you sure you want to delete ${vehicle.plateNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              try {
                final api = await ref.read(vehicleApiProvider.future);
                await api.deleteVehicle(vehicle.id);
                if (context.mounted) Navigator.pop(context);
                ref.invalidate(vehiclesProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vehicle deleted'), backgroundColor: AppColors.success),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete vehicle: $e'), backgroundColor: AppColors.error),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
