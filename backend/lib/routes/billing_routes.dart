import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../config/billing_service.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class BillingRoutes {
  final router = Router();

  BillingRoutes() {
    router.get('/', authMiddleware(requiredRoles: ['super_admin'])(getBillingRecords));
    router.get('/summary', authMiddleware(requiredRoles: ['super_admin'])(getBillingSummary));
    router.get('/invoices', authMiddleware(requiredRoles: ['super_admin'])(getInvoices));
    router.post('/invoices/generate', authMiddleware(requiredRoles: ['super_admin'])(generateInvoice));
    router.get('/company/:companyId', authMiddleware(requiredRoles: ['super_admin'])(getCompanyBilling));
  }

  Future<Response> getBillingRecords(Request request) async {
    final page = int.tryParse(request.url.queryParameters['page'] ?? '1') ?? 1;
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '20') ?? 20;
    final companyId = request.url.queryParameters['companyId'];
    final month = request.url.queryParameters['month'];
    final billableOnly = request.url.queryParameters['billableOnly'] == 'true';

    final db = DatabaseConfig.db;
    var filters = <String, dynamic>{};
    if (companyId != null) filters['company_id'] = companyId;
    if (month != null) filters['month'] = month;
    if (billableOnly) filters['is_billable'] = 'true';

    var records = db.findAll('billing_records', filters: filters);
    records.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));

    final total = records.length;
    final paginated = records.skip((page - 1) * limit).take(limit).toList();

    final enriched = paginated.map((r) {
      final company = r['company_id'] != null ? db.findOne('companies', where: {'id': r['company_id']}) : null;
      final trip = r['trip_id'] != null ? db.findOne('trips', where: {'id': r['trip_id']}) : null;
      return {
        ...r,
        'companyName': company?['name'] ?? '',
        'tripStatus': trip?['status'] ?? '',
      };
    }).toList();

    return paginatedResponse(enriched, total, page, limit);
  }

  Future<Response> getBillingSummary(Request request) async {
    final month = request.url.queryParameters['month'] ?? DateTime.now().toIso8601String().substring(0, 7);
    final db = DatabaseConfig.db;

    final records = db.findAll('billing_records', filters: {'month': month});
    final companies = db.findAll('companies');

    final summaries = companies.map((c) {
      final companyRecords = records.where((r) => r['company_id'] == c['id']).toList();
      final billableRecords = companyRecords.where((r) => r['is_billable'] == true || r['is_billable'] == 'true').toList();
      final totalDistance = companyRecords.fold<double>(0.0, (sum, r) => sum + ((r['total_distance'] as num?)?.toDouble() ?? 0.0));
      final totalAmount = billableRecords.fold<double>(0.0, (sum, r) => sum + ((r['trip_cost'] as num?)?.toDouble() ?? 0.0));

      return {
        'companyId': c['id'],
        'companyName': c['name'],
        'totalTrips': companyRecords.length,
        'billableTrips': billableRecords.length,
        'totalDistance': totalDistance,
        'totalAmount': totalAmount,
        'minimumKm': c['minimum_km_for_billing'] ?? 0,
        'tripCost': c['trip_cost_per_trip'] ?? 0,
      };
    }).toList();

    return jsonResponse({'month': month, 'summaries': summaries});
  }

  Future<Response> getInvoices(Request request) async {
    final month = request.url.queryParameters['month'];
    final db = DatabaseConfig.db;

    var filters = <String, dynamic>{};
    if (month != null) filters['month'] = month;

    var invoices = db.findAll('invoices', filters: filters);
    invoices.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));

    final enriched = invoices.map((inv) {
      final company = inv['company_id'] != null ? db.findOne('companies', where: {'id': inv['company_id']}) : null;
      return {
        ...inv,
        'companyName': company?['name'] ?? '',
      };
    }).toList();

    return jsonResponse({'data': enriched});
  }

  Future<Response> generateInvoice(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = body['companyId'] as String;
    final month = body['month'] as String;

    BillingService.generateInvoice(companyId, month);

    return jsonResponse({'message': 'Invoice generated successfully'});
  }

  Future<Response> getCompanyBilling(Request request) async {
    final companyId = request.params['companyId'];
    final db = DatabaseConfig.db;

    final company = db.findOne('companies', where: {'id': companyId});
    if (company == null) {
      return errorResponse('Company not found', statusCode: 404);
    }

    final month = request.url.queryParameters['month'] ?? DateTime.now().toIso8601String().substring(0, 7);
    final records = db.findAll('billing_records', filters: {'company_id': companyId, 'month': month});
    final billable = records.where((r) => r['is_billable'] == true || r['is_billable'] == 'true').toList();

    final totalDistance = records.fold<double>(0.0, (sum, r) => sum + ((r['total_distance'] as num?)?.toDouble() ?? 0.0));
    final totalAmount = billable.fold<double>(0.0, (sum, r) => sum + ((r['trip_cost'] as num?)?.toDouble() ?? 0.0));

    return jsonResponse({
      'company': {
        'id': company['id'],
        'name': company['name'],
        'minimumKm': company['minimum_km_for_billing'] ?? 0,
        'tripCost': company['trip_cost_per_trip'] ?? 0,
        'monthlyTripLimit': company['monthly_trip_limit'] ?? 0,
        'tripsUsedThisMonth': company['trips_used_this_month'] ?? 0,
      },
      'month': month,
      'totalTrips': records.length,
      'billableTrips': billable.length,
      'totalDistance': totalDistance,
      'totalAmount': totalAmount,
      'records': records,
    });
  }
}
