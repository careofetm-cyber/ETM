import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:etm_core/etm_core.dart';
import '../../features/auth/auth_provider.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isSuperAdmin = user?.role == UserRole.super_admin;

    return Container(
      width: 260,
      color: AppColors.surface,
      child: Column(
        children: [
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.bus_alert, size: 32, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  isSuperAdmin ? 'ETM Super Admin' : 'ETM Admin',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: isSuperAdmin ? _buildSuperAdminNav(currentRoute, context) : _buildAdminNav(currentRoute, context, user?.role),
            ),
          ),
          const Divider(),
          _NavItem(
            icon: Icons.settings,
            label: 'Settings',
            route: '/settings',
            isSelected: currentRoute == '/settings',
            onTap: () {
              Navigator.of(context).maybePop();
              context.go('/settings');
            },
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    user?.initials ?? 'U',
                    style: TextStyle(color: AppColors.textInverse),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.fullName ?? 'User',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _roleLabel(user?.role),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                    context.go('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _roleLabel(UserRole? role) {
    switch (role) {
      case UserRole.super_admin:
        return 'Super Admin';
      case UserRole.admin:
        return 'Admin';
      case UserRole.transport_manager:
        return 'Transport Manager';
      case UserRole.hr:
        return 'HR';
      case UserRole.manager:
        return 'Manager';
      case UserRole.employee:
        return 'Employee';
      case UserRole.driver:
        return 'Driver';
      default:
        return 'User';
    }
  }

  List<Widget> _buildSuperAdminNav(String currentRoute, BuildContext context) {
    return [
      _NavItem(
        icon: Icons.dashboard,
        label: 'Dashboard',
        route: '/super-dashboard',
        isSelected: currentRoute == '/super-dashboard',
        onTap: () => context.go('/super-dashboard'),
      ),
      _NavItem(
        icon: Icons.business,
        label: 'Companies',
        route: '/companies',
        isSelected: currentRoute == '/companies',
        onTap: () => context.go('/companies'),
      ),
      _NavItem(
        icon: Icons.receipt_long,
        label: 'Billing',
        route: '/billing',
        isSelected: currentRoute == '/billing',
        onTap: () => context.go('/billing'),
      ),
      _NavItem(
        icon: Icons.settings,
        label: 'System Settings',
        route: '/super-settings',
        isSelected: currentRoute == '/super-settings',
        onTap: () => context.go('/super-settings'),
      ),
    ];
  }

  List<Widget> _buildAdminNav(String currentRoute, BuildContext context, UserRole? role) {
    final items = <Widget>[];

    if (role == UserRole.admin || role == UserRole.manager) {
      items.addAll([
        _NavItem(icon: Icons.dashboard, label: 'Dashboard', route: '/dashboard', isSelected: currentRoute == '/dashboard', onTap: () => context.go('/dashboard')),
        _NavItem(icon: Icons.directions_bus, label: 'Vehicles', route: '/vehicles', isSelected: currentRoute == '/vehicles', onTap: () => context.go('/vehicles')),
        _NavItem(icon: Icons.route, label: 'Routes', route: '/routes', isSelected: currentRoute == '/routes', onTap: () => context.go('/routes')),
        _NavItem(icon: Icons.trip_origin, label: 'Trips', route: '/trips', isSelected: currentRoute == '/trips', onTap: () => context.go('/trips')),
      ]);
    }

    if (role == UserRole.admin || role == UserRole.manager || role == UserRole.transport_manager) {
      items.addAll([
        _NavItem(icon: Icons.directions_bus, label: 'Transport Manager', route: '/transport-manager', isSelected: currentRoute == '/transport-manager', onTap: () => context.go('/transport-manager')),
        const Divider(),
        _NavItem(icon: Icons.people, label: 'Employees', route: '/employees', isSelected: currentRoute == '/employees', onTap: () => context.go('/employees')),
        _NavItem(icon: Icons.person, label: 'Drivers', route: '/drivers', isSelected: currentRoute == '/drivers', onTap: () => context.go('/drivers')),
      ]);
    }

    if (role == UserRole.admin || role == UserRole.manager || role == UserRole.transport_manager || role == UserRole.hr) {
      items.addAll([
        const Divider(),
        _NavItem(icon: Icons.check_circle, label: 'Attendance', route: '/attendance', isSelected: currentRoute == '/attendance', onTap: () => context.go('/attendance')),
        _NavItem(icon: Icons.notifications, label: 'Notifications', route: '/notifications', isSelected: currentRoute == '/notifications', onTap: () => context.go('/notifications')),
      ]);
    }

    if (role == UserRole.admin || role == UserRole.transport_manager) {
      items.addAll([
        const Divider(),
        _NavItem(icon: Icons.warning, label: 'Incidents', route: '/incidents', isSelected: currentRoute == '/incidents', onTap: () => context.go('/incidents')),
        _NavItem(icon: Icons.emergency, label: 'SOS Alerts', route: '/sos-alerts', isSelected: currentRoute == '/sos-alerts', onTap: () => context.go('/sos-alerts')),
        _NavItem(icon: Icons.person_off, label: 'NCNS', route: '/ncns', isSelected: currentRoute == '/ncns', onTap: () => context.go('/ncns')),
      ]);
    }

    if (role == UserRole.admin || role == UserRole.transport_manager || role == UserRole.hr) {
      items.addAll([
        const Divider(),
        _NavItem(icon: Icons.calendar_month, label: 'Roster', route: '/roster', isSelected: currentRoute == '/roster', onTap: () => context.go('/roster')),
        _NavItem(icon: Icons.swap_horiz, label: 'Transport Requests', route: '/transport-requests', isSelected: currentRoute == '/transport-requests', onTap: () => context.go('/transport-requests')),
        _NavItem(icon: Icons.description, label: 'Vehicle Documents', route: '/vehicle-documents', isSelected: currentRoute == '/vehicle-documents', onTap: () => context.go('/vehicle-documents')),
      ]);
    }

    if (role == UserRole.admin) {
      items.addAll([
        const Divider(),
        _NavItem(icon: Icons.people_alt, label: 'User Management', route: '/user-management', isSelected: currentRoute == '/user-management', onTap: () => context.go('/user-management')),
        _NavItem(icon: Icons.admin_panel_settings, label: 'Role Permissions', route: '/role-permissions', isSelected: currentRoute == '/role-permissions', onTap: () => context.go('/role-permissions')),
        _NavItem(icon: Icons.person_pin, label: 'Employee Portal', route: '/employee-portal', isSelected: currentRoute == '/employee-portal', onTap: () => context.go('/employee-portal')),
        _NavItem(icon: Icons.assessment, label: 'Reports', route: '/reports', isSelected: currentRoute == '/reports', onTap: () => context.go('/reports')),
        const Divider(),
        _NavItem(icon: Icons.sync, label: 'HCM Integration', route: '/hcm-integration', isSelected: currentRoute == '/hcm-integration', onTap: () => context.go('/hcm-integration')),
      ]);
    }

    if (role == UserRole.manager || role == UserRole.hr) {
      items.addAll([
        const Divider(),
        _NavItem(icon: Icons.assessment, label: 'Reports', route: '/reports', isSelected: currentRoute == '/reports', onTap: () => context.go('/reports')),
      ]);
    }

    return items;
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primaryLight.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: () {
        Navigator.of(context).maybePop();
        onTap();
      },
    );
  }
}
