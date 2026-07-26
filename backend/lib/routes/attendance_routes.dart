import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class AttendanceRoutes {
  final router = Router();
  
  AttendanceRoutes() {
    router.get('/', authMiddleware()(getAttendance));
    router.post('/check-in', authMiddleware()(checkIn));
    router.post('/check-out', authMiddleware()(checkOut));
    router.get('/transport-requests', authMiddleware()(getTransportRequests));
    router.post('/transport-requests', authMiddleware()(createTransportRequest));
    router.post('/transport-requests/<id>/approve', authMiddleware(requiredRoles: ['admin', 'manager'])(approveRequest));
    router.post('/transport-requests/<id>/reject', authMiddleware(requiredRoles: ['admin', 'manager'])(rejectRequest));
  }
  
  Future<Response> getAttendance(Request request) async {
    final page = int.tryParse(request.url.queryParameters['page'] ?? '1') ?? 1;
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '20') ?? 20;
    final employeeId = request.url.queryParameters['employeeId'];
    final date = request.url.queryParameters['date'];
    final status = request.url.queryParameters['status'];
    final companyId = request.context['companyId'] as String?;
    
    final db = DatabaseConfig.db;
    final filters = <String, dynamic>{'company_id': companyId};
    if (employeeId != null) filters['employee_id'] = employeeId;
    if (status != null) filters['status'] = status;
    
    var allRecords = db.findAll('attendance', filters: filters);
    if (date != null) {
      allRecords = allRecords.where((r) => r['date']?.toString().startsWith(date) == true).toList();
    }
    
    final total = allRecords.length;
    allRecords.sort((a, b) => (b['date'] ?? '').toString().compareTo((a['date'] ?? '').toString()));
    final paginated = allRecords.skip((page - 1) * limit).take(limit).toList();
    
    return paginatedResponse(paginated, total, page, limit);
  }
  
  Future<Response> checkIn(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final employeeId = body['employeeId'] as String;
    final method = body['method'] as String? ?? 'manual';
    final tripId = body['tripId'] as String?;
    final companyId = request.context['companyId'] as String?;
    
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now().toIso8601String();
    final db = DatabaseConfig.db;
    db.insert('attendance', {
      'id': id,
      'employee_id': employeeId,
      'date': now,
      'status': 'present',
      'trip_id': tripId,
      'boarding_method': method,
      'check_in_time': now,
      'company_id': companyId,
      'created_at': now,
    });
    
    return jsonResponse({'id': id, 'message': 'Checked in successfully'});
  }
  
  Future<Response> checkOut(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final employeeId = body['employeeId'] as String;
    
    final db = DatabaseConfig.db;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final records = db.findAll('attendance', filters: {'employee_id': employeeId});
    final todayRecords = records.where((r) => r['date']?.toString().startsWith(today) == true).toList();
    
    if (todayRecords.isNotEmpty) {
      db.update('attendance', {
        'check_out_time': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }, where: {'id': todayRecords.first['id']});
    }
    
    return jsonResponse({'message': 'Checked out successfully'});
  }
  
  Future<Response> getTransportRequests(Request request) async {
    final page = int.tryParse(request.url.queryParameters['page'] ?? '1') ?? 1;
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '20') ?? 20;
    final status = request.url.queryParameters['status'];
    final companyId = request.context['companyId'] as String?;
    
    final db = DatabaseConfig.db;
    final filters = <String, dynamic>{'company_id': companyId};
    if (status != null) filters['status'] = status;
    
    var allRequests = db.findAll('transport_requests', filters: filters);
    final total = allRequests.length;
    allRequests.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));
    final paginated = allRequests.skip((page - 1) * limit).take(limit).toList();
    
    return paginatedResponse(paginated, total, page, limit);
  }
  
  Future<Response> createTransportRequest(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now().toIso8601String();
    final db = DatabaseConfig.db;
    db.insert('transport_requests', {
      'id': id,
      'employee_id': body['employeeId'],
      'company_id': companyId,
      'type': body['type'],
      'status': 'pending',
      'route_id': body['routeId'],
      'stop_id': body['stopId'],
      'effective_from': body['effectiveFrom'],
      'effective_to': body['effectiveTo'],
      'reason': body['reason'],
      'created_at': now,
    });
    
    return jsonResponse({'id': id, 'message': 'Transport request created successfully'}, statusCode: 201);
  }
  
  Future<Response> approveRequest(Request request) async {
    final id = request.params['id'];
    final db = DatabaseConfig.db;
    
    final req = db.findOne('transport_requests', where: {'id': id});
    if (req == null) {
      return jsonResponse({'error': 'Request not found'}, statusCode: 404);
    }
    
    db.update('transport_requests', {
      'status': 'approved',
      'approved_by': request.context['userId'],
      'approved_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }, where: {'id': id});
    
    // Auto-apply: update employee's assigned route/stop
    if (req['employee_id'] != null && req['type'] == 'routeChange' && req['route_id'] != null) {
      final employee = db.findOne('employees', where: {'id': req['employee_id']});
      if (employee != null) {
        db.update('employees', {
          'assigned_route_id': req['route_id'],
          'assigned_stop_id': req['stop_id'] ?? employee['assigned_stop_id'],
          'updated_at': DateTime.now().toIso8601String(),
        }, where: {'id': req['employee_id']});
      }
    }
    if (req['employee_id'] != null && req['type'] == 'stopChange' && req['stop_id'] != null) {
      final employee = db.findOne('employees', where: {'id': req['employee_id']});
      if (employee != null) {
        db.update('employees', {
          'assigned_stop_id': req['stop_id'],
          'updated_at': DateTime.now().toIso8601String(),
        }, where: {'id': req['employee_id']});
      }
    }
    
    // Create notification for the employee
    if (req['employee_id'] != null) {
      final employee = db.findOne('employees', where: {'id': req['employee_id']});
      final user = employee != null ? db.findOne('users', where: {'id': employee['user_id']}) : null;
      if (user != null) {
        db.insert('notifications', {
          'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
          'user_id': user['id'],
          'type': 'system',
          'title': 'Transport Request Approved',
          'body': 'Your ${req['type']} request has been approved.',
          'is_read': false,
          'company_id': req['company_id'],
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    }
    
    return jsonResponse({'message': 'Request approved and changes applied'});
  }
  
  Future<Response> rejectRequest(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    
    final db = DatabaseConfig.db;
    db.update('transport_requests', {
      'status': 'rejected',
      'rejection_reason': body['reason'],
      'updated_at': DateTime.now().toIso8601String(),
    }, where: {'id': id});
    
    return jsonResponse({'message': 'Request rejected successfully'});
  }
}
