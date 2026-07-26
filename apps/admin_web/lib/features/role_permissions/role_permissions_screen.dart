import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

final _rolesProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final api = await ref.watch(permissionApiProvider.future);
  return api.getRoles();
});

class RolePermissionsScreen extends ConsumerStatefulWidget {
  const RolePermissionsScreen({super.key});

  @override
  ConsumerState<RolePermissionsScreen> createState() => _RolePermissionsScreenState();
}

class _RolePermissionsScreenState extends ConsumerState<RolePermissionsScreen> {
  final Map<String, Set<String>> _rolePermissions = {};
  bool _isLoading = false;

  static const _permissionCategories = {
    'Vehicles': [
      'vehicles.view',
      'vehicles.create',
      'vehicles.edit',
      'vehicles.delete',
    ],
    'Routes': [
      'routes.view',
      'routes.create',
      'routes.edit',
      'routes.delete',
    ],
    'Trips': [
      'trips.view',
      'trips.create',
      'trips.edit',
      'trips.cancel',
      'trips.start',
      'trips.complete',
    ],
    'Employees': [
      'employees.view',
      'employees.create',
      'employees.edit',
      'employees.delete',
    ],
    'Drivers': [
      'drivers.view',
      'drivers.create',
      'drivers.edit',
      'drivers.delete',
    ],
    'Attendance': [
      'attendance.view',
      'attendance.mark',
      'attendance.edit',
    ],
    'Incidents': [
      'incidents.view',
      'incidents.create',
      'incidents.resolve',
    ],
    'Notifications': [
      'notifications.view',
      'notifications.send',
    ],
    'Billing': [
      'billing.view',
      'billing.edit',
    ],
    'Reports': [
      'reports.view',
      'reports.export',
    ],
    'Settings': [
      'settings.view',
      'settings.edit',
    ],
  };

  static const _roleDescriptions = {
    'transport_manager': 'Manages trips, vehicles, drivers, and cab assignments',
    'hr_manager': 'Manages employees, attendance, and roster',
    'company_admin': 'Full admin access for the company',
    'employee': 'Views own trips and requests adjustments',
    'driver': 'Manages assigned trips and provides location updates',
    'super_admin': 'Full system access across all companies',
  };

  @override
  Widget build(BuildContext context) {
    final rolesAsync = ref.watch(_rolesProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Role Permissions',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: rolesAsync.when(
                data: (rolesData) {
                  final roles = rolesData['data'] ?? rolesData;
                  final roleList = roles is Map ? roles.keys.toList() : <String>[];
                  if (roleList.isEmpty) {
                    return const Center(child: Text('No roles found'));
                  }
                  return ListView.builder(
                    itemCount: roleList.length,
                    itemBuilder: (context, index) {
                      final role = roleList[index].toString();
                      final permissions = roles[role];
                      if (_rolePermissions[role] == null && permissions is List) {
                        _rolePermissions[role] = Set<String>.from(permissions.map((p) => p.toString()));
                      }
                      return _buildRoleCard(role, _rolePermissions[role] ?? {});
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(String role, Set<String> currentPermissions) {
    final description = _roleDescriptions[role] ?? 'Custom role';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_roleIcon(role), color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.replaceAll('_', ' ').toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        description,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : () => _savePermissions(role),
                  child: _isLoading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Save'),
                ),
              ],
            ),
            const Divider(height: 32),
            ..._permissionCategories.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: entry.value.map<Widget>((permission) {
                      final isEnabled = currentPermissions.contains(permission);
                      return FilterChip(
                        label: Text(permission.split('.').last),
                        selected: isEnabled,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _rolePermissions.putIfAbsent(role, () => {});
                              _rolePermissions[role]!.add(permission);
                            } else {
                              _rolePermissions[role]?.remove(permission);
                            }
                          });
                        },
                        selectedColor: AppColors.primary.withOpacity(0.1),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  IconData _roleIcon(String role) {
    switch (role) {
      case 'transport_manager':
        return Icons.directions_bus;
      case 'hr_manager':
        return Icons.people;
      case 'company_admin':
        return Icons.admin_panel_settings;
      case 'employee':
        return Icons.person;
      case 'driver':
        return Icons.drive_eta;
      case 'super_admin':
        return Icons.security;
      default:
        return Icons.help_outline;
    }
  }

  Future<void> _savePermissions(String role) async {
    setState(() => _isLoading = true);
    try {
      final api = await ref.read(permissionApiProvider.future);
      final permissions = _rolePermissions[role]?.toList() ?? [];
      await api.updateRolePermissions(role, permissions);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permissions updated for ${role.replaceAll('_', ' ')}'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update permissions: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
