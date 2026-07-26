import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class RouteRoutes {
  final router = Router();
  
  RouteRoutes() {
    router.get('/', authMiddleware()(getRoutes));
    router.get('/<id>', authMiddleware()(getRoute));
    router.post('/', authMiddleware(requiredRoles: ['admin', 'manager'])(createRoute));
    router.put('/<id>', authMiddleware(requiredRoles: ['admin', 'manager'])(updateRoute));
    router.delete('/<id>', authMiddleware(requiredRoles: ['admin'])(deleteRoute));
    router.get('/stops', authMiddleware()(getStops));
    router.post('/stops', authMiddleware(requiredRoles: ['admin', 'manager'])(createStop));
    router.put('/stops/<id>', authMiddleware(requiredRoles: ['admin', 'manager'])(updateStop));
    router.delete('/stops/<id>', authMiddleware(requiredRoles: ['admin'])(deleteStop));
  }
  
  Future<Response> getRoutes(Request request) async {
    final page = int.tryParse(request.url.queryParameters['page'] ?? '1') ?? 1;
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '20') ?? 20;
    final companyId = request.context['companyId'] as String?;
    
    final db = DatabaseConfig.db;
    final totalCount = db.count('routes', filters: {'company_id': companyId});
    var routes = db.findAll('routes', filters: {'company_id': companyId});
    routes.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));
    final paginated = routes.skip((page - 1) * limit).take(limit).toList();
    
    return paginatedResponse(paginated, totalCount, page, limit);
  }
  
  Future<Response> getRoute(Request request) async {
    final id = request.params['id'];
    final db = DatabaseConfig.db;
    final route = db.findOne('routes', where: {'id': id});
    
    if (route == null) {
      return errorResponse('Route not found', statusCode: 404);
    }
    
    var stops = db.findAll('route_stops', filters: {'route_id': id});
    stops.sort((a, b) => (a['sequence_order'] ?? 0).compareTo(b['sequence_order'] ?? 0));
    
    return jsonResponse({...route, 'stops': stops});
  }
  
  Future<Response> createRoute(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final db = DatabaseConfig.db;
    db.insert('routes', {
      'id': id,
      'name': body['name'],
      'description': body['description'],
      'total_distance': body['totalDistance'],
      'estimated_duration': body['estimatedDuration'],
      'company_id': companyId,
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
    });
    
    if (body['stops'] != null) {
      for (var i = 0; i < body['stops'].length; i++) {
        final stop = body['stops'][i];
        db.insert('route_stops', {
          'id': '${id}_stop_$i',
          'route_id': id,
          'name': stop['name'],
          'latitude': stop['latitude'],
          'longitude': stop['longitude'],
          'sequence_order': i,
          'address': stop['address'],
          'landmark': stop['landmark'],
        });
      }
    }
    
    return jsonResponse({'id': id, 'message': 'Route created successfully'}, statusCode: 201);
  }
  
  Future<Response> updateRoute(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    
    final db = DatabaseConfig.db;
    final updates = <String, dynamic>{};
    if (body['name'] != null) updates['name'] = body['name'];
    if (body['description'] != null) updates['description'] = body['description'];
    if (body['totalDistance'] != null) updates['total_distance'] = body['totalDistance'];
    if (body['estimatedDuration'] != null) updates['estimated_duration'] = body['estimatedDuration'];
    if (body['isActive'] != null) updates['is_active'] = body['isActive'];
    if (updates.isNotEmpty) {
      updates['updated_at'] = DateTime.now().toIso8601String();
      db.update('routes', updates, where: {'id': id});
    }
    
    return jsonResponse({'message': 'Route updated successfully'});
  }
  
  Future<Response> deleteRoute(Request request) async {
    final id = request.params['id'];
    final db = DatabaseConfig.db;
    db.delete('route_stops', where: {'route_id': id});
    db.delete('routes', where: {'id': id});
    return jsonResponse({'message': 'Route deleted successfully'});
  }
  
  Future<Response> getStops(Request request) async {
    final companyId = request.context['companyId'] as String?;
    final db = DatabaseConfig.db;
    final stops = db.findAll('stops', filters: {'company_id': companyId});
    stops.sort((a, b) => (a['name'] ?? '').toString().compareTo((b['name'] ?? '').toString()));
    return jsonResponse({'data': stops});
  }
  
  Future<Response> createStop(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final db = DatabaseConfig.db;
    db.insert('stops', {
      'id': id,
      'name': body['name'],
      'latitude': body['latitude'],
      'longitude': body['longitude'],
      'address': body['address'],
      'landmark': body['landmark'],
      'company_id': companyId,
      'created_at': DateTime.now().toIso8601String(),
    });
    
    return jsonResponse({'id': id, 'message': 'Stop created successfully'}, statusCode: 201);
  }
  
  Future<Response> updateStop(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    
    final db = DatabaseConfig.db;
    final updates = <String, dynamic>{};
    if (body['name'] != null) updates['name'] = body['name'];
    if (body['latitude'] != null) updates['latitude'] = body['latitude'];
    if (body['longitude'] != null) updates['longitude'] = body['longitude'];
    if (body['address'] != null) updates['address'] = body['address'];
    if (body['landmark'] != null) updates['landmark'] = body['landmark'];
    if (updates.isNotEmpty) {
      updates['updated_at'] = DateTime.now().toIso8601String();
      db.update('stops', updates, where: {'id': id});
    }
    
    return jsonResponse({'message': 'Stop updated successfully'});
  }
  
  Future<Response> deleteStop(Request request) async {
    final id = request.params['id'];
    final db = DatabaseConfig.db;
    db.delete('stops', where: {'id': id});
    return jsonResponse({'message': 'Stop deleted successfully'});
  }
}
