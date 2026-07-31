import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:bcrypt/bcrypt.dart';
import '../config/database.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class AuthRoutes {
  final router = Router();
  
  AuthRoutes() {
    router.post('/login', _login);
    router.post('/refresh', _refreshToken);
    router.post('/logout', _logout);
    router.get('/profile', authMiddleware()(getProfile));
    router.put('/profile', authMiddleware()(updateProfile));
    router.put('/change-password', authMiddleware()(changePassword));
    router.post('/forgot-password', _forgotPassword);
    router.post('/reset-password', _resetPassword);
  }

  Future<Response> _getCompanyBranding(Request request) async {
    final slug = request.params['slug'];
    if (slug == null || slug.isEmpty) {
      return errorResponse('Company slug is required');
    }

    final db = DatabaseConfig.db;
    final company = db.findOne('companies', where: {'slug': slug});

    if (company == null) {
      return errorResponse('Company not found', statusCode: 404);
    }

    return jsonResponse({
      'id': company['id'],
      'name': company['name'],
      'slug': company['slug'],
      'logo': company['logo'],
      'favicon': company['favicon'],
      'primaryColor': company['primary_color'],
      'backgroundColor': company['background_color'],
    });
  }
  
  Future<Response> _login(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final email = body['email'] as String?;
    final password = body['password'] as String?;
    final deviceToken = body['deviceToken'] as String?;
    
    if (email == null || password == null) {
      return errorResponse('Email and password are required');
    }
    
    final db = DatabaseConfig.db;
    final user = db.findOne('users', where: {'email': email, 'is_active': true});
    
    if (user == null) {
      return errorResponse('Invalid credentials', statusCode: 401);
    }
    
    final passwordHash = user['password_hash'] as String;
    if (!BCrypt.checkpw(password, passwordHash)) {
      return errorResponse('Invalid credentials', statusCode: 401);
    }
    
    final token = generateToken(
      userId: user['id'],
      role: user['role'],
      companyId: user['company_id'],
    );
    
    final refreshToken = generateRefreshToken(
      userId: user['id'],
      role: user['role'],
      companyId: user['company_id'],
    );
    
    if (deviceToken != null) {
      db.update('users', {'device_token': deviceToken}, where: {'id': user['id']});
    }
    
    return jsonResponse({
      'token': token,
      'refreshToken': refreshToken,
      'user': {
        'id': user['id'],
        'email': user['email'],
        'first_name': user['first_name'],
        'last_name': user['last_name'],
        'role': user['role'],
        'is_active': user['is_active'] ?? true,
        'company_id': user['company_id'],
      },
      'expiresAt': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
    });
  }
  
  Future<Response> _refreshToken(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final refreshToken = body['refreshToken'] as String?;
    
    if (refreshToken == null) {
      return errorResponse('Refresh token is required');
    }
    
    try {
      final jwt = JWT.verify(refreshToken, SecretKey('your-refresh-secret-key'));
      final payload = jwt.payload;
      
      final newToken = generateToken(
        userId: payload['userId'],
        role: payload['role'],
        companyId: payload['companyId'],
      );
      
      final newRefreshToken = generateRefreshToken(
        userId: payload['userId'],
        role: payload['role'],
        companyId: payload['companyId'],
      );
      
      return jsonResponse({
        'token': newToken,
        'refreshToken': newRefreshToken,
        'expiresAt': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
      });
    } catch (e) {
      return errorResponse('Invalid refresh token', statusCode: 401);
    }
  }
  
  Future<Response> _logout(Request request) async {
    return jsonResponse({'message': 'Logged out successfully'});
  }
  
  Future<Response> getProfile(Request request) async {
    final userId = request.context['userId'] as String;
    
    final db = DatabaseConfig.db;
    final user = db.findOne('users', where: {'id': userId});
    
    if (user == null) {
      return errorResponse('User not found', statusCode: 404);
    }
    
    final profile = {
      'id': user['id'],
      'email': user['email'],
      'first_name': user['first_name'],
      'last_name': user['last_name'],
      'phone': user['phone'],
      'profile_image': user['profile_image'],
      'role': user['role'],
      'is_active': user['is_active'] ?? true,
      'company_id': user['company_id'],
    };

    if (user['role'] == 'employee') {
      final employee = db.findOne('employees', where: {'user_id': userId});
      if (employee != null) {
        profile['employee_id'] = employee['id'];
        profile['employee_code'] = employee['employee_code'];
        profile['department'] = employee['department'];
        profile['designation'] = employee['designation'];
        profile['home_latitude'] = employee['home_latitude'];
        profile['home_longitude'] = employee['home_longitude'];
        profile['home_address'] = employee['home_address'];
        profile['is_transport_required'] = employee['is_transport_required'];
        profile['assigned_route_id'] = employee['assigned_route_id'];
        profile['assigned_stop_id'] = employee['assigned_stop_id'];
      }
    }

    return jsonResponse(profile);
  }
  
  Future<Response> updateProfile(Request request) async {
    final userId = request.context['userId'] as String;
    final body = jsonDecode(await request.readAsString());
    
    final db = DatabaseConfig.db;
    final updates = <String, dynamic>{};
    if (body['firstName'] != null) updates['first_name'] = body['firstName'];
    if (body['lastName'] != null) updates['last_name'] = body['lastName'];
    if (body['phone'] != null) updates['phone'] = body['phone'];
    if (body['profileImage'] != null) updates['profile_image'] = body['profileImage'];
    if (updates.isNotEmpty) {
      updates['updated_at'] = DateTime.now().toIso8601String();
      db.update('users', updates, where: {'id': userId});
    }
    
    return jsonResponse({'message': 'Profile updated successfully'});
  }
  
  Future<Response> changePassword(Request request) async {
    final userId = request.context['userId'] as String;
    final body = jsonDecode(await request.readAsString());
    final currentPassword = body['currentPassword'] as String;
    final newPassword = body['newPassword'] as String;
    
    final db = DatabaseConfig.db;
    final user = db.findOne('users', where: {'id': userId});
    
    if (user == null || !BCrypt.checkpw(currentPassword, user['password_hash'])) {
      return errorResponse('Current password is incorrect');
    }
    
    final newHash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
    db.update('users', {
      'password_hash': newHash,
      'updated_at': DateTime.now().toIso8601String(),
    }, where: {'id': userId});
    
    return jsonResponse({'message': 'Password changed successfully'});
  }
  
  Future<Response> _forgotPassword(Request request) async {
    return jsonResponse({'message': 'Password reset email sent'});
  }
  
  Future<Response> _resetPassword(Request request) async {
    return jsonResponse({'message': 'Password reset successfully'});
  }
}
