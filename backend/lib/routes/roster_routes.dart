import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class RosterRoutes {
  final router = Router();

  RosterRoutes() {
    router.get('/', authMiddleware()(getRosters));
    router.get('/employee/<employeeId>', authMiddleware()(getEmployeeRosters));
    router.post('/', authMiddleware(requiredRoles: ['admin', 'manager'])(createRoster));
    router.put('/<id>', authMiddleware(requiredRoles: ['admin', 'manager'])(updateRoster));
    router.delete('/<id>', authMiddleware(requiredRoles: ['admin'])(deleteRoster));
    router.post('/bulk', authMiddleware(requiredRoles: ['admin', 'manager'])(bulkCreateRosters));
    router.get('/requests', authMiddleware()(getRosterRequests));
    router.post('/requests', authMiddleware()(createRosterRequest));
    router.post('/requests/<id>/approve', authMiddleware(requiredRoles: ['admin', 'manager'])(approveRosterRequest));
    router.post('/requests/<id>/reject', authMiddleware(requiredRoles: ['admin', 'manager'])(rejectRosterRequest));
  }

  Future<Response> getRosters(Request request) async {
    final page = int.tryParse(request.url.queryParameters['page'] ?? '1') ?? 1;
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '50') ?? 50;
    final date = request.url.queryParameters['date'];
    final startDate = request.url.queryParameters['startDate'];
    final endDate = request.url.queryParameters['endDate'];
    final companyId = request.context['companyId'] as String?;

    final db = DatabaseConfig.db;
    final filters = <String, dynamic>{'company_id': companyId};

    var allRosters = db.findAll('rosters', filters: filters);
    if (date != null) {
      allRosters = allRosters.where((r) => r['date']?.toString() == date).toList();
    }
    if (startDate != null) {
      allRosters = allRosters.where((r) => (r['date'] ?? '').toString().compareTo(startDate) >= 0).toList();
    }
    if (endDate != null) {
      allRosters = allRosters.where((r) => (r['date'] ?? '').toString().compareTo(endDate) <= 0).toList();
    }

    final total = allRosters.length;
    allRosters.sort((a, b) => (a['date'] ?? '').toString().compareTo((b['date'] ?? '').toString()));
    final paginated = allRosters.skip((page - 1) * limit).take(limit).toList();

    return paginatedResponse(paginated, total, page, limit);
  }

  Future<Response> getEmployeeRosters(Request request) async {
    final employeeId = request.params['employeeId'];
    final startDate = request.url.queryParameters['startDate'];
    final endDate = request.url.queryParameters['endDate'];

    final db = DatabaseConfig.db;
    var rosters = db.findAll('rosters', filters: {'employee_id': employeeId});
    if (startDate != null) {
      rosters = rosters.where((r) => (r['date'] ?? '').toString().compareTo(startDate) >= 0).toList();
    }
    if (endDate != null) {
      rosters = rosters.where((r) => (r['date'] ?? '').toString().compareTo(endDate) <= 0).toList();
    }
    rosters.sort((a, b) => (a['date'] ?? '').toString().compareTo((b['date'] ?? '').toString()));

    return jsonResponse({'data': rosters, 'total': rosters.length});
  }

  Future<Response> createRoster(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now().toIso8601String();
    final db = DatabaseConfig.db;
    db.insert('rosters', {
      'id': id,
      'employee_id': body['employeeId'],
      'company_id': companyId,
      'date': body['date'],
      'route_id': body['routeId'],
      'stop_id': body['stopId'],
      'shift_type': body['shiftType'] ?? 'morning',
      'status': 'approved',
      'is_active': true,
      'created_at': now,
    });

    return jsonResponse({'id': id, 'message': 'Roster created successfully'}, statusCode: 201);
  }

  Future<Response> updateRoster(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());

    final db = DatabaseConfig.db;
    final updates = <String, dynamic>{};
    if (body['date'] != null) updates['date'] = body['date'];
    if (body['routeId'] != null) updates['route_id'] = body['routeId'];
    if (body['stopId'] != null) updates['stop_id'] = body['stopId'];
    if (body['shiftType'] != null) updates['shift_type'] = body['shiftType'];
    if (body['status'] != null) updates['status'] = body['status'];
    if (body['isActive'] != null) updates['is_active'] = body['isActive'];
    if (updates.isNotEmpty) {
      updates['updated_at'] = DateTime.now().toIso8601String();
      db.update('rosters', updates, where: {'id': id});
    }

    return jsonResponse({'message': 'Roster updated successfully'});
  }

  Future<Response> deleteRoster(Request request) async {
    final id = request.params['id'];
    final db = DatabaseConfig.db;
    db.update('rosters', {'is_active': false, 'updated_at': DateTime.now().toIso8601String()}, where: {'id': id});
    return jsonResponse({'message': 'Roster deleted successfully'});
  }

  Future<Response> bulkCreateRosters(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    final rosters = body['rosters'] as List;

    final db = DatabaseConfig.db;
    final now = DateTime.now().toIso8601String();
    int created = 0;

    for (var r in rosters) {
      final id = 'rost_${DateTime.now().millisecondsSinceEpoch}_$created';
      db.insert('rosters', {
        'id': id,
        'employee_id': r['employeeId'],
        'company_id': companyId,
        'date': r['date'],
        'route_id': r['routeId'],
        'stop_id': r['stopId'],
        'shift_type': r['shiftType'] ?? 'morning',
        'status': 'approved',
        'is_active': true,
        'created_at': now,
      });
      created++;
    }

    return jsonResponse({'message': '$created roster entries created', 'count': created}, statusCode: 201);
  }

  Future<Response> getRosterRequests(Request request) async {
    final page = int.tryParse(request.url.queryParameters['page'] ?? '1') ?? 1;
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '20') ?? 20;
    final status = request.url.queryParameters['status'];
    final companyId = request.context['companyId'] as String?;

    final db = DatabaseConfig.db;
    final filters = <String, dynamic>{'company_id': companyId};
    if (status != null) filters['status'] = status;

    var allRequests = db.findAll('roster_requests', filters: filters);
    final total = allRequests.length;
    allRequests.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));
    final paginated = allRequests.skip((page - 1) * limit).take(limit).toList();

    return paginatedResponse(paginated, total, page, limit);
  }

  Future<Response> createRosterRequest(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    final userId = request.context['userId'] as String;

    final db = DatabaseConfig.db;
    final employee = db.findOne('employees', where: {'user_id': userId});
    if (employee == null) {
      return errorResponse('Employee not found', statusCode: 404);
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now().toIso8601String();
    db.insert('roster_requests', {
      'id': id,
      'employee_id': employee['id'],
      'company_id': companyId,
      'request_type': body['requestType'] ?? 'schedule_change',
      'current_date': body['currentDate'],
      'requested_date': body['requestedDate'],
      'current_route_id': body['currentRouteId'],
      'requested_route_id': body['requestedRouteId'],
      'current_stop_id': body['currentStopId'],
      'requested_stop_id': body['requestedStopId'],
      'reason': body['reason'],
      'status': 'pending',
      'created_at': now,
    });

    return jsonResponse({'id': id, 'message': 'Roster request created'}, statusCode: 201);
  }

  Future<Response> approveRosterRequest(Request request) async {
    final id = request.params['id'];
    final db = DatabaseConfig.db;

    final req = db.findOne('roster_requests', where: {'id': id});
    if (req == null) {
      return errorResponse('Request not found', statusCode: 404);
    }

    db.update('roster_requests', {
      'status': 'approved',
      'approved_by': request.context['userId'],
      'approved_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }, where: {'id': id});

    // Auto-apply: update the employee's roster for the requested date
    if (req['requested_date'] != null && req['employee_id'] != null) {
      final existingRoster = db.findOne('rosters', where: {
        'employee_id': req['employee_id'],
        'date': req['requested_date'],
      });
      if (existingRoster != null) {
        final updates = <String, dynamic>{};
        if (req['requested_route_id'] != null) updates['route_id'] = req['requested_route_id'];
        if (req['requested_stop_id'] != null) updates['stop_id'] = req['requested_stop_id'];
        updates['updated_at'] = DateTime.now().toIso8601String();
        db.update('rosters', updates, where: {'id': existingRoster['id']});
      } else {
        db.insert('rosters', {
          'id': 'rost_${DateTime.now().millisecondsSinceEpoch}',
          'employee_id': req['employee_id'],
          'company_id': req['company_id'],
          'date': req['requested_date'],
          'route_id': req['requested_route_id'] ?? '',
          'stop_id': req['requested_stop_id'] ?? '',
          'shift_type': 'morning',
          'status': 'approved',
          'is_active': true,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    }

    return jsonResponse({'message': 'Roster request approved'});
  }

  Future<Response> rejectRosterRequest(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());

    final db = DatabaseConfig.db;
    db.update('roster_requests', {
      'status': 'rejected',
      'rejection_reason': body['reason'],
      'updated_at': DateTime.now().toIso8601String(),
    }, where: {'id': id});

    return jsonResponse({'message': 'Roster request rejected'});
  }
}
