import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../config/billing_service.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class TripRoutes {
  final router = Router();
  
  TripRoutes() {
    router.get('/', authMiddleware()(getTrips));
    router.get('/driver', authMiddleware(requiredRoles: ['driver'])(getDriverTrips));
    router.get('/<id>', authMiddleware()(getTrip));
    router.post('/', authMiddleware(requiredRoles: ['admin', 'manager', 'transport_manager'])(createTrip));
    router.put('/<id>', authMiddleware(requiredRoles: ['admin', 'manager', 'transport_manager'])(updateTrip));
    router.post('/<id>/start', authMiddleware(requiredRoles: ['driver'])(startTrip));
    router.post('/<id>/complete', authMiddleware(requiredRoles: ['driver'])(completeTrip));
    router.post('/<id>/cancel', authMiddleware(requiredRoles: ['admin', 'manager', 'transport_manager'])(cancelTrip));
    router.get('/<id>/passengers', authMiddleware()(getPassengers));
    router.put('/<id>/assign-cab', authMiddleware(requiredRoles: ['admin', 'manager', 'transport_manager'])(assignCab));
    router.get('/employee/:employeeId', authMiddleware()(getEmployeeTrips));
    router.put('/<id>/passengers', authMiddleware(requiredRoles: ['admin', 'manager', 'transport_manager'])(updatePassengers));
    router.post('/<id>/passengers/<employeeId>/board', authMiddleware(requiredRoles: ['driver'])(boardPassenger));
    router.post('/<id>/passengers/<employeeId>/drop', authMiddleware(requiredRoles: ['driver'])(dropPassenger));
    router.post('/location', authMiddleware(requiredRoles: ['driver'])(sendLocationUpdate));
    router.get('/gps/<vehicleId>', authMiddleware()(getGPSLogs));
  }
  
  Future<Response> getTrips(Request request) async {
    final page = int.tryParse(request.url.queryParameters['page'] ?? '1') ?? 1;
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '20') ?? 20;
    final status = request.url.queryParameters['status'];
    final date = request.url.queryParameters['date'];
    final companyId = request.context['companyId'] as String?;
    
    final db = DatabaseConfig.db;
    final filters = <String, dynamic>{'company_id': companyId};
    if (status != null) filters['status'] = status;
    
    var allTrips = db.findAll('trips', filters: filters);
    if (date != null) {
      allTrips = allTrips.where((t) => t['scheduled_time']?.toString().startsWith(date) == true).toList();
    }
    
    final total = allTrips.length;
    allTrips.sort((a, b) => (b['scheduled_time'] ?? '').toString().compareTo((a['scheduled_time'] ?? '').toString()));
    final paginated = allTrips.skip((page - 1) * limit).take(limit).toList();
    
    return paginatedResponse(paginated, total, page, limit);
  }
  
  Future<Response> getTrip(Request request) async {
    final id = request.params['id'];
    final db = DatabaseConfig.db;
    final trip = db.findOne('trips', where: {'id': id});
    
    if (trip == null) {
      return errorResponse('Trip not found', statusCode: 404);
    }
    
    final route = trip['route_id'] != null ? db.findOne('routes', where: {'id': trip['route_id']}) : null;
    final vehicle = trip['vehicle_id'] != null ? db.findOne('vehicles', where: {'id': trip['vehicle_id']}) : null;
    
    return jsonResponse({
      ...trip,
      'route_name': route?['name'],
      'plate_number': vehicle?['plate_number'],
      'vehicle_model': vehicle?['model'],
    });
  }
  
  Future<Response> createTrip(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;
    
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final db = DatabaseConfig.db;
    db.insert('trips', {
      'id': id,
      'route_id': body['routeId'],
      'vehicle_id': body['vehicleId'],
      'driver_id': body['driverId'],
      'type': body['type'] ?? 'morning',
      'status': 'scheduled',
      'scheduled_time': body['scheduledTime'],
      'total_passengers': (body['employeeIds'] as List?)?.length ?? 0,
      'company_id': companyId,
      'created_at': DateTime.now().toIso8601String(),
    });

    final employeeIds = body['employeeIds'] as List<dynamic>?;
    if (employeeIds != null) {
      for (final empId in employeeIds) {
        final empMap = empId is Map<String, dynamic> ? empId : {'employeeId': empId.toString(), 'stopId': null};
        final passengerId = 'tp_${DateTime.now().millisecondsSinceEpoch}_${empMap['employeeId']}';
        db.insert('trip_passengers', {
          'id': passengerId,
          'trip_id': id,
          'employee_id': empMap['employeeId'],
          'stop_id': empMap['stopId'] ?? '',
          'is_boarded': false,
          'is_dropped': false,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    }

    return jsonResponse({'id': id, 'message': 'Trip created successfully'}, statusCode: 201);
  }
  
  Future<Response> updateTrip(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    
    final db = DatabaseConfig.db;
    final updates = <String, dynamic>{};
    if (body['routeId'] != null) updates['route_id'] = body['routeId'];
    if (body['vehicleId'] != null) updates['vehicle_id'] = body['vehicleId'];
    if (body['driverId'] != null) updates['driver_id'] = body['driverId'];
    if (body['scheduledTime'] != null) updates['scheduled_time'] = body['scheduledTime'];
    if (updates.isNotEmpty) {
      updates['updated_at'] = DateTime.now().toIso8601String();
      db.update('trips', updates, where: {'id': id});
    }
    
    return jsonResponse({'message': 'Trip updated successfully'});
  }
  
  Future<Response> startTrip(Request request) async {
    final id = request.params['id'];
    
    final db = DatabaseConfig.db;
    db.update('trips', {
      'status': 'inProgress',
      'actual_start_time': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }, where: {'id': id});
    
    return jsonResponse({'message': 'Trip started successfully'});
  }
  
  Future<Response> completeTrip(Request request) async {
    final id = request.params['id'] ?? '';
    final body = jsonDecode(await request.readAsString());

    final db = DatabaseConfig.db;
    final trip = db.findOne('trips', where: {'id': id});
    if (trip == null) {
      return errorResponse('Trip not found', statusCode: 404);
    }

    final updates = <String, dynamic>{
      'status': 'completed',
      'actual_end_time': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (body['actualStartTime'] != null) {
      updates['actual_start_time'] = body['actualStartTime'];
    }

    if (trip['total_distance'] == null) {
      updates['total_distance'] = 0;
      updates['needs_review'] = true;
    }

    db.update('trips', updates, where: {'id': id});

    BillingService.processTripCompletion(id);

    return jsonResponse({'message': 'Trip completed successfully'});
  }
  
  Future<Response> cancelTrip(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    
    final db = DatabaseConfig.db;
    db.update('trips', {
      'status': 'cancelled',
      'notes': body['reason'],
      'updated_at': DateTime.now().toIso8601String(),
    }, where: {'id': id});
    
    return jsonResponse({'message': 'Trip cancelled successfully'});
  }
  
  Future<Response> getPassengers(Request request) async {
    final tripId = request.params['id'];
    final db = DatabaseConfig.db;
    
    final passengers = db.findAll('trip_passengers', filters: {'trip_id': tripId});
    final enriched = passengers.map((p) {
      final employee = p['employee_id'] != null ? db.findOne('employees', where: {'id': p['employee_id']}) : null;
      final user = employee != null ? db.findOne('users', where: {'id': employee['user_id']}) : null;
      return {
        ...p,
        'employee_code': employee?['employee_code'],
        'first_name': user?['first_name'],
        'last_name': user?['last_name'],
      };
    }).toList();
    
    return jsonResponse({'data': enriched});
  }
  
  Future<Response> boardPassenger(Request request) async {
    final tripId = request.params['id'];
    final employeeId = request.params['employeeId'];
    
    final db = DatabaseConfig.db;
    final record = db.findOne('trip_passengers', where: {'trip_id': tripId, 'employee_id': employeeId});
    if (record != null) {
      db.update('trip_passengers', {
        'is_boarded': true,
        'boarded_at': DateTime.now().toIso8601String(),
      }, where: {'trip_id': tripId, 'employee_id': employeeId});
    }
    
    return jsonResponse({'message': 'Passenger boarded successfully'});
  }
  
  Future<Response> dropPassenger(Request request) async {
    final tripId = request.params['id'];
    final employeeId = request.params['employeeId'];
    
    final db = DatabaseConfig.db;
    final record = db.findOne('trip_passengers', where: {'trip_id': tripId, 'employee_id': employeeId});
    if (record != null) {
      db.update('trip_passengers', {
        'is_dropped': true,
        'dropped_at': DateTime.now().toIso8601String(),
      }, where: {'trip_id': tripId, 'employee_id': employeeId});
    }
    
    return jsonResponse({'message': 'Passenger dropped successfully'});
  }
  
  Future<Response> sendLocationUpdate(Request request) async {
    final body = jsonDecode(await request.readAsString());
    
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final db = DatabaseConfig.db;
    db.insert('gps_logs', {
      'id': id,
      'vehicle_id': body['vehicleId'],
      'trip_id': body['tripId'],
      'latitude': body['latitude'],
      'longitude': body['longitude'],
      'speed': body['speed'],
      'heading': body['heading'],
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    return jsonResponse({'message': 'Location updated successfully'});
  }
  
  Future<Response> getGPSLogs(Request request) async {
    final vehicleId = request.params['vehicleId'];
    final start = request.url.queryParameters['start'];
    final end = request.url.queryParameters['end'];
    
    final db = DatabaseConfig.db;
    var logs = db.findAll('gps_logs', filters: {'vehicle_id': vehicleId});
    if (start != null) {
      logs = logs.where((l) => l['timestamp'].toString().compareTo(start) >= 0).toList();
    }
    if (end != null) {
      logs = logs.where((l) => l['timestamp'].toString().compareTo(end) <= 0).toList();
    }
    logs.sort((a, b) => b['timestamp'].toString().compareTo(a['timestamp'].toString()));
    
    return jsonResponse({'data': logs});
  }

  Future<Response> assignCab(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    final db = DatabaseConfig.db;

    final trip = db.findOne('trips', where: {'id': id});
    if (trip == null) {
      return errorResponse('Trip not found', statusCode: 404);
    }

    final updates = <String, dynamic>{};
    if (body['vehicleId'] != null) updates['vehicle_id'] = body['vehicleId'];
    if (body['driverId'] != null) updates['driver_id'] = body['driverId'];
    updates['updated_at'] = DateTime.now().toIso8601String();

    db.update('trips', updates, where: {'id': id});
    final updated = db.findOne('trips', where: {'id': id});
    return jsonResponse(updated!);
  }

  Future<Response> getDriverTrips(Request request) async {
    final userId = request.context['userId'] as String;
    final db = DatabaseConfig.db;

    final driver = db.findOne('drivers', where: {'user_id': userId});
    if (driver == null) {
      return errorResponse('Driver not found', statusCode: 404);
    }

    final driverId = driver['id'];
    final status = request.url.queryParameters['status'];
    final filters = <String, dynamic>{'driver_id': driverId};
    if (status != null) filters['status'] = status;

    var trips = db.findAll('trips', filters: filters);
    trips.sort((a, b) => (b['scheduled_time'] ?? '').toString().compareTo((a['scheduled_time'] ?? '').toString()));

    final enriched = trips.map((trip) {
      final route = trip['route_id'] != null ? db.findOne('routes', where: {'id': trip['route_id']}) : null;
      final vehicle = trip['vehicle_id'] != null ? db.findOne('vehicles', where: {'id': trip['vehicle_id']}) : null;
      final passengerCount = db.findAll('trip_passengers', filters: {'trip_id': trip['id']}).length;
      final boardedCount = db.findAll('trip_passengers', filters: {'trip_id': trip['id'], 'is_boarded': true}).length;
      return {
        ...trip,
        'routeName': route?['name'] ?? '',
        'vehiclePlate': vehicle?['plate_number'] ?? '',
        'vehicleModel': vehicle?['model'] ?? '',
        'passengerCount': passengerCount,
        'boardedCount': boardedCount,
      };
    }).toList();

    return jsonResponse({'data': enriched, 'total': enriched.length});
  }

  Future<Response> getEmployeeTrips(Request request) async {
    final employeeId = request.params['employeeId'];
    final db = DatabaseConfig.db;

    final passengers = db.findAll('trip_passengers', filters: {'employee_id': employeeId});
    final tripIds = passengers.map((p) => p['trip_id'] as String).toSet();

    final trips = <Map<String, dynamic>>[];
    for (final tid in tripIds) {
      final trip = db.findOne('trips', where: {'id': tid});
      if (trip != null) {
        final route = db.findOne('routes', where: {'id': trip['route_id']});
        final vehicle = db.findOne('vehicles', where: {'id': trip['vehicle_id']});
        final driver = trip['driver_id'] != null ? db.findOne('users', where: {'id': trip['driver_id']}) : null;
        trips.add({
          ...trip,
          'routeName': route?['name'] ?? '',
          'vehiclePlate': vehicle?['plate_number'] ?? '',
          'driverName': driver != null ? '${driver['first_name']} ${driver['last_name']}' : '',
        });
      }
    }

    trips.sort((a, b) => (b['scheduled_time'] ?? '').toString().compareTo((a['scheduled_time'] ?? '').toString()));
    return jsonResponse({'data': trips, 'total': trips.length});
  }

  Future<Response> updatePassengers(Request request) async {
    final tripId = request.params['id'];
    final body = jsonDecode(await request.readAsString());
    final db = DatabaseConfig.db;
    final action = body['action'] as String? ?? 'add';
    final employeeId = body['employeeId'] as String;
    final stopId = body['stopId'] as String?;

    if (action == 'add') {
      final id = 'tp_${DateTime.now().millisecondsSinceEpoch}';
      db.insert('trip_passengers', {
        'id': id,
        'trip_id': tripId,
        'employee_id': employeeId,
        'stop_id': stopId ?? '',
        'is_boarded': false,
        'is_dropped': false,
        'created_at': DateTime.now().toIso8601String(),
      });
      final trip = db.findOne('trips', where: {'id': tripId});
      if (trip != null) {
        final count = db.findAll('trip_passengers', filters: {'trip_id': tripId}).length;
        db.update('trips', {'total_passengers': count}, where: {'id': tripId});
      }
      return jsonResponse({'message': 'Employee added to trip'});
    } else if (action == 'remove') {
      final passengers = db.findAll('trip_passengers', filters: {'trip_id': tripId, 'employee_id': employeeId});
      for (final p in passengers) {
        db.delete('trip_passengers', where: {'id': p['id']});
      }
      final trip = db.findOne('trips', where: {'id': tripId});
      if (trip != null) {
        final count = db.findAll('trip_passengers', filters: {'trip_id': tripId}).length;
        db.update('trips', {'total_passengers': count}, where: {'id': tripId});
      }
      return jsonResponse({'message': 'Employee removed from trip'});
    }

    return errorResponse('Invalid action');
  }
}
