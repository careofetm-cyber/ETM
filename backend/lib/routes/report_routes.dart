import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class ReportRoutes {
  final router = Router();

  ReportRoutes() {
    router.get('/employees', authMiddleware(requiredRoles: ['super_admin', 'admin', 'manager'])(exportEmployees));
    router.get('/trips', authMiddleware(requiredRoles: ['super_admin', 'admin', 'manager'])(exportTrips));
    router.get('/billing', authMiddleware(requiredRoles: ['super_admin', 'admin'])(exportBilling));
    router.get('/attendance', authMiddleware(requiredRoles: ['super_admin', 'admin', 'manager'])(exportAttendance));
    router.get('/vehicles', authMiddleware(requiredRoles: ['super_admin', 'admin'])(exportVehicles));
  }

  Future<Response> exportEmployees(Request request) async {
    final companyId = request.context['companyId'] as String?;
    final role = request.context['role'] as String;
    final db = DatabaseConfig.db;

    List<Map<String, dynamic>> employees;
    if (role == 'super_admin') {
      employees = db.findAll('employees');
    } else {
      employees = db.findAll('employees', filters: {'company_id': companyId});
    }

    final enriched = employees.map((e) {
      final user = db.findOne('users', where: {'id': e['user_id']});
      return {
        'id': e['id'],
        'employeeCode': e['employee_code'] ?? '',
        'name': user != null ? '${user['first_name']} ${user['last_name']}' : '',
        'email': user != null ? user['email'] : '',
        'phone': e['phone'] ?? user?['phone'] ?? '',
        'department': e['department'] ?? '',
        'designation': e['designation'] ?? '',
        'isActive': e['is_active'] ?? true,
        'isTransportRequired': e['is_transport_required'] ?? false,
        'companyId': e['company_id'] ?? '',
      };
    }).toList();

    return jsonResponse({'data': enriched, 'total': enriched.length});
  }

  Future<Response> exportTrips(Request request) async {
    final companyId = request.context['companyId'] as String?;
    final role = request.context['role'] as String;
    final db = DatabaseConfig.db;

    List<Map<String, dynamic>> trips;
    if (role == 'super_admin') {
      trips = db.findAll('trips');
    } else {
      trips = db.findAll('trips', filters: {'company_id': companyId});
    }

    final enriched = trips.map((t) {
      final route = db.findOne('routes', where: {'id': t['route_id']});
      final vehicle = db.findOne('vehicles', where: {'id': t['vehicle_id']});
      return {
        'id': t['id'],
        'routeName': route?['name'] ?? '',
        'vehiclePlate': vehicle?['plate_number'] ?? '',
        'type': t['type'] ?? '',
        'status': t['status'] ?? '',
        'scheduledTime': t['scheduled_time'] ?? '',
        'actualStartTime': t['actual_start_time'] ?? '',
        'actualEndTime': t['actual_end_time'] ?? '',
        'totalPassengers': t['total_passengers'] ?? 0,
        'boardedPassengers': t['boarded_passengers'] ?? 0,
        'totalDistance': t['total_distance'] ?? 0,
        'companyId': t['company_id'] ?? '',
      };
    }).toList();

    return jsonResponse({'data': enriched, 'total': enriched.length});
  }

  Future<Response> exportBilling(Request request) async {
    final companyId = request.context['companyId'] as String?;
    final role = request.context['role'] as String;
    final db = DatabaseConfig.db;

    List<Map<String, dynamic>> records;
    if (role == 'super_admin') {
      records = db.findAll('billing_records');
    } else {
      records = db.findAll('billing_records', filters: {'company_id': companyId});
    }

    final enriched = records.map((r) {
      final company = db.findOne('companies', where: {'id': r['company_id']});
      return {
        'id': r['id'],
        'tripId': r['trip_id'] ?? '',
        'companyName': company?['name'] ?? '',
        'month': r['month'] ?? '',
        'totalDistance': r['total_distance'] ?? 0,
        'tripCost': r['trip_cost'] ?? 0,
        'isBillable': r['is_billable'] ?? true,
        'needsReview': r['needs_review'] ?? false,
        'createdAt': r['created_at'] ?? '',
      };
    }).toList();

    return jsonResponse({'data': enriched, 'total': enriched.length});
  }

  Future<Response> exportAttendance(Request request) async {
    final companyId = request.context['companyId'] as String?;
    final role = request.context['role'] as String;
    final db = DatabaseConfig.db;

    List<Map<String, dynamic>> records;
    if (role == 'super_admin') {
      records = db.findAll('attendance');
    } else {
      records = db.findAll('attendance', filters: {'company_id': companyId});
    }

    final enriched = records.map((a) {
      final employee = db.findOne('employees', where: {'id': a['employee_id']});
      final user = employee != null ? db.findOne('users', where: {'id': employee['user_id']}) : null;
      return {
        'id': a['id'],
        'employeeName': user != null ? '${user['first_name']} ${user['last_name']}' : '',
        'date': a['date'] ?? '',
        'status': a['status'] ?? '',
        'boardingMethod': a['boarding_method'] ?? '',
        'checkInTime': a['check_in_time'] ?? '',
        'companyId': a['company_id'] ?? '',
      };
    }).toList();

    return jsonResponse({'data': enriched, 'total': enriched.length});
  }

  Future<Response> exportVehicles(Request request) async {
    final companyId = request.context['companyId'] as String?;
    final role = request.context['role'] as String;
    final db = DatabaseConfig.db;

    List<Map<String, dynamic>> vehicles;
    if (role == 'super_admin') {
      vehicles = db.findAll('vehicles');
    } else {
      vehicles = db.findAll('vehicles', filters: {'company_id': companyId});
    }

    final enriched = vehicles.map((v) {
      return {
        'id': v['id'],
        'plateNumber': v['plate_number'] ?? '',
        'model': v['model'] ?? '',
        'brand': v['brand'] ?? '',
        'year': v['year'] ?? '',
        'seatingCapacity': v['seating_capacity'] ?? '',
        'color': v['color'] ?? '',
        'status': v['status'] ?? '',
        'companyId': v['company_id'] ?? '',
      };
    }).toList();

    return jsonResponse({'data': enriched, 'total': enriched.length});
  }
}
