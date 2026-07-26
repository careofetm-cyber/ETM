import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class EnhancedSosRoutes {
  final router = Router();
  
  EnhancedSosRoutes() {
    router.get('/active', authMiddleware(requiredRoles: ['admin', 'manager'])(getActiveSOS));
    router.get('/history', authMiddleware()(getSOSHistory));
    router.post('/', authMiddleware()(sendSOSAlert));
    router.post('/<id>/resolve', authMiddleware(requiredRoles: ['admin', 'manager'])(resolveSOSAlert));
    router.post('/<id>/acknowledge', authMiddleware(requiredRoles: ['admin', 'manager'])(acknowledgeSOS));
    router.get('/stats', authMiddleware(requiredRoles: ['admin', 'manager'])(getSOSStats));
  }
  
  Future<Response> getActiveSOS(Request request) async {
    final companyId = request.context['companyId'] as String?;
    final db = DatabaseConfig.db;
    
    var alerts = db.findAll('sos_alerts', filters: {'company_id': companyId, 'is_resolved': false});
    alerts.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));
    
    final enriched = alerts.map((a) {
      final user = a['user_id'] != null ? db.findOne('users', where: {'id': a['user_id']}) : null;
      final employee = user != null ? db.findOne('employees', where: {'user_id': user['id']}) : null;
      final driver = user != null ? db.findOne('drivers', where: {'user_id': user['id']}) : null;
      return {
        ...a,
        'user_name': user != null ? '${user['first_name']} ${user['last_name']}' : 'Unknown',
        'user_role': user?['role'] ?? a['user_type'],
        'employee_code': employee?['employee_code'],
        'phone': user?['phone'],
        'is_acknowledged': a['is_acknowledged'] ?? false,
      };
    }).toList();
    
    return jsonResponse({'data': enriched, 'total': enriched.length});
  }
  
  Future<Response> getSOSHistory(Request request) async {
    final page = int.tryParse(request.url.queryParameters['page'] ?? '1') ?? 1;
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '20') ?? 20;
    final companyId = request.context['companyId'] as String?;
    
    final db = DatabaseConfig.db;
    var alerts = db.findAll('sos_alerts', filters: {'company_id': companyId});
    alerts.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));
    final total = alerts.length;
    final paginated = alerts.skip((page - 1) * limit).take(limit).toList();
    
    return paginatedResponse(paginated, total, page, limit);
  }
  
  Future<Response> sendSOSAlert(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final userId = request.context['userId'] as String;
    final role = request.context['role'] as String;
    final companyId = request.context['companyId'] as String;
    
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now().toIso8601String();
    final db = DatabaseConfig.db;
    db.insert('sos_alerts', {
      'id': id,
      'user_id': userId,
      'user_type': role,
      'latitude': body['latitude'],
      'longitude': body['longitude'],
      'accuracy': body['accuracy'],
      'message': body['message'] ?? 'Emergency SOS alert',
      'trip_id': body['tripId'],
      'vehicle_id': body['vehicleId'],
      'is_resolved': false,
      'is_acknowledged': false,
      'company_id': companyId,
      'created_at': now,
    });
    
    // Also log the location
    if (body['latitude'] != null && body['longitude'] != null) {
      db.insert('gps_logs', {
        'id': 'gps_sos_$id',
        'vehicle_id': body['vehicleId'],
        'latitude': body['latitude'],
        'longitude': body['longitude'],
        'speed': 0,
        'heading': 0,
        'timestamp': now,
      });
    }
    
    // Create notification for admin/manager
    db.insert('notifications', {
      'id': 'notif_sos_$id',
      'type': 'emergency',
      'title': 'SOS Alert',
      'body': 'Emergency SOS from ${role == "driver" ? "Driver" : "Employee"}',
      'is_read': false,
      'company_id': companyId,
      'metadata': {'sos_id': id, 'user_id': userId},
      'created_at': now,
    });
    
    return jsonResponse({'id': id, 'message': 'SOS alert sent successfully'}, statusCode: 201);
  }
  
  Future<Response> resolveSOSAlert(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    final userId = request.context['userId'] as String;
    
    final db = DatabaseConfig.db;
    db.update('sos_alerts', {
      'is_resolved': true,
      'resolved_by': userId,
      'resolved_at': DateTime.now().toIso8601String(),
      'resolution_notes': body['notes'] ?? '',
    }, where: {'id': id});
    
    return jsonResponse({'message': 'SOS alert resolved'});
  }
  
  Future<Response> acknowledgeSOS(Request request) async {
    final id = request.params['id'];
    final userId = request.context['userId'] as String;
    
    final db = DatabaseConfig.db;
    db.update('sos_alerts', {
      'is_acknowledged': true,
      'acknowledged_by': userId,
      'acknowledged_at': DateTime.now().toIso8601String(),
    }, where: {'id': id});
    
    return jsonResponse({'message': 'SOS alert acknowledged'});
  }
  
  Future<Response> getSOSStats(Request request) async {
    final companyId = request.context['companyId'] as String?;
    final db = DatabaseConfig.db;
    
    final all = db.findAll('sos_alerts', filters: {'company_id': companyId});
    final active = all.where((a) => a['is_resolved'] == false).length;
    final resolved = all.where((a) => a['is_resolved'] == true).length;
    final acknowledged = all.where((a) => a['is_acknowledged'] == true).length;
    
    return jsonResponse({
      'total': all.length,
      'active': active,
      'resolved': resolved,
      'acknowledged': acknowledged,
    });
  }
}
