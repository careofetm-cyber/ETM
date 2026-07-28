import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:dotenv/dotenv.dart';

import 'dart:convert';
import 'package:etm_backend/config/database.dart';
import 'package:etm_backend/config/redis.dart';
import 'package:etm_backend/middleware/error_middleware.dart';
import 'package:etm_backend/middleware/auth_middleware.dart';
import 'package:etm_backend/routes/auth_routes.dart';
import 'package:etm_backend/routes/vehicle_routes.dart';
import 'package:etm_backend/routes/route_routes.dart';
import 'package:etm_backend/routes/trip_routes.dart';
import 'package:etm_backend/routes/attendance_routes.dart';
import 'package:etm_backend/routes/employee_routes.dart';
import 'package:etm_backend/routes/dashboard_routes.dart';
import 'package:etm_backend/routes/notification_routes.dart';
import 'package:etm_backend/routes/incident_routes.dart';
import 'package:etm_backend/routes/super_admin_routes.dart';
import 'package:etm_backend/routes/settings_routes.dart';
import 'package:etm_backend/routes/report_routes.dart';
import 'package:etm_backend/routes/bulk_upload_routes.dart';
import 'package:etm_backend/routes/user_management_routes.dart';
import 'package:etm_backend/routes/otp_routes.dart';
import 'package:etm_backend/routes/permission_routes.dart';
import 'package:etm_backend/routes/roster_routes.dart';
import 'package:etm_backend/routes/vehicle_document_routes.dart';
import 'package:etm_backend/routes/ncns_routes.dart';
import 'package:etm_backend/routes/enhanced_sos_routes.dart';
import 'package:etm_backend/routes/hcm_routes.dart';
import 'package:etm_backend/routes/shift_routes.dart';
import 'package:etm_backend/routes/driver_routes.dart';
import 'package:etm_backend/routes/stop_routes.dart';

void main() async {
  // Load environment variables
  final env = DotEnv()..load();
  
  // Initialize database
  await DatabaseConfig.initialize();
  await RedisConfig.initialize();
  
  // Setup router
  final router = Router();
  
  // Health check
  router.get('/health', (Request request) {
    return Response.ok(
      jsonEncode({'status': 'ok', 'timestamp': DateTime.now().toIso8601String()}),
      headers: {'Content-Type': 'application/json'},
    );
  });
  
  // Public company branding endpoint
  router.get('/api/v1/company/<slug>', (Request request, String slug) async {
    final db = DatabaseConfig.db;
    final company = db.findOne('companies', where: {'slug': slug});
    if (company == null) {
      return Response.notFound(
        jsonEncode({'error': 'Company not found'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
    return Response.ok(
      jsonEncode({
        'id': company['id'],
        'name': company['name'],
        'slug': company['slug'],
        'logo': company['logo'],
        'favicon': company['favicon'],
        'primaryColor': company['primary_color'],
        'backgroundColor': company['background_color'],
      }),
      headers: {'Content-Type': 'application/json'},
    );
  });
  
  // Companies routes for regular admins
  final companiesRouter = Router()
    ..get('/me', authMiddleware()(getMyCompany))
    ..put('/me', authMiddleware(requiredRoles: ['admin', 'manager'])(updateMyCompany));

  // API v1 routes
  final v1Router = Router()
    ..mount('/auth', AuthRoutes().router)
    ..mount('/companies', companiesRouter)
    ..mount('/vehicles', VehicleRoutes().router)
    ..mount('/routes', RouteRoutes().router)
    ..mount('/trips', TripRoutes().router)
    ..mount('/attendance', AttendanceRoutes().router)
    ..mount('/employees', EmployeeRoutes().router)
    ..mount('/dashboard', DashboardRoutes().router)
    ..mount('/notifications', NotificationRoutes().router)
    ..mount('/incidents', IncidentRoutes().router)
    ..mount('/super-admin', SuperAdminRoutes().router)
    ..mount('/settings', SettingsRoutes().router)
    ..mount('/reports', ReportRoutes().router)
    ..mount('/bulk-upload', BulkUploadRoutes().router)
    ..mount('/users', UserManagementRoutes().router)
    ..mount('/otp', OtpRoutes().router)
    ..mount('/permissions', PermissionRoutes().router)
    ..mount('/rosters', RosterRoutes().router)
    ..mount('/vehicle-documents', VehicleDocumentRoutes().router)
    ..mount('/ncns', NcnsRoutes().router)
    ..mount('/sos', EnhancedSosRoutes().router)
    ..mount('/hcm', HcmRoutes().router)
    ..mount('/shifts', ShiftRoutes().router)
    ..mount('/drivers', DriverRoutes().router)
    ..mount('/stops', StopRoutes().router);
  
  router.mount('/api/v1', v1Router);
  
  // Middleware pipeline
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware())
      .addMiddleware(errorMiddleware())
      .addHandler(router.call);
  
  // Start server
  final port = int.parse(env['PORT'] ?? '8080');
  final server = await io.serve(handler, InternetAddress.anyIPv4, port);
  
  print('ETM Backend server running on port ${server.port}');
  print('API: http://localhost:${server.port}/api/v1');
  print('Health: http://localhost:${server.port}/health');
}

Future<Response> getMyCompany(Request request) async {
  final companyId = request.context['companyId'] as String?;
  if (companyId == null) {
    return errorResponse('No company associated with this user', statusCode: 400);
  }

  final db = DatabaseConfig.db;
  final company = db.findOne('companies', where: {'id': companyId});
  if (company == null) {
    return errorResponse('Company not found', statusCode: 404);
  }

  return jsonResponse(company);
}

Future<Response> updateMyCompany(Request request) async {
  final companyId = request.context['companyId'] as String?;
  if (companyId == null) {
    return errorResponse('No company associated with this user', statusCode: 400);
  }

  final body = jsonDecode(await request.readAsString());
  final db = DatabaseConfig.db;

  final existing = db.findOne('companies', where: {'id': companyId});
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
  if (body['logo'] != null) updates['logo'] = body['logo'];
  if (body['favicon'] != null) updates['favicon'] = body['favicon'];
  if (body['primaryColor'] != null) updates['primary_color'] = body['primaryColor'];
  if (body['backgroundColor'] != null) updates['background_color'] = body['backgroundColor'];
  if (body['tripCostPerTrip'] != null) updates['trip_cost_per_trip'] = body['tripCostPerTrip'];
  if (body['minimumKmForBilling'] != null) updates['minimum_km_for_billing'] = body['minimumKmForBilling'];

  updates['updated_at'] = DateTime.now().toIso8601String();
  db.update('companies', updates, where: {'id': companyId});

  final updated = db.findOne('companies', where: {'id': companyId});
  return jsonResponse(updated!);
}

Middleware _corsMiddleware() {
  return corsHeaders(
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    },
  );
}
