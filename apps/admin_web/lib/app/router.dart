import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_provider.dart';
import '../features/auth/login_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/vehicles/vehicles_screen.dart';
import '../features/routes/routes_screen.dart';
import '../features/trips/trips_screen.dart';
import '../features/employees/employees_screen.dart';
import '../features/drivers/drivers_screen.dart';
import '../features/attendance/attendance_screen.dart';
import '../features/incidents/incidents_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/companies/companies_screen.dart';
import '../features/billing/billing_screen.dart';
import '../features/super_dashboard/super_dashboard_screen.dart';
import '../features/super_settings/super_settings_screen.dart';
import '../features/user_management/user_management_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/transport_manager/transport_manager_screen.dart';
import '../features/role_permissions/role_permissions_screen.dart';
import '../features/employee_portal/employee_portal_screen.dart';
import '../features/roster/roster_screen.dart';
import '../features/vehicle_documents/vehicle_documents_screen.dart';
import '../features/transport_requests/transport_requests_screen.dart';
import '../features/sos_alerts/sos_alerts_screen.dart';
import '../features/ncns/ncns_screen.dart';
import '../features/hcm_integration/hcm_screen.dart';
import '../shared/widgets/sidebar.dart';
import 'package:etm_core/etm_core.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isLoginRoute = state.matchedLocation == '/login';
      final isSuperAdmin = authState.user?.role == UserRole.super_admin;

      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }

      if (isLoggedIn && isLoginRoute) {
        return isSuperAdmin ? '/super-dashboard' : '/dashboard';
      }

      if (isLoggedIn && state.matchedLocation == '/dashboard' && isSuperAdmin) {
        return '/super-dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AdminLayout(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/super-dashboard',
            builder: (context, state) => const SuperDashboardScreen(),
          ),
          GoRoute(
            path: '/companies',
            builder: (context, state) => const CompaniesScreen(),
          ),
          GoRoute(
            path: '/billing',
            builder: (context, state) => const BillingScreen(),
          ),
          GoRoute(
            path: '/vehicles',
            builder: (context, state) => const VehiclesScreen(),
          ),
          GoRoute(
            path: '/routes',
            builder: (context, state) => const RoutesScreen(),
          ),
          GoRoute(
            path: '/trips',
            builder: (context, state) => const TripsScreen(),
          ),
          GoRoute(
            path: '/transport-manager',
            builder: (context, state) => const TransportManagerScreen(),
          ),
          GoRoute(
            path: '/employees',
            builder: (context, state) => const EmployeesScreen(),
          ),
          GoRoute(
            path: '/drivers',
            builder: (context, state) => const DriversScreen(),
          ),
          GoRoute(
            path: '/attendance',
            builder: (context, state) => const AttendanceScreen(),
          ),
          GoRoute(
            path: '/incidents',
            builder: (context, state) => const IncidentsScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/user-management',
            builder: (context, state) => const UserManagementScreen(),
          ),
          GoRoute(
            path: '/role-permissions',
            builder: (context, state) => const RolePermissionsScreen(),
          ),
          GoRoute(
            path: '/employee-portal',
            builder: (context, state) => const EmployeePortalScreen(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/super-settings',
            builder: (context, state) => const SuperSettingsScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/roster',
            builder: (context, state) => const RosterScreen(),
          ),
          GoRoute(
            path: '/vehicle-documents',
            builder: (context, state) => const VehicleDocumentsScreen(),
          ),
          GoRoute(
            path: '/transport-requests',
            builder: (context, state) => const TransportRequestsScreen(),
          ),
          GoRoute(
            path: '/sos-alerts',
            builder: (context, state) => const SosAlertsScreen(),
          ),
          GoRoute(
            path: '/ncns',
            builder: (context, state) => const NcnsScreen(),
          ),
          GoRoute(
            path: '/hcm-integration',
            builder: (context, state) => const HcmIntegrationScreen(),
          ),
        ],
      ),
    ],
  );
});

class AdminLayout extends StatelessWidget {
  final Widget child;

  const AdminLayout({super.key, required this.child});

  static const double _sidebarWidth = 260;
  static const double _breakpoint = 768;

  String _getPageTitle(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    switch (location) {
      case '/dashboard': return 'Dashboard';
      case '/super-dashboard': return 'Dashboard';
      case '/vehicles': return 'Vehicles';
      case '/routes': return 'Routes';
      case '/trips': return 'Trips';
      case '/employees': return 'Employees';
      case '/drivers': return 'Drivers';
      case '/attendance': return 'Attendance';
      case '/incidents': return 'Incidents';
      case '/notifications': return 'Notifications';
      case '/settings': return 'Settings';
      case '/companies': return 'Companies';
      case '/billing': return 'Billing';
      case '/super-settings': return 'System Settings';
      case '/user-management': return 'User Management';
      case '/role-permissions': return 'Role Permissions';
      case '/employee-portal': return 'Employee Portal';
      case '/reports': return 'Reports';
      case '/transport-manager': return 'Transport Manager';
      case '/roster': return 'Roster';
      case '/vehicle-documents': return 'Vehicle Documents';
      case '/transport-requests': return 'Transport Requests';
      case '/sos-alerts': return 'SOS Alerts';
      case '/ncns': return 'NCNS';
      case '/hcm-integration': return 'HCM Integration';
      default: return 'Dashboard';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < _breakpoint;

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ETM Admin'),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: const SizedBox(
          width: _sidebarWidth,
          child: Sidebar(),
        ),
        body: child,
      );
    }

    final pageTitle = _getPageTitle(context);

    return Scaffold(
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0xFFE8ECF0),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.home_outlined,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Home',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        pageTitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, size: 20),
                        color: AppColors.textTertiary,
                        tooltip: 'Notifications',
                        onPressed: () {},
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.help_outline_rounded, size: 20),
                        color: AppColors.textTertiary,
                        tooltip: 'Help',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xFFF0F4F8),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
