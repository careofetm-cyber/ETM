import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class UserManagementRoutes {
  final router = Router();

  UserManagementRoutes() {
    router.get('/', authMiddleware(requiredRoles: ['super_admin', 'admin'])(getUsers));
    router.post('/', authMiddleware(requiredRoles: ['super_admin', 'admin'])(createUser));
    router.post('/<id>/reset-password', authMiddleware(requiredRoles: ['super_admin', 'admin'])(resetPassword));
    router.put('/<id>', authMiddleware(requiredRoles: ['super_admin', 'admin'])(updateUser));
    router.delete('/<id>', authMiddleware(requiredRoles: ['super_admin', 'admin'])(deleteUser));
  }

  Future<Response> getUsers(Request request) async {
    final companyId = request.context['companyId'] as String?;
    final role = request.context['role'] as String;
    final db = DatabaseConfig.db;

    List<Map<String, dynamic>> users;
    if (role == 'super_admin') {
      users = db.findAll('users');
    } else {
      users = db.findAll('users', filters: {'company_id': companyId});
    }

    final enriched = users.map((u) => {
      'id': u['id'],
      'email': u['email'],
      'firstName': u['first_name'],
      'lastName': u['last_name'],
      'phone': u['phone'],
      'role': u['role'],
      'isActive': u['is_active'],
      'companyId': u['company_id'],
      'createdAt': u['created_at'],
    }).toList();

    return jsonResponse({'data': enriched, 'total': enriched.length});
  }

  Future<Response> createUser(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    final db = DatabaseConfig.db;

    final email = body['email'] as String?;
    final firstName = body['firstName'] as String?;
    final lastName = body['lastName'] as String?;
    final role = body['role'] as String? ?? 'employee';
    final password = body['password'] as String? ?? 'password123';

    if (email == null || email.isEmpty || firstName == null || firstName.isEmpty) {
      return errorResponse('Email and first name are required');
    }

    final existing = db.findOne('users', where: {'email': email});
    if (existing != null) {
      return errorResponse('Email already exists', statusCode: 409);
    }

    final userId = 'usr_${DateTime.now().millisecondsSinceEpoch}';
    final passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());

    db.insert('users', {
      'id': userId,
      'email': email,
      'first_name': firstName,
      'last_name': lastName ?? '',
      'phone': body['phone'] ?? '',
      'password_hash': passwordHash,
      'role': role,
      'company_id': companyId,
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
    });

    if (role == 'employee') {
      db.insert('employees', {
        'id': '${userId}_emp',
        'user_id': userId,
        'company_id': companyId,
        'employee_code': body['employeeCode'] ?? '',
        'department': body['department'] ?? '',
        'designation': body['designation'] ?? '',
        'is_transport_required': body['isTransportRequired'] ?? true,
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
      });
    } else if (role == 'driver') {
      db.insert('drivers', {
        'id': '${userId}_drv',
        'user_id': userId,
        'company_id': companyId,
        'license_number': body['licenseNumber'] ?? '',
        'license_expiry': body['licenseExpiry'] ?? '',
        'phone': body['phone'] ?? '',
        'is_available': true,
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    // Send notification with credentials
    db.insert('notifications', {
      'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
      'user_id': userId,
      'type': 'system',
      'title': 'Welcome to ETM',
      'body': 'Your account has been created. Email: $email, Temporary Password: $password. Please login and change your password.',
      'is_read': false,
      'company_id': companyId,
      'created_at': DateTime.now().toIso8601String(),
    });

    return jsonResponse({
      'id': userId,
      'message': '$role created successfully',
      'tempPassword': role != 'super_admin' ? password : null,
    }, statusCode: 201);
  }

  Future<Response> updateUser(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    final db = DatabaseConfig.db;

    final existing = db.findOne('users', where: {'id': id});
    if (existing == null) {
      return errorResponse('User not found', statusCode: 404);
    }

    final updates = <String, dynamic>{};
    if (body['firstName'] != null) updates['first_name'] = body['firstName'];
    if (body['lastName'] != null) updates['last_name'] = body['lastName'];
    if (body['phone'] != null) updates['phone'] = body['phone'];
    if (body['role'] != null) updates['role'] = body['role'];
    if (body['isActive'] != null) updates['is_active'] = body['isActive'];
    updates['updated_at'] = DateTime.now().toIso8601String();

    db.update('users', updates, where: {'id': id});
    return jsonResponse({'message': 'User updated successfully'});
  }

  Future<Response> deleteUser(Request request) async {
    final id = request.params['id'];
    final db = DatabaseConfig.db;

    final existing = db.findOne('users', where: {'id': id});
    if (existing == null) {
      return errorResponse('User not found', statusCode: 404);
    }

    db.update('users', {
      'is_active': false,
      'updated_at': DateTime.now().toIso8601String(),
    }, where: {'id': id});

    return jsonResponse({'message': 'User deactivated successfully'});
  }

  Future<Response> resetPassword(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    final db = DatabaseConfig.db;
    final newPassword = body['newPassword'] as String? ?? 'password123';

    final existing = db.findOne('users', where: {'id': id});
    if (existing == null) {
      return errorResponse('User not found', statusCode: 404);
    }

    final newHash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
    db.update('users', {
      'password_hash': newHash,
      'must_change_password': true,
      'updated_at': DateTime.now().toIso8601String(),
    }, where: {'id': id});

    // Notify the user
    db.insert('notifications', {
      'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
      'user_id': id,
      'type': 'system',
      'title': 'Password Reset',
      'body': 'Your password has been reset by an administrator. Please login and change your password.',
      'is_read': false,
      'company_id': existing['company_id'],
      'created_at': DateTime.now().toIso8601String(),
    });

    return jsonResponse({'message': 'Password reset successfully', 'newPassword': newPassword});
  }
}
