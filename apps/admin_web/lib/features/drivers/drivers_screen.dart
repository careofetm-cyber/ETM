import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

final driversPageProvider = StateProvider<int>((ref) => 1);
final driversSearchProvider = StateProvider<String>((ref) => '');

final driversProvider = FutureProvider<List<Driver>>((ref) async {
  final api = await ref.watch(driverApiProvider.future);
  final page = ref.watch(driversPageProvider);
  final search = ref.watch(driversSearchProvider);
  return api.getDrivers(
    page: page,
    limit: 20,
    search: search.isEmpty ? null : search,
  );
});

class DriversScreen extends ConsumerStatefulWidget {
  const DriversScreen({super.key});

  @override
  ConsumerState<DriversScreen> createState() => _DriversScreenState();
}

class _DriversScreenState extends ConsumerState<DriversScreen> {
  final _searchController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final driversAsync = ref.watch(driversProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Drivers',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showAddDriverDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Driver'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search drivers...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  ref.read(driversSearchProvider.notifier).state = value;
                  ref.read(driversPageProvider.notifier).state = 1;
                },
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: driversAsync.when(
                    data: (drivers) {
                      if (drivers.isEmpty) {
                        return const Center(child: Text('No drivers found'));
                      }
                      return _buildDriversTable(drivers);
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

  Widget _buildDriversTable(List<Driver> drivers) {
    return DataTable2(
      columns: const [
        DataColumn2(label: Text('Driver'), size: ColumnSize.L),
        DataColumn2(label: Text('License')),
        DataColumn2(label: Text('Expiry')),
        DataColumn2(label: Text('Rating')),
        DataColumn2(label: Text('Total Trips')),
        DataColumn2(label: Text('Available')),
        DataColumn2(label: Text('Actions'), size: ColumnSize.S),
      ],
      rows: drivers.map((driver) {
        return DataRow2(cells: [
          DataCell(Text(driver.displayName)),
          DataCell(Text(driver.licenseNumber ?? '-')),
          DataCell(Text(driver.licenseExpiry != null
              ? '${driver.licenseExpiry!.day}/${driver.licenseExpiry!.month}/${driver.licenseExpiry!.year}'
              : '-')),
          DataCell(Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(driver.rating?.toStringAsFixed(1) ?? '-'),
            ],
          )),
          DataCell(Text(driver.totalTrips?.toString() ?? '0')),
          DataCell(Switch(
            value: driver.isAvailable ?? false,
            onChanged: (value) async {
              final api = await ref.read(driverApiProvider.future);
              await api.updateAvailability(driver.id, value);
              ref.invalidate(driversProvider);
            },
          )),
          DataCell(Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () => _showEditDriverDialog(context, driver),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: AppColors.error),
                onPressed: () => _showDeleteConfirmation(context, driver),
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }

  void _showAddDriverDialog(BuildContext context) {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _licenseController.clear();
    _passwordController.clear();

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Driver'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name *'),
                    validator: (v) => v == null || v.isEmpty ? 'First name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name *'),
                    validator: (v) => v == null || v.isEmpty ? 'Last name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email *'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Email is required';
                      if (!v.contains('@') || !v.contains('.')) return 'Invalid email format';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _licenseController,
                    decoration: const InputDecoration(labelText: 'License Number *'),
                    validator: (v) => v == null || v.isEmpty ? 'License number is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password (default: default123)'),
                    obscureText: true,
                  ),
                ],
              ),
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
                final api = await ref.read(driverApiProvider.future);
                await api.createDriver({
                  'firstName': _firstNameController.text,
                  'lastName': _lastNameController.text,
                  'email': _emailController.text,
                  'licenseNumber': _licenseController.text,
                  'phone': _phoneController.text,
                  if (_passwordController.text.isNotEmpty)
                    'password': _passwordController.text,
                });
                if (context.mounted) Navigator.pop(context);
                ref.invalidate(driversProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Driver added successfully'), backgroundColor: AppColors.success),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add driver: $e'), backgroundColor: AppColors.error),
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

  void _showEditDriverDialog(BuildContext context, Driver driver) {
    _licenseController.text = driver.licenseNumber ?? '';
    _phoneController.text = driver.phone ?? '';

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Driver'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _licenseController,
                  decoration: const InputDecoration(labelText: 'License Number *'),
                  validator: (v) => v == null || v.isEmpty ? 'License number is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
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
                final api = await ref.read(driverApiProvider.future);
                await api.updateDriver(driver.id, {
                  'licenseNumber': _licenseController.text,
                  'phone': _phoneController.text,
                });
                if (context.mounted) Navigator.pop(context);
                ref.invalidate(driversProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Driver updated successfully'), backgroundColor: AppColors.success),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update driver: $e'), backgroundColor: AppColors.error),
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

  void _showDeleteConfirmation(BuildContext context, Driver driver) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Driver'),
        content: Text('Are you sure you want to delete driver ${driver.displayName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              try {
                final api = await ref.read(driverApiProvider.future);
                await api.deleteDriver(driver.id);
                if (context.mounted) Navigator.pop(context);
                ref.invalidate(driversProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Driver deleted'), backgroundColor: AppColors.success),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete driver: $e'), backgroundColor: AppColors.error),
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
