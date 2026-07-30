import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class DashboardRoutes {
  final router = Router();
  
  DashboardRoutes() {
    router.get('/admin', authMiddleware(requiredRoles: ['admin', 'manager'])(getAdminDashboard));
    router.get('/driver', authMiddleware(requiredRoles: ['driver'])(getDriverDashboard));
    router.get('/employee', authMiddleware(requiredRoles: ['employee'])(getEmployeeDashboard));
    router.get('/employee/:userId', authMiddleware(requiredRoles: ['employee'])(getEmployeeDashboardByUserId));
  }
  
  Future<Response> getAdminDashboard(Request request) async {
    final companyId = request.context['companyId'] as String?;
    final db = DatabaseConfig.db;
    
    final totalVehicles = db.count('vehicles', filters: {'company_id': companyId});
    final activeVehicles = db.count('vehicles', filters: {'company_id': companyId, 'status': 'active'});
    final totalDrivers = db.count('drivers', filters: {'company_id': companyId});
    
    final allCompanyDrivers = db.findAll('drivers', filters: {'company_id': companyId});
    final activeDrivers = allCompanyDrivers.where((d) {
      final user = db.findOne('users', where: {'id': d['user_id'], 'is_active': true});
      return user != null;
    }).length;
    
    final totalEmployees = db.count('employees', filters: {'company_id': companyId});
    final activeTrips = db.count('trips', filters: {'company_id': companyId, 'status': 'inProgress'});
    
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final completedTrips = db.findAll('trips', filters: {'company_id': companyId, 'status': 'completed'});
    final completedTripsToday = completedTrips.where((t) =>
      t['actual_end_time']?.toString().startsWith(today) == true
    ).length;
    
    final pendingRequests = db.count('transport_requests', filters: {'company_id': companyId, 'status': 'pending'});
    final totalRoutes = db.count('routes', filters: {'company_id': companyId});
    
    return jsonResponse({
      'total_vehicles': totalVehicles,
      'active_vehicles': activeVehicles,
      'total_drivers': totalDrivers,
      'active_drivers': activeDrivers,
      'total_employees': totalEmployees,
      'active_trips': activeTrips,
      'completed_trips_today': completedTripsToday,
      'pending_requests': pendingRequests,
      'total_routes': totalRoutes,
    });
  }
  
  Future<Response> getDriverDashboard(Request request) async {
    final userId = request.context['userId'] as String;
    final db = DatabaseConfig.db;
    
    final driver = db.findOne('drivers', where: {'user_id': userId});
    
    if (driver == null) {
      return jsonResponse({'error': 'Driver not found'}, statusCode: 404);
    }
    
    final driverId = driver['id'];
    final today = DateTime.now().toIso8601String().substring(0, 10);
    
    final allDriverTrips = db.findAll('trips', filters: {'driver_id': driverId});
    
    final todayTrips = allDriverTrips.where((t) =>
      t['scheduled_time']?.toString().startsWith(today) == true
    ).length;
    
    final completedTrips = allDriverTrips.where((t) =>
      t['status'] == 'completed' && t['actual_end_time']?.toString().startsWith(today) == true
    ).length;
    
    final pendingTrips = allDriverTrips.where((t) =>
      t['status'] == 'scheduled' && t['scheduled_time']?.toString().startsWith(today) == true
    ).length;
    
    final todayCompletedTrips = allDriverTrips.where((t) =>
      t['actual_end_time']?.toString().startsWith(today) == true
    ).toList();
    
    final totalDistance = todayCompletedTrips.fold<double>(0, (sum, t) =>
      sum + (double.tryParse(t['total_distance']?.toString() ?? '0') ?? 0));
    
    final totalPassengers = todayCompletedTrips.fold<int>(0, (sum, t) =>
      sum + (int.tryParse(t['boarded_passengers']?.toString() ?? '0') ?? 0));
    
    final vehicle = db.findOne('vehicles', where: {'driver_id': driverId, 'status': 'active'});
    
    final inProgressTrips = db.findAll('trips', filters: {'driver_id': driverId, 'status': 'inProgress'});
    inProgressTrips.sort((a, b) => (b['scheduled_time'] ?? '').toString().compareTo((a['scheduled_time'] ?? '').toString()));
    final currentTrip = inProgressTrips.isNotEmpty ? inProgressTrips.first : null;
    
    return jsonResponse({
      'today_trips': todayTrips,
      'completed_trips': completedTrips,
      'pending_trips': pendingTrips,
      'total_distance': totalDistance,
      'total_passengers': totalPassengers,
      'assigned_vehicle': vehicle != null ? '${vehicle['brand']} ${vehicle['model']} (${vehicle['plate_number']})' : null,
      'current_trip_id': currentTrip?['id'],
    });
  }
  
  Future<Response> getEmployeeDashboard(Request request) async {
    final userId = request.context['userId'] as String;
    final db = DatabaseConfig.db;
    
    final employee = db.findOne('employees', where: {'user_id': userId});
    
    if (employee == null) {
      return jsonResponse({'error': 'Employee not found'}, statusCode: 404);
    }
    
    final employeeId = employee['id'];
    
    final tripPassengers = db.findAll('trip_passengers', filters: {'employee_id': employeeId});
    final now = DateTime.now();
    
    Map<String, dynamic>? nextTrip;
    for (final tp in tripPassengers) {
      final trip = db.findOne('trips', where: {'id': tp['trip_id'], 'status': 'scheduled'});
      if (trip != null && trip['scheduled_time'] != null) {
        final scheduledTime = trip['scheduled_time'].toString();
        if (scheduledTime.compareTo(now.toIso8601String()) > 0) {
          if (nextTrip == null || scheduledTime.compareTo(nextTrip['scheduled_time'].toString()) < 0) {
            final route = trip['route_id'] != null ? db.findOne('routes', where: {'id': trip['route_id']}) : null;
            nextTrip = {...trip, 'route_name': route?['name']};
          }
        }
      }
    }
    
    final monthStart = DateTime(now.year, now.month, 1).toIso8601String();
    int totalTripsThisMonth = 0;
    for (final tp in tripPassengers) {
      final trip = db.findOne('trips', where: {'id': tp['trip_id']});
      if (trip != null && (trip['scheduled_time']?.toString() ?? '').compareTo(monthStart) >= 0) {
        totalTripsThisMonth++;
      }
    }
    
    final attendances = db.findAll('attendance', filters: {'employee_id': employeeId, 'status': 'present'});
    final attendedTrips = attendances.where((a) =>
      (a['date']?.toString() ?? '').compareTo(monthStart) >= 0
    ).length;
    
    String? routeName;
    String? stopName;
    
    if (employee['assigned_route_id'] != null) {
      final route = db.findOne('routes', where: {'id': employee['assigned_route_id']});
      routeName = route?['name'];
    }
    
    if (employee['assigned_stop_id'] != null) {
      final stop = db.findOne('stops', where: {'id': employee['assigned_stop_id']});
      stopName = stop?['name'];
    }
    
    return jsonResponse({
      'has_upcoming_trip': nextTrip != null,
      'next_trip_id': nextTrip?['id'],
      'next_trip_time': nextTrip?['scheduled_time'],
      'next_trip_route': nextTrip?['route_name'],
      'total_trips_this_month': totalTripsThisMonth,
      'attended_trips': attendedTrips,
      'assigned_route': routeName,
      'assigned_stop': stopName,
    });
  }

  Future<Response> getEmployeeDashboardByUserId(Request request) async {
    final userId = request.params['userId'];
    final db = DatabaseConfig.db;
    
    final employee = db.findOne('employees', where: {'user_id': userId});
    
    if (employee == null) {
      return jsonResponse({'error': 'Employee not found'}, statusCode: 404);
    }
    
    final employeeId = employee['id'];
    
    final tripPassengers = db.findAll('trip_passengers', filters: {'employee_id': employeeId});
    final now = DateTime.now();
    
    Map<String, dynamic>? nextTrip;
    for (final tp in tripPassengers) {
      final trip = db.findOne('trips', where: {'id': tp['trip_id'], 'status': 'scheduled'});
      if (trip != null && trip['scheduled_time'] != null) {
        final scheduledTime = trip['scheduled_time'].toString();
        if (scheduledTime.compareTo(now.toIso8601String()) > 0) {
          if (nextTrip == null || scheduledTime.compareTo(nextTrip['scheduled_time'].toString()) < 0) {
            final route = trip['route_id'] != null ? db.findOne('routes', where: {'id': trip['route_id']}) : null;
            final vehicle = trip['vehicle_id'] != null ? db.findOne('vehicles', where: {'id': trip['vehicle_id']}) : null;
            final driver = trip['driver_id'] != null ? db.findOne('users', where: {'id': trip['driver_id']}) : null;
            nextTrip = {
              ...trip,
              'routeName': route?['name'] ?? '',
              'vehiclePlate': vehicle?['plate_number'] ?? '',
              'driverName': driver != null ? '${driver['first_name']} ${driver['last_name']}' : '',
            };
          }
        }
      }
    }

    final today = now.toIso8601String().substring(0, 10);
    int todayTrips = 0;
    int completedTrips = 0;
    int weekTrips = 0;
    final weekStart = now.subtract(Duration(days: now.weekday - 1)).toIso8601String().substring(0, 10);
    
    for (final tp in tripPassengers) {
      final trip = db.findOne('trips', where: {'id': tp['trip_id']});
      if (trip != null) {
        final st = trip['scheduled_time']?.toString() ?? '';
        if (st.startsWith(today)) {
          todayTrips++;
          if (trip['status'] == 'completed') completedTrips++;
        }
        if (st.compareTo(weekStart) >= 0) weekTrips++;
      }
    }
    
    final monthStart = DateTime(now.year, now.month, 1).toIso8601String();
    int totalTripsThisMonth = 0;
    for (final tp in tripPassengers) {
      final trip = db.findOne('trips', where: {'id': tp['trip_id']});
      if (trip != null && (trip['scheduled_time']?.toString() ?? '').compareTo(monthStart) >= 0) {
        totalTripsThisMonth++;
      }
    }
    
    String? routeName;
    String? stopName;
    
    if (employee['assigned_route_id'] != null) {
      final route = db.findOne('routes', where: {'id': employee['assigned_route_id']});
      routeName = route?['name'];
    }
    
    if (employee['assigned_stop_id'] != null) {
      final stop = db.findOne('stops', where: {'id': employee['assigned_stop_id']});
      stopName = stop?['name'];
    }
    
    return jsonResponse({
      'has_upcoming_trip': nextTrip != null,
      'next_trip': nextTrip,
      'next_trip_id': nextTrip?['id'],
      'next_trip_time': nextTrip?['scheduled_time'],
      'next_trip_route': nextTrip?['routeName'] ?? nextTrip?['route_name'],
      'todayTrips': todayTrips,
      'weekTrips': weekTrips,
      'completedTrips': completedTrips,
      'pendingRequests': 0,
      'total_trips_this_month': totalTripsThisMonth,
      'assigned_route': routeName,
      'assigned_stop': stopName,
    });
  }
}
