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
    final role = user?.role;

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: const Color(0xFFE8ECF0), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: const Color(0xFFE8ECF0), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.bus_alert, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ETM',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      _panelLabel(role),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              children: [
                const _SectionLabel(label: 'MAIN'),
                const SizedBox(height: 4),
                if (role == UserRole.super_admin)
                  ..._buildSuperAdminNav(currentRoute, context)
                else if (role == UserRole.driver)
                  ..._buildDriverNav(currentRoute, context)
                else if (role == UserRole.employee)
                  ..._buildEmployeeNav(currentRoute, context)
                else
                  ..._buildAdminNav(currentRoute, context, role),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border(
                top: BorderSide(color: const Color(0xFFE8ECF0), width: 1),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Text(
                    user?.initials ?? 'U',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user?.fullName ?? 'User',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _roleLabel(role),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  color: AppColors.textTertiary,
                  tooltip: 'Logout',
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

  String _panelLabel(UserRole? role) {
    switch (role) {
      case UserRole.super_admin: return 'Super Admin Panel';
      case UserRole.driver: return 'Driver Panel';
      case UserRole.employee: return 'Employee Panel';
      default: return 'Admin Panel';
    }
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
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
        label: 'Dashboard',
        route: '/super-dashboard',
        isSelected: currentRoute == '/super-dashboard',
        onTap: () => context.go('/super-dashboard'),
      ),
      _NavItem(
        icon: Icons.business_outlined,
        selectedIcon: Icons.business_rounded,
        label: 'Companies',
        route: '/companies',
        isSelected: currentRoute == '/companies',
        onTap: () => context.go('/companies'),
      ),
      _NavItem(
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long_rounded,
        label: 'Billing',
        route: '/billing',
        isSelected: currentRoute == '/billing',
        onTap: () => context.go('/billing'),
      ),
      _NavItem(
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings_rounded,
        label: 'System Settings',
        route: '/super-settings',
        isSelected: currentRoute == '/super-settings',
        onTap: () => context.go('/super-settings'),
      ),
    ];
  }

  List<Widget> _buildDriverNav(String currentRoute, BuildContext context) {
    return [
      _NavItem(
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
        label: 'Dashboard',
        route: '/driver/dashboard',
        isSelected: currentRoute == '/driver/dashboard',
        onTap: () => context.go('/driver/dashboard'),
      ),
      _NavItem(
        icon: Icons.trip_origin_outlined,
        selectedIcon: Icons.trip_origin_rounded,
        label: 'My Trips',
        route: '/driver/trips',
        isSelected: currentRoute == '/driver/trips',
        onTap: () => context.go('/driver/trips'),
      ),
      _NavItem(
        icon: Icons.gps_fixed_outlined,
        selectedIcon: Icons.gps_fixed_rounded,
        label: 'Tracking',
        route: '/driver/tracking',
        isSelected: currentRoute == '/driver/tracking',
        onTap: () => context.go('/driver/tracking'),
      ),
      _NavItem(
        icon: Icons.notifications_outlined,
        selectedIcon: Icons.notifications_rounded,
        label: 'Notifications',
        route: '/notifications',
        isSelected: currentRoute == '/notifications',
        onTap: () => context.go('/notifications'),
      ),
      const _SectionLabel(label: 'ACCOUNT'),
      const SizedBox(height: 4),
      _NavItem(
        icon: Icons.person_outline,
        selectedIcon: Icons.person_rounded,
        label: 'Profile',
        route: '/profile',
        isSelected: currentRoute == '/profile',
        onTap: () => context.go('/profile'),
      ),
      _NavItem(
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings_rounded,
        label: 'Settings',
        route: '/settings',
        isSelected: currentRoute == '/settings',
        onTap: () => context.go('/settings'),
      ),
    ];
  }

  List<Widget> _buildEmployeeNav(String currentRoute, BuildContext context) {
    return [
      _NavItem(
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
        label: 'Dashboard',
        route: '/employee/dashboard',
        isSelected: currentRoute == '/employee/dashboard',
        onTap: () => context.go('/employee/dashboard'),
      ),
      _NavItem(
        icon: Icons.trip_origin_outlined,
        selectedIcon: Icons.trip_origin_rounded,
        label: 'My Trips',
        route: '/employee/trips',
        isSelected: currentRoute == '/employee/trips',
        onTap: () => context.go('/employee/trips'),
      ),
      _NavItem(
        icon: Icons.pin_outlined,
        selectedIcon: Icons.pin_rounded,
        label: 'Ride / OTP',
        route: '/employee/ride',
        isSelected: currentRoute == '/employee/ride',
        onTap: () => context.go('/employee/ride'),
      ),
      _NavItem(
        icon: Icons.calendar_month_outlined,
        selectedIcon: Icons.calendar_month_rounded,
        label: 'Roster',
        route: '/employee/roster',
        isSelected: currentRoute == '/employee/roster',
        onTap: () => context.go('/employee/roster'),
      ),
      _NavItem(
        icon: Icons.gps_fixed_outlined,
        selectedIcon: Icons.gps_fixed_rounded,
        label: 'Tracking',
        route: '/employee/tracking',
        isSelected: currentRoute == '/employee/tracking',
        onTap: () => context.go('/employee/tracking'),
      ),
      _NavItem(
        icon: Icons.notifications_outlined,
        selectedIcon: Icons.notifications_rounded,
        label: 'Notifications',
        route: '/notifications',
        isSelected: currentRoute == '/notifications',
        onTap: () => context.go('/notifications'),
      ),
      _NavItem(
        icon: Icons.emergency_outlined,
        selectedIcon: Icons.emergency_rounded,
        label: 'SOS',
        route: '/employee/sos',
        isSelected: currentRoute == '/employee/sos',
        onTap: () => context.go('/employee/sos'),
      ),
      const _SectionLabel(label: 'ACCOUNT'),
      const SizedBox(height: 4),
      _NavItem(
        icon: Icons.person_outline,
        selectedIcon: Icons.person_rounded,
        label: 'Profile',
        route: '/profile',
        isSelected: currentRoute == '/profile',
        onTap: () => context.go('/profile'),
      ),
      _NavItem(
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings_rounded,
        label: 'Settings',
        route: '/settings',
        isSelected: currentRoute == '/settings',
        onTap: () => context.go('/settings'),
      ),
    ];
  }

  List<Widget> _buildAdminNav(String currentRoute, BuildContext context, UserRole? role) {
    final items = <Widget>[];

    if (role == UserRole.admin || role == UserRole.manager) {
      items.addAll([
        _NavItem(
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard_rounded,
          label: 'Dashboard',
          route: '/dashboard',
          isSelected: currentRoute == '/dashboard',
          onTap: () => context.go('/dashboard'),
        ),
        _NavItem(
          icon: Icons.directions_bus_outlined,
          selectedIcon: Icons.directions_bus_rounded,
          label: 'Vehicles',
          route: '/vehicles',
          isSelected: currentRoute == '/vehicles',
          onTap: () => context.go('/vehicles'),
        ),
        _NavItem(
          icon: Icons.person_outline,
          selectedIcon: Icons.person_rounded,
          label: 'Drivers',
          route: '/drivers',
          isSelected: currentRoute == '/drivers',
          onTap: () => context.go('/drivers'),
        ),
        _NavItem(
          icon: Icons.people_outline,
          selectedIcon: Icons.people_rounded,
          label: 'Employees',
          route: '/employees',
          isSelected: currentRoute == '/employees',
          onTap: () => context.go('/employees'),
        ),
        _NavItem(
          icon: Icons.route_outlined,
          selectedIcon: Icons.route_rounded,
          label: 'Routes',
          route: '/routes',
          isSelected: currentRoute == '/routes',
          onTap: () => context.go('/routes'),
        ),
        _NavItem(
          icon: Icons.trip_origin_outlined,
          selectedIcon: Icons.trip_origin_rounded,
          label: 'Trips',
          route: '/trips',
          isSelected: currentRoute == '/trips',
          onTap: () => context.go('/trips'),
        ),
      ]);
    }

    if (role == UserRole.admin || role == UserRole.manager || role == UserRole.transport_manager) {
      items.addAll([
        const _SectionLabel(label: 'MANAGEMENT'),
        const SizedBox(height: 4),
        _NavItem(
          icon: Icons.account_tree_outlined,
          selectedIcon: Icons.account_tree_rounded,
          label: 'Transport Manager',
          route: '/transport-manager',
          isSelected: currentRoute == '/transport-manager',
          onTap: () => context.go('/transport-manager'),
        ),
      ]);
    }

    if (role == UserRole.admin || role == UserRole.manager || role == UserRole.transport_manager || role == UserRole.hr) {
      items.addAll([
        const _SectionLabel(label: 'OPERATIONS'),
        const SizedBox(height: 4),
        _NavItem(
          icon: Icons.check_circle_outline,
          selectedIcon: Icons.check_circle_rounded,
          label: 'Attendance',
          route: '/attendance',
          isSelected: currentRoute == '/attendance',
          onTap: () => context.go('/attendance'),
        ),
        _NavItem(
          icon: Icons.notifications_outlined,
          selectedIcon: Icons.notifications_rounded,
          label: 'Notifications',
          route: '/notifications',
          isSelected: currentRoute == '/notifications',
          onTap: () => context.go('/notifications'),
        ),
      ]);
    }

    if (role == UserRole.admin || role == UserRole.transport_manager) {
      items.addAll([
        const _SectionLabel(label: 'SAFETY'),
        const SizedBox(height: 4),
        _NavItem(
          icon: Icons.warning_amber_outlined,
          selectedIcon: Icons.warning_amber_rounded,
          label: 'Incidents',
          route: '/incidents',
          isSelected: currentRoute == '/incidents',
          onTap: () => context.go('/incidents'),
        ),
        _NavItem(
          icon: Icons.emergency_outlined,
          selectedIcon: Icons.emergency_rounded,
          label: 'SOS Alerts',
          route: '/sos-alerts',
          isSelected: currentRoute == '/sos-alerts',
          onTap: () => context.go('/sos-alerts'),
        ),
        _NavItem(
          icon: Icons.person_off_outlined,
          selectedIcon: Icons.person_off_rounded,
          label: 'NCNS',
          route: '/ncns',
          isSelected: currentRoute == '/ncns',
          onTap: () => context.go('/ncns'),
        ),
      ]);
    }

    if (role == UserRole.admin || role == UserRole.transport_manager || role == UserRole.hr) {
      items.addAll([
        const _SectionLabel(label: 'SCHEDULING'),
        const SizedBox(height: 4),
        _NavItem(
          icon: Icons.calendar_month_outlined,
          selectedIcon: Icons.calendar_month_rounded,
          label: 'Roster',
          route: '/roster',
          isSelected: currentRoute == '/roster',
          onTap: () => context.go('/roster'),
        ),
        _NavItem(
          icon: Icons.swap_horiz_outlined,
          selectedIcon: Icons.swap_horiz_rounded,
          label: 'Transport Requests',
          route: '/transport-requests',
          isSelected: currentRoute == '/transport-requests',
          onTap: () => context.go('/transport-requests'),
        ),
        _NavItem(
          icon: Icons.description_outlined,
          selectedIcon: Icons.description_rounded,
          label: 'Vehicle Documents',
          route: '/vehicle-documents',
          isSelected: currentRoute == '/vehicle-documents',
          onTap: () => context.go('/vehicle-documents'),
        ),
      ]);
    }

    if (role == UserRole.admin) {
      items.addAll([
        const _SectionLabel(label: 'ADMINISTRATION'),
        const SizedBox(height: 4),
        _NavItem(
          icon: Icons.manage_accounts_outlined,
          selectedIcon: Icons.manage_accounts_rounded,
          label: 'User Management',
          route: '/user-management',
          isSelected: currentRoute == '/user-management',
          onTap: () => context.go('/user-management'),
        ),
        _NavItem(
          icon: Icons.admin_panel_settings_outlined,
          selectedIcon: Icons.admin_panel_settings_rounded,
          label: 'Role Permissions',
          route: '/role-permissions',
          isSelected: currentRoute == '/role-permissions',
          onTap: () => context.go('/role-permissions'),
        ),
        _NavItem(
          icon: Icons.portrait_outlined,
          selectedIcon: Icons.portrait_rounded,
          label: 'Employee Portal',
          route: '/employee-portal',
          isSelected: currentRoute == '/employee-portal',
          onTap: () => context.go('/employee-portal'),
        ),
        _NavItem(
          icon: Icons.assessment_outlined,
          selectedIcon: Icons.assessment_rounded,
          label: 'Reports',
          route: '/reports',
          isSelected: currentRoute == '/reports',
          onTap: () => context.go('/reports'),
        ),
        _NavItem(
          icon: Icons.sync_outlined,
          selectedIcon: Icons.sync_rounded,
          label: 'HCM Integration',
          route: '/hcm-integration',
          isSelected: currentRoute == '/hcm-integration',
          onTap: () => context.go('/hcm-integration'),
        ),
      ]);
    }

    if (role == UserRole.manager || role == UserRole.hr) {
      items.addAll([
        const _SectionLabel(label: 'REPORTS'),
        const SizedBox(height: 4),
        _NavItem(
          icon: Icons.assessment_outlined,
          selectedIcon: Icons.assessment_rounded,
          label: 'Reports',
          route: '/reports',
          isSelected: currentRoute == '/reports',
          onTap: () => context.go('/reports'),
        ),
      ]);
    }

    return items;
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 12, bottom: 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final String route;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    this.selectedIcon,
    required this.label,
    required this.route,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Material(
        color: isSelected ? primaryColor.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            Navigator.of(context).maybePop();
            onTap();
          },
          borderRadius: BorderRadius.circular(10),
          hoverColor: primaryColor.withOpacity(0.04),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(color: primaryColor.withOpacity(0.2), width: 1)
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? (selectedIcon ?? icon) : icon,
                  size: 20,
                  color: isSelected ? primaryColor : AppColors.textTertiary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected ? primaryColor : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
