import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class SuperAdminRoutes {
  final router = Router();

  SuperAdminRoutes() {
    router.get('/companies', authMiddleware(requiredRoles: ['super_admin'])(getCompanies));
    router.get('/companies/<id>', authMiddleware(requiredRoles: ['super_admin'])(getCompanyDetail));
    router.post('/companies', authMiddleware(requiredRoles: ['super_admin'])(createCompany));
    router.put('/companies/<id>', authMiddleware(requiredRoles: ['super_admin'])(updateCompany));
    router.delete('/companies/<id>', authMiddleware(requiredRoles: ['super_admin'])(deleteCompany));
    router.get('/dashboard', authMiddleware(requiredRoles: ['super_admin'])(getDashboard));
    router.get('/billing', authMiddleware(requiredRoles: ['super_admin'])(getBilling));
    router.get('/billing/summary', authMiddleware(requiredRoles: ['super_admin'])(getBillingSummary));
    router.get('/invoices', authMiddleware(requiredRoles: ['super_admin'])(getInvoices));
    router.put('/invoices/<id>', authMiddleware(requiredRoles: ['super_admin'])(updateInvoice));
    router.post('/login-as', authMiddleware(requiredRoles: ['super_admin'])(loginAsCompanyUser));
  }

  Future<Response> getCompanies(Request request) async {
    final db = DatabaseConfig.db;
    final companies = db.findAll('companies');

    final enriched = companies.map((c) {
      final tripsThisMonth = db.findAll('trips', filters: {
        'company_id': c['id'],
      }).where((t) {
        final st = t['scheduled_time']?.toString() ?? '';
        final month = DateTime.now().toIso8601String().substring(0, 7);
        return st.startsWith(month);
      }).length;

      return {
        ...c,
        'total_trips_this_month': tripsThisMonth,
      };
    }).toList();

    return jsonResponse({'data': enriched});
  }

  Future<Response> getCompanyDetail(Request request) async {
    final id = request.params['id'];
    final db = DatabaseConfig.db;
    final company = db.findOne('companies', where: {'id': id});

    if (company == null) {
      return errorResponse('Company not found', statusCode: 404);
    }

    final month = DateTime.now().toIso8601String().substring(0, 7);
    final billingRecords = db.findAll('billing_records', filters: {'company_id': id, 'month': month});
    final billableTrips = billingRecords.where((r) => r['is_billable'] == true).length;
    final discardedTrips = billingRecords.where((r) => r['is_billable'] == false).length;
    final totalAmount = billingRecords.fold<double>(0.0, (sum, r) => sum + ((r['trip_cost'] as num?)?.toDouble() ?? 0.0));

    return jsonResponse({
      ...company,
      'billing_summary': {
        'total_trips_this_month': billingRecords.length,
        'billable_trips_this_month': billableTrips,
        'discarded_trips_this_month': discardedTrips,
        'total_amount_this_month': totalAmount,
      },
    });
  }

  Future<Response> createCompany(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final db = DatabaseConfig.db;

    final id = 'comp_${DateTime.now().millisecondsSinceEpoch}';
    final adminPassword = body['adminPassword'] as String? ?? 'admin123';
    final adminEmail = body['adminEmail'] as String? ?? '${(body['name'] as String? ?? 'admin').toLowerCase().replaceAll(' ', '')}@admin.com';
    
    db.insert('companies', {
      'id': id,
      'name': body['name'],
      'slug': body['slug'] ?? (body['name'] as String? ?? '').toLowerCase().replaceAll(' ', '-'),
      'email': body['email'],
      'phone': body['phone'],
      'address': body['address'],
      'city': body['city'],
      'state': body['state'],
      'country': body['country'],
      'postal_code': body['postalCode'],
      'is_active': true,
      'plan': body['plan'] ?? 'basic',
      'trip_cost_per_trip': body['tripCostPerTrip'] ?? 100.0,
      'minimum_km_for_billing': body['minimumKmForBilling'] ?? 5.0,
      'monthly_trip_limit': body['monthlyTripLimit'] ?? 100,
      'subscription_status': body['subscriptionStatus'] ?? 'trial',
      'trips_used_this_month': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Create admin user for the company
    final adminUserId = 'usr_adm_${DateTime.now().millisecondsSinceEpoch}';
    final passwordHash = BCrypt.hashpw(adminPassword, BCrypt.gensalt());
    db.insert('users', {
      'id': adminUserId,
      'email': adminEmail,
      'first_name': body['adminFirstName'] ?? (body['name'] as String? ?? 'Admin'),
      'last_name': body['adminLastName'] ?? 'Admin',
      'phone': body['phone'] ?? '',
      'password_hash': passwordHash,
      'role': 'admin',
      'company_id': id,
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
    });

    return jsonResponse({
      'id': id,
      'message': 'Company created successfully',
      'adminEmail': adminEmail,
      'adminPassword': adminPassword,
    }, statusCode: 201);
  }

  Future<Response> updateCompany(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    final db = DatabaseConfig.db;

    final existing = db.findOne('companies', where: {'id': id});
    if (existing == null) {
      return errorResponse('Company not found', statusCode: 404);
    }

    final updates = <String, dynamic>{};
    if (body['name'] != null) updates['name'] = body['name'];
    if (body['email'] != null) updates['email'] = body['email'];
    if (body['phone'] != null) updates['phone'] = body['phone'];
    if (body['address'] != null) updates['address'] = body['address'];
    if (body['city'] != null) updates['city'] = body['city'];
    if (body['state'] != null) updates['state'] = body['state'];
    if (body['country'] != null) updates['country'] = body['country'];
    if (body['postalCode'] != null) updates['postal_code'] = body['postalCode'];
    if (body['plan'] != null) updates['plan'] = body['plan'];
    if (body['tripCostPerTrip'] != null) updates['trip_cost_per_trip'] = body['tripCostPerTrip'];
    if (body['minimumKmForBilling'] != null) updates['minimum_km_for_billing'] = body['minimumKmForBilling'];
    if (body['monthlyTripLimit'] != null) updates['monthly_trip_limit'] = body['monthlyTripLimit'];
    if (body['subscriptionStatus'] != null) updates['subscription_status'] = body['subscriptionStatus'];

    updates['updated_at'] = DateTime.now().toIso8601String();
    db.update('companies', updates, where: {'id': id});

    return jsonResponse({'message': 'Company updated successfully'});
  }

  Future<Response> deleteCompany(Request request) async {
    final id = request.params['id'];
    final db = DatabaseConfig.db;

    final existing = db.findOne('companies', where: {'id': id});
    if (existing == null) {
      return errorResponse('Company not found', statusCode: 404);
    }

    db.update('companies', {
      'is_active': false,
      'updated_at': DateTime.now().toIso8601String(),
    }, where: {'id': id});

    return jsonResponse({'message': 'Company deactivated successfully'});
  }

  Future<Response> getDashboard(Request request) async {
    final db = DatabaseConfig.db;
    final companies = db.findAll('companies');
    final activeCompanies = companies.where((c) => c['is_active'] == true).length;
    final month = DateTime.now().toIso8601String().substring(0, 7);

    var allTripsThisMonth = db.findAll('trips');
    allTripsThisMonth = allTripsThisMonth.where((t) {
      final st = t['scheduled_time']?.toString() ?? '';
      return st.startsWith(month);
    }).toList();

    final totalTripsThisMonth = allTripsThisMonth.length;

    final allBilling = db.findAll('billing_records');
    final billingThisMonth = allBilling.where((b) => b['month'] == month).toList();
    final totalRevenueThisMonth = billingThisMonth
        .where((b) => b['is_billable'] == true)
        .fold<double>(0.0, (sum, b) => sum + ((b['trip_cost'] as num?)?.toDouble() ?? 0.0));

    final totalDrivers = db.count('drivers');
    final totalVehicles = db.count('vehicles');
    final totalEmployees = db.count('employees');

    return jsonResponse({
      'total_companies': companies.length,
      'active_companies': activeCompanies,
      'total_trips_this_month': totalTripsThisMonth,
      'total_revenue_this_month': totalRevenueThisMonth,
      'total_drivers': totalDrivers,
      'total_vehicles': totalVehicles,
      'total_employees': totalEmployees,
    });
  }

  Future<Response> getBilling(Request request) async {
    final db = DatabaseConfig.db;
    final month = request.url.queryParameters['month'] ?? DateTime.now().toIso8601String().substring(0, 7);
    final companyId = request.url.queryParameters['companyId'];

    final filters = <String, dynamic>{'month': month};
    if (companyId != null) filters['company_id'] = companyId;

    var records = db.findAll('billing_records', filters: filters);
    records.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));

    return jsonResponse({'data': records});
  }

  Future<Response> getBillingSummary(Request request) async {
    final db = DatabaseConfig.db;
    final month = request.url.queryParameters['month'] ?? DateTime.now().toIso8601String().substring(0, 7);
    final companies = db.findAll('companies');

    final summaries = companies.map((c) {
      final records = db.findAll('billing_records', filters: {
        'company_id': c['id'],
        'month': month,
      });

      final billableTrips = records.where((r) => r['is_billable'] == true).length;
      final discardedTrips = records.where((r) => r['is_billable'] == false).length;
      final totalAmount = records.fold<double>(0.0, (sum, r) => sum + ((r['trip_cost'] as num?)?.toDouble() ?? 0.0));

      return {
        'company_id': c['id'],
        'company_name': c['name'],
        'total_trips_this_month': records.length,
        'billable_trips_this_month': billableTrips,
        'discarded_trips_this_month': discardedTrips,
        'total_amount_this_month': totalAmount,
      };
    }).toList();

    return jsonResponse({'data': summaries});
  }

  Future<Response> getInvoices(Request request) async {
    final db = DatabaseConfig.db;
    final companyId = request.url.queryParameters['companyId'];

    final filters = <String, dynamic>{};
    if (companyId != null) filters['company_id'] = companyId;

    var invoices = db.findAll('invoices', filters: filters);
    invoices.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));

    return jsonResponse({'data': invoices});
  }

  Future<Response> updateInvoice(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    final db = DatabaseConfig.db;

    final existing = db.findOne('invoices', where: {'id': id});
    if (existing == null) {
      return errorResponse('Invoice not found', statusCode: 404);
    }

    final updates = <String, dynamic>{};
    if (body['status'] != null) updates['status'] = body['status'];
    updates['updated_at'] = DateTime.now().toIso8601String();

    db.update('invoices', updates, where: {'id': id});

    return jsonResponse({'message': 'Invoice updated successfully'});
  }

  Future<Response> loginAsCompanyUser(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final targetUserId = body['userId'] as String?;
    if (targetUserId == null) {
      return errorResponse('userId is required');
    }

    final db = DatabaseConfig.db;
    final user = db.findOne('users', where: {'id': targetUserId});
    if (user == null) {
      return errorResponse('User not found', statusCode: 404);
    }

    if (user['is_active'] != true) {
      return errorResponse('User is not active', statusCode: 403);
    }

    final token = generateToken(
      userId: user['id'],
      role: user['role'],
      companyId: user['company_id'],
    );

    return jsonResponse({
      'token': token,
      'user': {
        'id': user['id'],
        'email': user['email'],
        'first_name': user['first_name'],
        'last_name': user['last_name'],
        'role': user['role'],
        'is_active': user['is_active'],
        'company_id': user['company_id'],
      },
    });
  }
}
