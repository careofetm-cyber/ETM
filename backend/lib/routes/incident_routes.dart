import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class IncidentRoutes {
  final router = Router();
  
  IncidentRoutes() {
    router.get('/', authMiddleware()(getIncidents));
    router.post('/', authMiddleware()(reportIncident));
    router.put('/<id>', authMiddleware(requiredRoles: ['admin', 'manager'])(updateIncident));
    router.post('/sos', authMiddleware()(sendSOS));
    router.post('/sos/<id>/resolve', authMiddleware(requiredRoles: ['admin', 'manager'])(resolveSOS));
  }
  
  Future<Response> getIncidents(Request request) async {
    final page = int.tryParse(request.url.queryParameters['page'] ?? '1') ?? 1;
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '20') ?? 20;
    final status = request.url.queryParameters['status'];
    final companyId = request.context['companyId'] as String?;
    
    final db = DatabaseConfig.db;
    final filters = <String, dynamic>{'company_id': companyId};
    if (status != null) filters['status'] = status;
    
    var allIncidents = db.findAll('incidents', filters: filters);
    final total = allIncidents.length;
    allIncidents.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));
    final paginated = allIncidents.skip((page - 1) * limit).take(limit).toList();
    
    return jsonResponse({
      'data': paginated,
      'pagination': {
        'total': total,
        'page': page,
        'limit': limit,
        'totalPages': (total / limit).ceil(),
      },
    });
  }
  
  Future<Response> reportIncident(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    final userId = request.context['userId'] as String;
    
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now().toIso8601String();
    final db = DatabaseConfig.db;
    db.insert('incidents', {
      'id': id,
      'reported_by': userId,
      'vehicle_id': body['vehicleId'],
      'trip_id': body['tripId'],
      'driver_id': body['driverId'],
      'severity': body['severity'],
      'status': 'reported',
      'description': body['description'],
      'location': body['location'],
      'latitude': body['latitude'],
      'longitude': body['longitude'],
      'incident_time': body['incidentTime'],
      'company_id': companyId,
      'created_at': now,
    });
    
    return jsonResponse({'id': id, 'message': 'Incident reported successfully'}, statusCode: 201);
  }
  
  Future<Response> updateIncident(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    
    final db = DatabaseConfig.db;
    final updates = <String, dynamic>{};
    if (body['status'] != null) {
      updates['status'] = body['status'];
      if (body['status'] == 'resolved') {
        updates['resolved_at'] = DateTime.now().toIso8601String();
      }
    }
    if (body['severity'] != null) updates['severity'] = body['severity'];
    if (body['resolution'] != null) updates['resolution'] = body['resolution'];
    updates['resolved_by'] = request.context['userId'];
    if (updates.isNotEmpty) {
      updates['updated_at'] = DateTime.now().toIso8601String();
      db.update('incidents', updates, where: {'id': id});
    }
    
    return jsonResponse({'message': 'Incident updated successfully'});
  }
  
  Future<Response> sendSOS(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final userId = request.context['userId'] as String;
    final role = request.context['role'] as String;
    final companyId = request.context['companyId'] as String;
    
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now().toIso8601String();
    final db = DatabaseConfig.db;
    db.insert('sos_alerts', {
      'id': id,
      'user_id': userId,
      'user_type': role,
      'latitude': body['latitude'],
      'longitude': body['longitude'],
      'message': body['message'],
      'is_resolved': false,
      'company_id': companyId,
      'created_at': now,
    });
    
    return jsonResponse({'id': id, 'message': 'SOS alert sent successfully'}, statusCode: 201);
  }
  
  Future<Response> resolveSOS(Request request) async {
    final id = request.params['id'];
    final userId = request.context['userId'] as String;
    
    final db = DatabaseConfig.db;
    db.update('sos_alerts', {
      'is_resolved': true,
      'resolved_by': userId,
      'resolved_at': DateTime.now().toIso8601String(),
    }, where: {'id': id});
    
    return jsonResponse({'message': 'SOS alert resolved successfully'});
  }
}
