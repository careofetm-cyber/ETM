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
      backgroundColor: const Color(0xFFF0F4F8),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Vehicles',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showAddVehicleDialog(context),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Vehicle'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search vehicles...',
                      prefixIcon: Icon(Icons.search_rounded, size: 20),
                    ),
                    onChanged: (value) {
                      ref.read(vehiclesSearchProvider.notifier).state = value;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDDE2E8)),
                  ),
                  child: DropdownButton<String>(
                    value: ref.watch(vehiclesStatusProvider),
                    underline: const SizedBox(),
                    isDense: true,
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
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.directions_bus_outlined, size: 48, color: AppColors.textTertiary),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No vehicles found',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
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
        columns: [
          DataColumn2(label: Row(children: [Icon(Icons.directions_bus_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('VEHICLE')]), size: ColumnSize.L),
          DataColumn2(label: Row(children: [Icon(Icons.pin_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('PLATE NUMBER')])),
          DataColumn2(label: Row(children: [Icon(Icons.people_outline, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('CAPACITY')])),
          DataColumn2(label: Row(children: [Icon(Icons.flag_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('STATUS')])),
          DataColumn2(label: Row(children: [Icon(Icons.settings_outlined, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), const Text('ACTIONS')]), size: ColumnSize.S),
        ],
        rows: vehicles.asMap().entries.map((entry) {
          final index = entry.key;
          final vehicle = entry.value;
          final statusStr = vehicle.status?.name ?? 'active';
          return DataRow2(
            color: index % 2 == 0
                ? WidgetStateProperty.all(Colors.white)
                : WidgetStateProperty.all(const Color(0xFFF8FAFC)),
            cells: [
              DataCell(Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(Icons.directions_bus_rounded, size: 16, color: AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${vehicle.brand} ${vehicle.model}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              )),
              DataCell(Text(vehicle.plateNumber)),
              DataCell(Text('${vehicle.seatingCapacity} seats')),
              DataCell(_buildStatusChip(statusStr)),
              DataCell(Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: 'View',
                    child: IconButton(
                      icon: Icon(Icons.visibility_outlined, size: 18, color: AppColors.info),
                      onPressed: () {},
                    ),
                  ),
                  Tooltip(
                    message: 'Edit',
                    child: IconButton(
                      icon: Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                      onPressed: () => _showEditVehicleDialog(context, vehicle),
                    ),
                  ),
                  Tooltip(
                    message: 'Delete',
                    child: IconButton(
                      icon: Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                      onPressed: () => _showDeleteConfirmation(context, vehicle),
                    ),
                  ),
                ],
              )),
            ],
          );
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(status == 'active' ? Icons.check_circle : status == 'maintenance' ? Icons.build_circle_outlined : Icons.cancel_outlined, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE8ECF0), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Page ${ref.watch(vehiclesPageProvider)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 20),
                color: AppColors.textSecondary,
                onPressed: ref.read(vehiclesPageProvider) > 1
                    ? () => ref.read(vehiclesPageProvider.notifier).state--
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 20),
                color: AppColors.textSecondary,
                onPressed: () => ref.read(vehiclesPageProvider.notifier).state++,
              ),
            ],
          ),
        ],
      ),
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
