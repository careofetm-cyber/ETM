import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class HcmRoutes {
  final router = Router();
  
  HcmRoutes() {
    router.get('/configs', authMiddleware(requiredRoles: ['admin'])(getHcmConfigs));
    router.post('/configs', authMiddleware(requiredRoles: ['admin'])(createHcmConfig));
    router.put('/configs/<id>', authMiddleware(requiredRoles: ['admin'])(updateHcmConfig));
    router.delete('/configs/<id>', authMiddleware(requiredRoles: ['admin'])(deleteHcmConfig));
    router.post('/sync/employees', authMiddleware(requiredRoles: ['admin'])(syncEmployees));
    router.post('/sync/attendance', authMiddleware(requiredRoles: ['admin'])(syncAttendance));
    router.get('/sync/status', authMiddleware(requiredRoles: ['admin'])(getSyncStatus));
    router.post('/webhook/<provider>', handleWebhook);
  }
  
  Future<Response> getHcmConfigs(Request request) async {
    final companyId = request.context['companyId'] as String?;
    final db = DatabaseConfig.db;
    final configs = db.findAll('hcm_configs', filters: {'company_id': companyId});
    return jsonResponse({'data': configs});
  }
  
  Future<Response> createHcmConfig(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now().toIso8601String();
    final db = DatabaseConfig.db;
    db.insert('hcm_configs', {
      'id': id,
      'company_id': companyId,
      'provider': body['provider'],
      'api_endpoint': body['apiEndpoint'],
      'api_key': body['apiKey'],
      'sync_employees': body['syncEmployees'] ?? true,
      'sync_attendance': body['syncAttendance'] ?? false,
      'sync_interval_hours': body['syncIntervalHours'] ?? 24,
      'is_active': true,
      'last_sync_at': null,
      'created_at': now,
    });
    
    return jsonResponse({'id': id, 'message': 'HCM config created'}, statusCode: 201);
  }
  
  Future<Response> updateHcmConfig(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    
    final db = DatabaseConfig.db;
    final updates = <String, dynamic>{};
    if (body['apiEndpoint'] != null) updates['api_endpoint'] = body['apiEndpoint'];
    if (body['apiKey'] != null) updates['api_key'] = body['apiKey'];
    if (body['syncEmployees'] != null) updates['sync_employees'] = body['syncEmployees'];
    if (body['syncAttendance'] != null) updates['sync_attendance'] = body['syncAttendance'];
    if (body['syncIntervalHours'] != null) updates['sync_interval_hours'] = body['syncIntervalHours'];
    if (body['isActive'] != null) updates['is_active'] = body['isActive'];
    if (updates.isNotEmpty) {
      updates['updated_at'] = DateTime.now().toIso8601String();
      db.update('hcm_configs', updates, where: {'id': id});
    }
    
    return jsonResponse({'message': 'HCM config updated'});
  }
  
  Future<Response> deleteHcmConfig(Request request) async {
    final id = request.params['id'];
    final db = DatabaseConfig.db;
    db.delete('hcm_configs', where: {'id': id});
    return jsonResponse({'message': 'HCM config deleted'});
  }
  
  Future<Response> syncEmployees(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    final configId = body['configId'];
    
    final db = DatabaseConfig.db;
    final config = db.findOne('hcm_configs', where: {'id': configId});
    if (config == null) {
      return errorResponse('HCM config not found', statusCode: 404);
    }
    
    // Stub: In production, this would call the HCM provider's API
    // For Workday: GET /api/v1/workers?active=true
    // For SAP SuccessFactors: GET /odata/v2/PerPerson
    // For ADP: GET /hr/v2/workers
    
    final now = DateTime.now().toIso8601String();
    db.update('hcm_configs', {'last_sync_at': now}, where: {'id': configId});
    
    return jsonResponse({
      'message': 'Employee sync initiated from ${config['provider']}',
      'status': 'in_progress',
      'provider': config['provider'],
      'note': 'This is a stub. In production, this would pull employee data from ${config['provider']} API.',
    });
  }
  
  Future<Response> syncAttendance(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    final configId = body['configId'];
    
    final db = DatabaseConfig.db;
    final config = db.findOne('hcm_configs', where: {'id': configId});
    if (config == null) {
      return errorResponse('HCM config not found', statusCode: 404);
    }
    
    final now = DateTime.now().toIso8601String();
    db.update('hcm_configs', {'last_sync_at': now}, where: {'id': configId});
    
    return jsonResponse({
      'message': 'Attendance sync initiated from ${config['provider']}',
      'status': 'in_progress',
      'provider': config['provider'],
      'note': 'This is a stub. In production, this would sync attendance data from ${config['provider']} API.',
    });
  }
  
  Future<Response> getSyncStatus(Request request) async {
    final companyId = request.context['companyId'] as String?;
    final db = DatabaseConfig.db;
    final configs = db.findAll('hcm_configs', filters: {'company_id': companyId});
    
    final statuses = configs.map((c) => {
      'id': c['id'],
      'provider': c['provider'],
      'isActive': c['is_active'],
      'lastSyncAt': c['last_sync_at'],
      'syncEmployees': c['sync_employees'],
      'syncAttendance': c['sync_attendance'],
    }).toList();
    
    return jsonResponse({'data': statuses});
  }
  
  Future<Response> handleWebhook(Request request, String provider) async {
    final body = jsonDecode(await request.readAsString());
    final db = DatabaseConfig.db;
    final now = DateTime.now().toIso8601String();
    
    // Log webhook event
    db.insert('notifications', {
      'id': 'notif_hcm_${DateTime.now().millisecondsSinceEpoch}',
      'type': 'system',
      'title': 'HCM Webhook Received',
      'body': 'Webhook from $provider: ${body['event'] ?? 'unknown event'}',
      'is_read': false,
      'metadata': {'provider': provider, 'event': body['event']},
      'created_at': now,
    });
    
    return jsonResponse({'message': 'Webhook processed'});
  }
}
