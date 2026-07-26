import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class NcnsRoutes {
  final router = Router();
  
  NcnsRoutes() {
    router.get('/', authMiddleware()(getNcnsLog));
    router.get('/employee/<employeeId>', authMiddleware()(getEmployeeNcns));
    router.post('/mark', authMiddleware(requiredRoles: ['admin', 'manager'])(markNcns));
    router.get('/settings', authMiddleware(requiredRoles: ['admin'])(getNcnsSettings));
    router.put('/settings', authMiddleware(requiredRoles: ['admin'])(updateNcnsSettings));
  }
  
  Future<Response> getNcnsLog(Request request) async {
    final page = int.tryParse(request.url.queryParameters['page'] ?? '1') ?? 1;
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '20') ?? 20;
    final companyId = request.context['companyId'] as String?;
    
    final db = DatabaseConfig.db;
    var logs = db.findAll('ncns_log', filters: {'company_id': companyId});
    logs.sort((a, b) => (b['date'] ?? '').toString().compareTo((a['date'] ?? '').toString()));
    final total = logs.length;
    final paginated = logs.skip((page - 1) * limit).take(limit).toList();
    
    return paginatedResponse(paginated, total, page, limit);
  }
  
  Future<Response> getEmployeeNcns(Request request) async {
    final employeeId = request.params['employeeId'];
    final db = DatabaseConfig.db;
    final logs = db.findAll('ncns_log', filters: {'employee_id': employeeId});
    logs.sort((a, b) => (b['date'] ?? '').toString().compareTo((a['date'] ?? '').toString()));
    return jsonResponse({'data': logs, 'total': logs.length});
  }
  
  Future<Response> markNcns(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now().toIso8601String();
    final db = DatabaseConfig.db;
    db.insert('ncns_log', {
      'id': id,
      'employee_id': body['employeeId'],
      'company_id': companyId,
      'date': body['date'] ?? now.substring(0, 10),
      'reason': body['reason'] ?? 'No call no show',
      'marked_by': request.context['userId'],
      'created_at': now,
    });
    
    // Check if employee has exceeded NCNS threshold
    final employeeId = body['employeeId'];
    final ncnsCount = db.findAll('ncns_log', filters: {'employee_id': employeeId}).length;
    
    // Check company settings for threshold
    final settings = db.findOne('company_settings', where: {'company_id': companyId, 'setting_key': 'ncns_threshold'});
    final threshold = int.tryParse(settings?['setting_value']?.toString() ?? '3') ?? 3;
    
    if (ncnsCount >= threshold) {
      // Auto-disable employee transport
      final employee = db.findOne('employees', where: {'id': employeeId});
      if (employee != null) {
        db.update('employees', {
          'is_transport_required': false,
          'transport_disabled_reason': 'NCNS threshold exceeded ($ncnsCount occurrences)',
          'transport_disabled_at': now,
          'updated_at': now,
        }, where: {'id': employeeId});
        
        // Also deactivate associated user
        if (employee['user_id'] != null) {
          db.update('users', {
            'is_active': false,
            'deactivation_reason': 'NCNS threshold exceeded',
            'updated_at': now,
          }, where: {'id': employee['user_id']});
        }
      }
      
      return jsonResponse({
        'message': 'NCNS marked and employee transport disabled (threshold: $threshold)',
        'ncnsCount': ncnsCount,
        'transportDisabled': true,
      });
    }
    
    return jsonResponse({
      'message': 'NCNS marked successfully',
      'ncnsCount': ncnsCount,
      'threshold': threshold,
      'transportDisabled': false,
    });
  }
  
  Future<Response> getNcnsSettings(Request request) async {
    final companyId = request.context['companyId'] as String?;
    final db = DatabaseConfig.db;
    
    final threshold = db.findOne('company_settings', where: {'company_id': companyId, 'setting_key': 'ncns_threshold'});
    final autoDisable = db.findOne('company_settings', where: {'company_id': companyId, 'setting_key': 'ncns_auto_disable'});
    
    return jsonResponse({
      'ncnsThreshold': int.tryParse(threshold?['setting_value']?.toString() ?? '3') ?? 3,
      'autoDisable': autoDisable?['setting_value']?.toString() == 'true',
    });
  }
  
  Future<Response> updateNcnsSettings(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    final db = DatabaseConfig.db;
    final now = DateTime.now().toIso8601String();
    
    if (body['ncnsThreshold'] != null) {
      final existing = db.findOne('company_settings', where: {'company_id': companyId, 'setting_key': 'ncns_threshold'});
      if (existing != null) {
        db.update('company_settings', {'setting_value': body['ncnsThreshold'].toString(), 'updated_at': now},
            where: {'id': existing['id']});
      } else {
        db.insert('company_settings', {
          'id': 'cset_${DateTime.now().millisecondsSinceEpoch}',
          'company_id': companyId,
          'setting_key': 'ncns_threshold',
          'setting_value': body['ncnsThreshold'].toString(),
          'created_at': now,
        });
      }
    }
    
    if (body['autoDisable'] != null) {
      final existing = db.findOne('company_settings', where: {'company_id': companyId, 'setting_key': 'ncns_auto_disable'});
      if (existing != null) {
        db.update('company_settings', {'setting_value': body['autoDisable'].toString(), 'updated_at': now},
            where: {'id': existing['id']});
      } else {
        db.insert('company_settings', {
          'id': 'cset_${DateTime.now().millisecondsSinceEpoch + 1}',
          'company_id': companyId,
          'setting_key': 'ncns_auto_disable',
          'setting_value': body['autoDisable'].toString(),
          'created_at': now,
        });
      }
    }
    
    return jsonResponse({'message': 'NCNS settings updated'});
  }
}
