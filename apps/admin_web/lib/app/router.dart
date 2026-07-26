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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
