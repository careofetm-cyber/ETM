import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class SettingsRoutes {
  final router = Router();

  SettingsRoutes() {
    router.get('/', authMiddleware(requiredRoles: ['super_admin'])(getSettings));
    router.put('/', authMiddleware(requiredRoles: ['super_admin'])(updateSettings));
    router.get('/company/:companyId', authMiddleware(requiredRoles: ['super_admin', 'admin'])(getCompanySettings));
    router.put('/company/:companyId', authMiddleware(requiredRoles: ['super_admin', 'admin'])(updateCompanySettings));
    router.get('/default-password', authMiddleware(requiredRoles: ['admin', 'super_admin'])(getDefaultPassword));
    router.get('/company', authMiddleware(requiredRoles: ['admin', 'manager', 'transport_manager'])(getMyCompanySettings));
    router.put('/company', authMiddleware(requiredRoles: ['admin', 'manager', 'transport_manager'])(updateMyCompanySettings));
  }

  Future<Response> getSettings(Request request) async {
    final db = DatabaseConfig.db;
    var settings = db.findOne('settings', where: {'id': 'global'});
    if (settings == null) {
      settings = {
        'id': 'global',
        'map_api_key': '',
        'firebase_project_id': '',
        'firebase_api_key': '',
        'sms_gateway': 'twilio',
        'sms_api_key': '',
        'sms_sender_id': '',
        'email_smtp_host': '',
        'email_smtp_port': '587',
        'email_smtp_user': '',
        'email_smtp_pass': '',
        'employee_id_prefix': 'EMP',
        'employee_id_digits': '4',
        'default_password_format': '{prefix}{employeeCode}',
        'min_password_length': '8',
        'require_special_chars': 'true',
        'require_numbers': 'true',
        'created_at': DateTime.now().toIso8601String(),
      };
      db.insert('settings', settings);
    }
    return jsonResponse(settings);
  }

  Future<Response> updateSettings(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final db = DatabaseConfig.db;

    final updates = <String, dynamic>{};
    final allowedKeys = [
      'map_api_key', 'firebase_project_id', 'firebase_api_key',
      'sms_gateway', 'sms_api_key', 'sms_sender_id',
      'email_smtp_host', 'email_smtp_port', 'email_smtp_user', 'email_smtp_pass',
      'employee_id_prefix', 'employee_id_digits', 'default_password_format',
      'min_password_length', 'require_special_chars', 'require_numbers',
    ];
    for (final key in allowedKeys) {
      if (body[key] != null) updates[key] = body[key];
    }
    updates['updated_at'] = DateTime.now().toIso8601String();
    db.update('settings', updates, where: {'id': 'global'});

    final settings = db.findOne('settings', where: {'id': 'global'});
    return jsonResponse(settings!);
  }

  Future<Response> getCompanySettings(Request request) async {
    final companyId = request.params['companyId'];
    final db = DatabaseConfig.db;

    var settings = db.findOne('company_settings', where: {'company_id': companyId});
    if (settings == null) {
      settings = {
        'id': 'cs_${companyId}',
        'company_id': companyId,
        'employee_id_prefix': 'EMP',
        'employee_id_digits': '4',
        'default_password_format': '{prefix}{employeeCode}',
        'min_password_length': '8',
        'require_special_chars': 'true',
        'require_numbers': 'true',
        'home_location_enabled': true,
        'created_at': DateTime.now().toIso8601String(),
      };
      db.insert('company_settings', settings);
    }
    return jsonResponse(settings);
  }

  Future<Response> updateCompanySettings(Request request) async {
    final companyId = request.params['companyId'];
    final body = jsonDecode(await request.readAsString());
    final db = DatabaseConfig.db;

    final updates = <String, dynamic>{};
    final allowedKeys = [
      'employee_id_prefix', 'employee_id_digits', 'default_password_format',
      'min_password_length', 'require_special_chars', 'require_numbers',
      'home_location_enabled',
    ];
    for (final key in allowedKeys) {
      if (body[key] != null) updates[key] = body[key];
    }
    updates['updated_at'] = DateTime.now().toIso8601String();

    final existing = db.findOne('company_settings', where: {'company_id': companyId});
    if (existing != null) {
      db.update('company_settings', updates, where: {'company_id': companyId});
    } else {
      updates['id'] = 'cs_${companyId}';
      updates['company_id'] = companyId;
      updates['created_at'] = DateTime.now().toIso8601String();
      db.insert('company_settings', updates);
    }

    final settings = db.findOne('company_settings', where: {'company_id': companyId});
    return jsonResponse(settings!);
  }

  Future<Response> getDefaultPassword(Request request) async {
    final companyId = request.context['companyId'] as String?;
    final db = DatabaseConfig.db;

    // Check company settings first
    if (companyId != null) {
      final setting = db.findOne('company_settings', where: {'company_id': companyId, 'setting_key': 'default_password'});
      if (setting != null) {
        return jsonResponse({'defaultPassword': setting['setting_value']});
      }
    }

    // Fall back to global settings
    final globalSetting = db.findOne('settings', where: {'id': 'global', 'setting_key': 'default_password'});
    if (globalSetting != null) {
      return jsonResponse({'defaultPassword': globalSetting['setting_value']});
    }

    return jsonResponse({'defaultPassword': 'password123'});
  }

  Future<Response> getMyCompanySettings(Request request) async {
    final companyId = request.context['companyId'] as String?;
    if (companyId == null) return errorResponse('No company', statusCode: 400);
    final db = DatabaseConfig.db;

    var settings = db.findOne('company_settings', where: {'company_id': companyId});
    if (settings == null) {
      settings = {
        'id': 'cs_$companyId',
        'company_id': companyId,
        'home_location_enabled': true,
        'created_at': DateTime.now().toIso8601String(),
      };
      db.insert('company_settings', settings);
    }
    return jsonResponse(settings);
  }

  Future<Response> updateMyCompanySettings(Request request) async {
    final companyId = request.context['companyId'] as String?;
    if (companyId == null) return errorResponse('No company', statusCode: 400);
    final body = jsonDecode(await request.readAsString());
    final db = DatabaseConfig.db;

    final updates = <String, dynamic>{};
    if (body['homeLocationEnabled'] != null) updates['home_location_enabled'] = body['homeLocationEnabled'];
    updates['updated_at'] = DateTime.now().toIso8601String();

    final existing = db.findOne('company_settings', where: {'company_id': companyId});
    if (existing != null) {
      db.update('company_settings', updates, where: {'company_id': companyId});
    } else {
      updates['id'] = 'cs_$companyId';
      updates['company_id'] = companyId;
      updates['created_at'] = DateTime.now().toIso8601String();
      db.insert('company_settings', updates);
    }

    final settings = db.findOne('company_settings', where: {'company_id': companyId});
    return jsonResponse(settings!);
  }
}
