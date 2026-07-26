import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class PermissionRoutes {
  final router = Router();

  PermissionRoutes() {
    router.get('/roles', authMiddleware()(getRoles));
    router.get('/roles/:role', authMiddleware()(getRolePermissions));
    router.put('/roles/:role', authMiddleware(requiredRoles: ['super_admin', 'admin'])(updateRolePermissions));
  }

  Future<Response> getRoles(Request request) async {
    final roles = {
      'transport_manager': {
        'label': 'Transport Manager',
        'description': 'Full access to transport operations',
        'permissions': [
          'dashboard.view', 'vehicles.view', 'vehicles.create', 'vehicles.edit', 'vehicles.delete',
          'routes.view', 'routes.create', 'routes.edit', 'routes.delete',
          'trips.view', 'trips.create', 'trips.edit', 'trips.assign_cab', 'trips.start_ride', 'trips.complete_ride',
          'employees.view', 'employees.create', 'employees.edit', 'employees.assign_route',
          'drivers.view', 'drivers.create', 'drivers.edit', 'drivers.assign_vehicle',
          'attendance.view', 'attendance.edit',
          'incidents.view', 'incidents.create', 'incidents.resolve',
          'notifications.create', 'notifications.view',
          'reports.view', 'reports.export',
          'schedules.view', 'schedules.create', 'schedules.edit',
        ],
      },
      'hr': {
        'label': 'HR Manager',
        'description': 'Employee management and attendance',
        'permissions': [
          'dashboard.view',
          'employees.view', 'employees.create', 'employees.edit',
          'attendance.view', 'attendance.edit',
          'incidents.view', 'incidents.create',
          'notifications.view', 'notifications.create',
          'reports.view', 'reports.export',
        ],
      },
      'admin': {
        'label': 'Company Admin',
        'description': 'Full company access',
        'permissions': [
          'dashboard.view', 'settings.view', 'settings.edit',
          'vehicles.view', 'vehicles.create', 'vehicles.edit', 'vehicles.delete',
          'routes.view', 'routes.create', 'routes.edit', 'routes.delete',
          'trips.view', 'trips.create', 'trips.edit', 'trips.assign_cab', 'trips.start_ride', 'trips.complete_ride',
          'employees.view', 'employees.create', 'employees.edit', 'employees.delete', 'employees.assign_route',
          'drivers.view', 'drivers.create', 'drivers.edit', 'drivers.delete', 'drivers.assign_vehicle',
          'attendance.view', 'attendance.edit',
          'incidents.view', 'incidents.create', 'incidents.resolve',
          'notifications.view', 'notifications.create', 'notifications.delete',
          'reports.view', 'reports.export',
          'schedules.view', 'schedules.create', 'schedules.edit',
          'users.view', 'users.create', 'users.edit', 'users.delete',
          'billing.view',
        ],
      },
      'employee': {
        'label': 'Employee',
        'description': 'Limited access - trips, schedule, requests',
        'permissions': [
          'dashboard.view',
          'trips.view',
          'trips.request_adjustment',
          'schedule.view',
          'ride.start',
          'ride.view_status',
          'incidents.create',
          'profile.view', 'profile.edit',
        ],
      },
      'driver': {
        'label': 'Driver',
        'description': 'Trip execution and location updates',
        'permissions': [
          'trips.view', 'trips.start', 'trips.complete',
          'vehicle.view', 'vehicle.update_location', 'vehicle.inspection',
          'ride.verify_otp', 'ride.update_status',
          'incidents.create',
          'profile.view', 'profile.edit',
        ],
      },
    };

    return jsonResponse({'data': roles});
  }

  Future<Response> getRolePermissions(Request request) async {
    final role = request.params['role'];
    final db = DatabaseConfig.db;

    var stored = db.findOne('role_permissions', where: {'role': role});
    if (stored == null) {
      stored = {'role': role, 'permissions': '[]'};
    }

    return jsonResponse(stored);
  }

  Future<Response> updateRolePermissions(Request request) async {
    final role = request.params['role'];
    final body = jsonDecode(await request.readAsString());
    final db = DatabaseConfig.db;

    final permissions = body['permissions'] as List;
    final permissionsJson = jsonEncode(permissions);

    final existing = db.findOne('role_permissions', where: {'role': role});
    if (existing != null) {
      db.update('role_permissions', {
        'permissions': permissionsJson,
        'updated_at': DateTime.now().toIso8601String(),
      }, where: {'role': role});
    } else {
      db.insert('role_permissions', {
        'id': 'rp_${role}',
        'role': role,
        'permissions': permissionsJson,
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    return jsonResponse({'message': 'Permissions updated for $role'});
  }
}
