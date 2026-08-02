import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:bcrypt/bcrypt.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class EmployeeRoutes {
  final router = Router();
  
  EmployeeRoutes() {
    router.get('/', authMiddleware()(getEmployees));
    router.put('/user/:userId/location', authMiddleware(requiredRoles: ['employee'])(updateEmployeeLocation));
    router.get('/<id>', authMiddleware()(getEmployee));
    router.post('/', authMiddleware(requiredRoles: ['admin', 'manager', 'transport_manager', 'hr'])(createEmployee));
    router.put('/<id>', authMiddleware(requiredRoles: ['admin', 'manager', 'transport_manager', 'hr'])(updateEmployee));
    router.delete('/<id>', authMiddleware(requiredRoles: ['admin'])(deleteEmployee));
    router.get('/drivers', authMiddleware(requiredRoles: ['admin', 'manager', 'transport_manager'])(getDrivers));
    router.get('/drivers/<id>', authMiddleware()(getDriver));
    router.post('/drivers', authMiddleware(requiredRoles: ['admin', 'manager', 'transport_manager'])(createDriver));
    router.put('/drivers/<id>', authMiddleware(requiredRoles: ['admin', 'manager', 'transport_manager'])(updateDriver));
    router.delete('/drivers/<id>', authMiddleware(requiredRoles: ['admin'])(deleteDriver));
  }
  
  Future<Response> getEmployees(Request request) async {
    final page = int.tryParse(request.url.queryParameters['page'] ?? '1') ?? 1;
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '20') ?? 20;
    final search = request.url.queryParameters['search'];
    final companyId = request.context['companyId'] as String?;
    
    final db = DatabaseConfig.db;
    var allEmployees = db.findAll('employees', filters: {'company_id': companyId});
    var results = allEmployees.map((e) {
      final user = db.findOne('users', where: {'id': e['user_id']});
      return {
        ...e,
        'email': user?['email'],
        'first_name': user?['first_name'],
        'last_name': user?['last_name'],
        'phone': user?['phone'],
        'is_active': user?['is_active'],
      };
    }).toList();
    
    if (search != null) {
      final s = search.toLowerCase();
      results = results.where((r) =>
        (r['first_name']?.toString().toLowerCase().contains(s) == true) ||
        (r['last_name']?.toString().toLowerCase().contains(s) == true) ||
        (r['employee_code']?.toString().toLowerCase().contains(s) == true) ||
        (r['email']?.toString().toLowerCase().contains(s) == true)
      ).toList();
    }
    
    final total = results.length;
    results.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));
    final paginated = results.skip((page - 1) * limit).take(limit).toList();
    
    return paginatedResponse(paginated, total, page, limit);
  }
  
  Future<Response> getEmployee(Request request) async {
    final id = request.params['id'];
    final db = DatabaseConfig.db;
    final employee = db.findOne('employees', where: {'id': id});
    
    if (employee == null) {
      return errorResponse('Employee not found', statusCode: 404);
    }
    
    final user = db.findOne('users', where: {'id': employee['user_id']});
    return jsonResponse({
      ...employee,
      'email': user?['email'],
      'first_name': user?['first_name'],
      'last_name': user?['last_name'],
      'phone': user?['phone'],
      'is_active': user?['is_active'],
    });
  }
  
  Future<Response> createEmployee(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    
    final db = DatabaseConfig.db;
    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    final passwordHash = BCrypt.hashpw(body['password'] ?? 'default123', BCrypt.gensalt());
    final now = DateTime.now().toIso8601String();
    
    db.insert('users', {
      'id': userId,
      'email': body['email'],
      'first_name': body['firstName'],
      'last_name': body['lastName'],
      'phone': body['phone'],
      'password_hash': passwordHash,
      'role': 'employee',
      'company_id': companyId,
      'is_active': true,
      'created_at': now,
    });
    
    final employeeId = '${userId}_emp';
    db.insert('employees', {
      'id': employeeId,
      'user_id': userId,
      'company_id': companyId,
      'employee_code': body['employeeCode'],
      'department': body['department'],
      'designation': body['designation'],
      'home_latitude': body['homeLatitude'],
      'home_longitude': body['homeLongitude'],
      'home_address': body['homeAddress'],
      'is_transport_required': body['isTransportRequired'] ?? true,
      'created_at': now,
    });
    
    return jsonResponse({'id': employeeId, 'userId': userId, 'message': 'Employee created successfully'}, statusCode: 201);
  }
  
  Future<Response> updateEmployee(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    
    final db = DatabaseConfig.db;
    final updates = <String, dynamic>{};
    if (body['employeeCode'] != null) updates['employee_code'] = body['employeeCode'];
    if (body['department'] != null) updates['department'] = body['department'];
    if (body['designation'] != null) updates['designation'] = body['designation'];
    if (body['homeLatitude'] != null) updates['home_latitude'] = body['homeLatitude'];
    if (body['homeLongitude'] != null) updates['home_longitude'] = body['homeLongitude'];
    if (body['homeAddress'] != null) updates['home_address'] = body['homeAddress'];
    if (body['isTransportRequired'] != null) updates['is_transport_required'] = body['isTransportRequired'];
    if (updates.isNotEmpty) {
      updates['updated_at'] = DateTime.now().toIso8601String();
      db.update('employees', updates, where: {'id': id});
    }
    
    return jsonResponse({'message': 'Employee updated successfully'});
  }
  
  Future<Response> deleteEmployee(Request request) async {
    final id = request.params['id'];
    
    final db = DatabaseConfig.db;
    db.update('employees', {
      'is_active': false,
      'updated_at': DateTime.now().toIso8601String(),
    }, where: {'id': id});
    
    return jsonResponse({'message': 'Employee deleted successfully'});
  }
  
  Future<Response> getDrivers(Request request) async {
    final page = int.tryParse(request.url.queryParameters['page'] ?? '1') ?? 1;
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '20') ?? 20;
    final search = request.url.queryParameters['search'];
    final companyId = request.context['companyId'] as String?;
    
    final db = DatabaseConfig.db;
    var allDrivers = db.findAll('drivers', filters: {'company_id': companyId});
    var results = allDrivers.map((d) {
      final user = db.findOne('users', where: {'id': d['user_id']});
      return {
        ...d,
        'email': user?['email'],
        'first_name': user?['first_name'],
        'last_name': user?['last_name'],
        'phone': user?['phone'],
        'is_active': user?['is_active'],
      };
    }).toList();
    
    if (search != null) {
      final s = search.toLowerCase();
      results = results.where((r) =>
        (r['first_name']?.toString().toLowerCase().contains(s) == true) ||
        (r['last_name']?.toString().toLowerCase().contains(s) == true) ||
        (r['license_number']?.toString().toLowerCase().contains(s) == true) ||
        (r['email']?.toString().toLowerCase().contains(s) == true)
      ).toList();
    }
    
    final total = results.length;
    results.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));
    final paginated = results.skip((page - 1) * limit).take(limit).toList();
    
    return paginatedResponse(paginated, total, page, limit);
  }
  
  Future<Response> getDriver(Request request) async {
    final id = request.params['id'];
    final db = DatabaseConfig.db;
    final driver = db.findOne('drivers', where: {'id': id});
    
    if (driver == null) {
      return errorResponse('Driver not found', statusCode: 404);
    }
    
    final user = db.findOne('users', where: {'id': driver['user_id']});
    return jsonResponse({
      ...driver,
      'email': user?['email'],
      'first_name': user?['first_name'],
      'last_name': user?['last_name'],
      'phone': user?['phone'],
      'is_active': user?['is_active'],
    });
  }
  
  Future<Response> createDriver(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    
    final db = DatabaseConfig.db;
    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    final passwordHash = BCrypt.hashpw(body['password'] ?? 'default123', BCrypt.gensalt());
    final now = DateTime.now().toIso8601String();
    
    db.insert('users', {
      'id': userId,
      'email': body['email'],
      'first_name': body['firstName'],
      'last_name': body['lastName'],
      'phone': body['phone'],
      'password_hash': passwordHash,
      'role': 'driver',
      'company_id': companyId,
      'is_active': true,
      'created_at': now,
    });
    
    final driverId = '${userId}_drv';
    db.insert('drivers', {
      'id': driverId,
      'user_id': userId,
      'company_id': companyId,
      'license_number': body['licenseNumber'],
      'license_expiry': body['licenseExpiry'],
      'is_available': true,
      'created_at': now,
    });
    
    return jsonResponse({'id': driverId, 'userId': userId, 'message': 'Driver created successfully'}, statusCode: 201);
  }
  
  Future<Response> updateDriver(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    
    final db = DatabaseConfig.db;
    final updates = <String, dynamic>{};
    if (body['licenseNumber'] != null) updates['license_number'] = body['licenseNumber'];
    if (body['licenseExpiry'] != null) updates['license_expiry'] = body['licenseExpiry'];
    if (body['isAvailable'] != null) updates['is_available'] = body['isAvailable'];
    if (updates.isNotEmpty) {
      updates['updated_at'] = DateTime.now().toIso8601String();
      db.update('drivers', updates, where: {'id': id});
    }
    
    return jsonResponse({'message': 'Driver updated successfully'});
  }
  
  Future<Response> deleteDriver(Request request) async {
    final id = request.params['id'];
    
    final db = DatabaseConfig.db;
    db.update('drivers', {
      'is_active': false,
      'updated_at': DateTime.now().toIso8601String(),
    }, where: {'id': id});
    
    return jsonResponse({'message': 'Driver deleted successfully'});
  }

  Future<Response> updateEmployeeLocation(Request request) async {
    final userId = request.params['userId'];
    final body = jsonDecode(await request.readAsString());
    final db = DatabaseConfig.db;

    final employee = db.findOne('employees', where: {'user_id': userId});
    if (employee == null) {
      return errorResponse('Employee not found', statusCode: 404);
    }

    final companyId = employee['company_id'];
    if (companyId != null) {
      final companySettings = db.findOne('company_settings', where: {'company_id': companyId});
      if (companySettings != null && companySettings['home_location_enabled'] == false) {
        return errorResponse('Home location update is disabled by your admin', statusCode: 403);
      }
    }

    final updates = <String, dynamic>{};
    if (body['homeLatitude'] != null) updates['home_latitude'] = body['homeLatitude'];
    if (body['homeLongitude'] != null) updates['home_longitude'] = body['homeLongitude'];
    if (body['homeAddress'] != null) updates['home_address'] = body['homeAddress'];
    updates['updated_at'] = DateTime.now().toIso8601String();

    db.update('employees', updates, where: {'id': employee['id']});

    return jsonResponse({'message': 'Location updated successfully'});
  }
}
