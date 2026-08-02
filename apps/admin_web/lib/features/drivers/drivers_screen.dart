import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';
import '../../shared/widgets/column_selector.dart';

final driversPageProvider = StateProvider<int>((ref) => 1);
final driversSearchProvider = StateProvider<String>((ref) => '');

const _driverColumnOptions = [
  ColumnOption(key: 'name', label: 'Name'),
  ColumnOption(key: 'email', label: 'Email'),
  ColumnOption(key: 'phone', label: 'Phone'),
  ColumnOption(key: 'license', label: 'License'),
  ColumnOption(key: 'status', label: 'Status'),
  ColumnOption(key: 'vehicle', label: 'Vehicle'),
];

final driversSelectedColumnsProvider = StateProvider<Set<String>>((ref) => {
      'name',
      'email',
      'license',
      'status',
    });

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
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Drivers',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: isMobile ? 20 : null,
                  ),
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
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: isMobile ? double.infinity : 300,
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
                ColumnSelector(
                  tooltip: 'Select columns',
                  allColumns: _driverColumnOptions,
                  selectedKeys: ref.watch(driversSelectedColumnsProvider),
                  onChanged: (keys) =>
                      ref.read(driversSelectedColumnsProvider.notifier).state = keys,
                ),
              ],
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
    final selected = ref.watch(driversSelectedColumnsProvider);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: const Color(0xFFF1F5F9),
          child: Row(
            children: [
              if (selected.contains('name')) const Expanded(flex: 2, child: Text('NAME', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('email')) const Expanded(flex: 2, child: Text('EMAIL', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('phone')) const Expanded(flex: 2, child: Text('PHONE', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('license')) const Expanded(flex: 2, child: Text('LICENSE', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('vehicle')) const Expanded(flex: 2, child: Text('VEHICLE', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              if (selected.contains('status')) const Expanded(child: Text('STATUS', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              const SizedBox(width: 100, child: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              final driver = drivers[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: index % 2 == 0 ? Colors.white : const Color(0xFFF8FAFC),
                child: Row(
                  children: [
                    if (selected.contains('name')) Expanded(flex: 2, child: Text(driver.displayName, style: const TextStyle(fontWeight: FontWeight.w500))),
                    if (selected.contains('email')) Expanded(flex: 2, child: Text(driver.email ?? '-')),
                    if (selected.contains('phone')) Expanded(flex: 2, child: Text(driver.phone ?? '-')),
                    if (selected.contains('license')) Expanded(flex: 2, child: Text(driver.licenseNumber ?? '-')),
                    if (selected.contains('vehicle')) Expanded(flex: 2, child: Text(driver.assignedVehicleId ?? '-')),
                    if (selected.contains('status')) Expanded(
                      child: Switch(
                        value: driver.isAvailable ?? false,
                        onChanged: (value) async {
                          final api = await ref.read(driverApiProvider.future);
                          await api.updateAvailability(driver.id, value);
                          ref.invalidate(driversProvider);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () => _showEditDriverDialog(context, driver),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 18, color: AppColors.error),
                            onPressed: () => _showDeleteConfirmation(context, driver),
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
