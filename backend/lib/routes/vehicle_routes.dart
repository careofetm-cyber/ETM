import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class VehicleRoutes {
  final router = Router();
  
  VehicleRoutes() {
    router.get('/', authMiddleware()(getVehicles));
    router.get('/<id>', authMiddleware()(getVehicle));
    router.post('/', authMiddleware(requiredRoles: ['admin', 'manager'])(createVehicle));
    router.put('/<id>', authMiddleware(requiredRoles: ['admin', 'manager'])(updateVehicle));
    router.delete('/<id>', authMiddleware(requiredRoles: ['admin'])(deleteVehicle));
    router.put('/<id>/location', authMiddleware(requiredRoles: ['driver'])(updateLocation));
    router.get('/<id>/inspections', authMiddleware()(getInspections));
    router.post('/<id>/inspections', authMiddleware(requiredRoles: ['driver'])(createInspection));
  }
  
  Future<Response> getVehicles(Request request) async {
    final page = int.tryParse(request.url.queryParameters['page'] ?? '1') ?? 1;
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '20') ?? 20;
    final status = request.url.queryParameters['status'];
    final companyId = request.context['companyId'] as String?;
    
    final db = DatabaseConfig.db;
    final filters = <String, dynamic>{'company_id': companyId};
    if (status != null) filters['status'] = status;
    
    final totalCount = db.count('vehicles', filters: filters);
    var vehicles = db.findAll('vehicles', filters: filters);
    vehicles.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));
    final paginated = vehicles.skip((page - 1) * limit).take(limit).toList();
    
    return paginatedResponse(paginated, totalCount, page, limit);
  }
  
  Future<Response> getVehicle(Request request) async {
    final id = request.params['id'];
    final db = DatabaseConfig.db;
    final vehicle = db.findOne('vehicles', where: {'id': id});
    
    if (vehicle == null) {
      return errorResponse('Vehicle not found', statusCode: 404);
    }
    
    return jsonResponse(vehicle);
  }
  
  Future<Response> createVehicle(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final db = DatabaseConfig.db;
    db.insert('vehicles', {
      'id': id,
      'plate_number': body['plateNumber'],
      'model': body['model'],
      'brand': body['brand'],
      'year': body['year'],
      'seating_capacity': body['seatingCapacity'],
      'color': body['color'],
      'status': 'active',
      'company_id': companyId,
      'created_at': DateTime.now().toIso8601String(),
    });
    
    final vehicle = db.findOne('vehicles', where: {'id': id});
    return jsonResponse(vehicle!, statusCode: 201);
  }
  
  Future<Response> updateVehicle(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    
    final db = DatabaseConfig.db;
    final updates = <String, dynamic>{};
    if (body['plateNumber'] != null) updates['plate_number'] = body['plateNumber'];
    if (body['model'] != null) updates['model'] = body['model'];
    if (body['brand'] != null) updates['brand'] = body['brand'];
    if (body['year'] != null) updates['year'] = body['year'];
    if (body['seatingCapacity'] != null) updates['seating_capacity'] = body['seatingCapacity'];
    if (body['color'] != null) updates['color'] = body['color'];
    if (body['status'] != null) updates['status'] = body['status'];
    if (updates.isNotEmpty) {
      updates['updated_at'] = DateTime.now().toIso8601String();
      db.update('vehicles', updates, where: {'id': id});
    }
    
    return jsonResponse({'message': 'Vehicle updated successfully'});
  }
  
  Future<Response> deleteVehicle(Request request) async {
    final id = request.params['id'];
    final db = DatabaseConfig.db;
    db.delete('vehicles', where: {'id': id});
    return jsonResponse({'message': 'Vehicle deleted successfully'});
  }
  
  Future<Response> updateLocation(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    
    final db = DatabaseConfig.db;
    db.update('vehicles', {
      'current_latitude': body['latitude'],
      'current_longitude': body['longitude'],
      'last_location_update': DateTime.now().toIso8601String(),
    }, where: {'id': id});
    
    return jsonResponse({'message': 'Location updated successfully'});
  }
  
  Future<Response> getInspections(Request request) async {
    final vehicleId = request.params['id'];
    final db = DatabaseConfig.db;
    final inspections = db.findAll('vehicle_inspections', filters: {'vehicle_id': vehicleId});
    inspections.sort((a, b) => (b['inspection_date'] ?? '').toString().compareTo((a['inspection_date'] ?? '').toString()));
    return jsonResponse({'data': inspections});
  }
  
  Future<Response> createInspection(Request request) async {
    final vehicleId = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    final driverId = request.context['userId'] as String;
    
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final db = DatabaseConfig.db;
    db.insert('vehicle_inspections', {
      'id': id,
      'vehicle_id': vehicleId,
      'driver_id': driverId,
      'inspection_date': DateTime.now().toIso8601String(),
      'is_passed': body['isPassed'],
      'notes': body['notes'],
      'issues': body['issues'],
    });
    
    return jsonResponse({'message': 'Inspection created successfully'}, statusCode: 201);
  }
}
