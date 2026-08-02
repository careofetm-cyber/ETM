import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';
import '../../shared/widgets/column_selector.dart';

final vehiclesPageProvider = StateProvider<int>((ref) => 1);
final vehiclesStatusProvider = StateProvider<String>((ref) => 'all');
final vehiclesSearchProvider = StateProvider<String>((ref) => '');

const _vehicleColumnOptions = [
  ColumnOption(key: 'plateNumber', label: 'Plate Number'),
  ColumnOption(key: 'model', label: 'Model'),
  ColumnOption(key: 'brand', label: 'Brand'),
  ColumnOption(key: 'year', label: 'Year'),
  ColumnOption(key: 'seatingCapacity', label: 'Seating Capacity'),
  ColumnOption(key: 'color', label: 'Color'),
  ColumnOption(key: 'status', label: 'Status'),
  ColumnOption(key: 'driver', label: 'Driver'),
];

final vehiclesSelectedColumnsProvider = StateProvider<Set<String>>((ref) => {
      'plateNumber',
      'model',
      'brand',
      'status',
    });

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
                  'Vehicles',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: isMobile ? 20 : 24,
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
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: isMobile ? double.infinity : 320,
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
                ColumnSelector(
                  tooltip: 'Select columns',
                  allColumns: _vehicleColumnOptions,
                  selectedKeys: ref.watch(vehiclesSelectedColumnsProvider),
                  onChanged: (keys) =>
                      ref.read(vehiclesSelectedColumnsProvider.notifier).state = keys,
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
                            print('[VehiclesScreen] data callback: ${vehicles.length} vehicles');
                            for (final v in vehicles) {
                              print('[VehiclesScreen]   - ${v.plateNumber} ${v.brand} ${v.model} status=${v.status}');
                            }
                            final query = ref.read(vehiclesSearchProvider).toLowerCase();
                            print('[VehiclesScreen] query="$query"');
                            final filtered = query.isEmpty
                                ? vehicles
                                : vehicles.where((v) =>
                                    v.plateNumber.toLowerCase().contains(query) ||
                                    v.brand.toLowerCase().contains(query) ||
                                    v.model.toLowerCase().contains(query)).toList();
                            print('[VehiclesScreen] filtered: ${filtered.length}');
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
    final selected = ref.watch(vehiclesSelectedColumnsProvider);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: const Color(0xFFF1F5F9),
          child: Row(
            children: [
              if (selected.contains('brand')) const Expanded(flex: 2, child: Text('BRAND', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('model')) const Expanded(flex: 2, child: Text('MODEL', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('plateNumber')) const Expanded(flex: 2, child: Text('PLATE NUMBER', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('year')) const Expanded(child: Text('YEAR', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('seatingCapacity')) const Expanded(child: Text('CAPACITY', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('status')) const Expanded(child: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('driver')) const Expanded(flex: 2, child: Text('DRIVER', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              const SizedBox(width: 100, child: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              final statusStr = vehicle.status?.name ?? 'active';
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: index % 2 == 0 ? Colors.white : const Color(0xFFF8FAFC),
                child: Row(
                  children: [
                    if (selected.contains('brand')) Expanded(flex: 2, child: Text(vehicle.brand, style: const TextStyle(fontWeight: FontWeight.w500))),
                    if (selected.contains('model')) Expanded(flex: 2, child: Text(vehicle.model)),
                    if (selected.contains('plateNumber')) Expanded(flex: 2, child: Text(vehicle.plateNumber)),
                    if (selected.contains('year')) Expanded(child: Text(vehicle.year.toString())),
                    if (selected.contains('seatingCapacity')) Expanded(child: Text('${vehicle.seatingCapacity}')),
                    if (selected.contains('status')) Expanded(child: _buildStatusChip(statusStr)),
                    if (selected.contains('driver')) Expanded(flex: 2, child: Text(vehicle.driverId ?? '-')),
                    SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                            onPressed: () => _showEditVehicleDialog(context, vehicle),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                            onPressed: () => _showDeleteConfirmation(context, vehicle),
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
