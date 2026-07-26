import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class BulkUploadRoutes {
  final router = Router();

  BulkUploadRoutes() {
    router.post('/employees', authMiddleware(requiredRoles: ['super_admin', 'admin'])(bulkUploadEmployees));
    router.post('/users', authMiddleware(requiredRoles: ['super_admin', 'admin'])(bulkUploadUsers));
  }

  Future<Response> bulkUploadEmployees(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    final employees = body['employees'] as List;
    final db = DatabaseConfig.db;

    final results = <Map<String, dynamic>>[];
    int successCount = 0;
    int errorCount = 0;

    for (final emp in employees) {
      try {
        final userId = 'usr_${DateTime.now().millisecondsSinceEpoch}';
        final empId = 'emp_${DateTime.now().millisecondsSinceEpoch}';
        final email = emp['email'] as String? ?? '';
        final firstName = emp['firstName'] as String? ?? '';
        final lastName = emp['lastName'] as String? ?? '';
        final phone = emp['phone'] as String? ?? '';
        final department = emp['department'] as String? ?? '';
        final designation = emp['designation'] as String? ?? '';
        final employeeCode = emp['employeeCode'] as String? ?? '';

        if (email.isEmpty || firstName.isEmpty) {
          results.add({'email': email, 'status': 'error', 'message': 'Email and name required'});
          errorCount++;
          continue;
        }

        final existing = db.findOne('users', where: {'email': email});
        if (existing != null) {
          results.add({'email': email, 'status': 'error', 'message': 'Email already exists'});
          errorCount++;
          continue;
        }

        final passwordHash = r'$2a$10$placeholder';
        db.insert('users', {
          'id': userId,
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'password_hash': passwordHash,
          'role': 'employee',
          'company_id': companyId,
          'is_active': true,
          'created_at': DateTime.now().toIso8601String(),
        });

        db.insert('employees', {
          'id': empId,
          'user_id': userId,
          'company_id': companyId,
          'employee_code': employeeCode,
          'department': department,
          'designation': designation,
          'phone': phone,
          'is_transport_required': emp['isTransportRequired'] ?? true,
          'is_active': true,
          'created_at': DateTime.now().toIso8601String(),
        });

        results.add({'email': email, 'status': 'success', 'message': 'Created successfully'});
        successCount++;
      } catch (e) {
        results.add({'email': emp['email'] ?? '', 'status': 'error', 'message': e.toString()});
        errorCount++;
      }
    }

    return jsonResponse({
      'message': 'Bulk upload complete',
      'successCount': successCount,
      'errorCount': errorCount,
      'total': employees.length,
      'results': results,
    });
  }

  Future<Response> bulkUploadUsers(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    final users = body['users'] as List;
    final db = DatabaseConfig.db;

    final results = <Map<String, dynamic>>[];
    int successCount = 0;
    int errorCount = 0;

    for (final u in users) {
      try {
        final userId = 'usr_${DateTime.now().millisecondsSinceEpoch}';
        final email = u['email'] as String? ?? '';
        final firstName = u['firstName'] as String? ?? '';
        final lastName = u['lastName'] as String? ?? '';
        final role = u['role'] as String? ?? 'employee';

        if (email.isEmpty || firstName.isEmpty) {
          results.add({'email': email, 'status': 'error', 'message': 'Email and name required'});
          errorCount++;
          continue;
        }

        final existing = db.findOne('users', where: {'email': email});
        if (existing != null) {
          results.add({'email': email, 'status': 'error', 'message': 'Email already exists'});
          errorCount++;
          continue;
        }

        db.insert('users', {
          'id': userId,
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'phone': u['phone'] ?? '',
          'password_hash': r'$2a$10$placeholder',
          'role': role,
          'company_id': companyId,
          'is_active': true,
          'created_at': DateTime.now().toIso8601String(),
        });

        results.add({'email': email, 'status': 'success', 'message': 'Created as $role'});
        successCount++;
      } catch (e) {
        results.add({'email': u['email'] ?? '', 'status': 'error', 'message': e.toString()});
        errorCount++;
      }
    }

    return jsonResponse({
      'message': 'Bulk upload complete',
      'successCount': successCount,
      'errorCount': errorCount,
      'total': users.length,
      'results': results,
    });
  }
}
