import 'in_memory_db.dart';
import 'package:bcrypt/bcrypt.dart';

class SeedData {
  static void seed(InMemoryDatabase db) {
    // Create tables
    db.createTable('users');
    db.createTable('employees');
    db.createTable('drivers');
    db.createTable('vehicles');
    db.createTable('routes');
    db.createTable('stops');
    db.createTable('route_stops');
    db.createTable('trips');
    db.createTable('trip_passengers');
    db.createTable('attendance');
    db.createTable('gps_logs');
    db.createTable('fuel_logs');
    db.createTable('maintenance');
    db.createTable('vehicle_inspections');
    db.createTable('incidents');
    db.createTable('sos_alerts');
    db.createTable('notifications');
    db.createTable('transport_requests');
    db.createTable('companies');
    db.createTable('billing_records');
    db.createTable('invoices');
    db.createTable('settings');
    db.createTable('company_settings');
    db.createTable('trip_otps');
    db.createTable('role_permissions');
    db.createTable('trip_schedules');
    db.createTable('rosters');
    db.createTable('roster_requests');
    db.createTable('vehicle_documents');
    db.createTable('ncns_log');
    db.createTable('hcm_configs');

    // Seed company
    db.insert('companies', {
      'id': 'comp_001',
      'name': 'TechCorp Solutions',
      'slug': 'techcorp',
      'email': 'admin@techcorp.com',
      'phone': '+91 22 1234 5678',
      'address': '42 Tech Park, Andheri East',
      'city': 'Mumbai',
      'state': 'Maharashtra',
      'country': 'India',
      'postal_code': '400069',
      'is_active': true,
      'plan': 'basic',
      'primary_color': '#1E40AF',
      'trip_cost_per_trip': 100.0,
      'minimum_km_for_billing': 5.0,
      'monthly_trip_limit': 200,
      'subscription_status': 'active',
      'trips_used_this_month': 3,
      'created_at': DateTime.now().toIso8601String(),
    });

    db.insert('companies', {
      'id': 'comp_002',
      'name': 'Global Logistics Inc',
      'slug': 'globallogistics',
      'email': 'admin@globallogistics.com',
      'phone': '+91 11 9876 5432',
      'address': '15 Industrial Area, phase 2',
      'city': 'Delhi',
      'state': 'Delhi',
      'country': 'India',
      'postal_code': '110020',
      'is_active': true,
      'plan': 'pro',
      'primary_color': '#059669',
      'trip_cost_per_trip': 150.0,
      'minimum_km_for_billing': 2.0,
      'monthly_trip_limit': 500,
      'subscription_status': 'active',
      'trips_used_this_month': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    db.insert('companies', {
      'id': 'comp_003',
      'name': 'CityTrans Solutions',
      'slug': 'citytrans',
      'email': 'admin@citytrans.com',
      'phone': '+91 80 5555 1234',
      'address': '78 Brigade Road',
      'city': 'Bangalore',
      'state': 'Karnataka',
      'country': 'India',
      'postal_code': '560001',
      'is_active': true,
      'plan': 'enterprise',
      'primary_color': '#7C3AED',
      'trip_cost_per_trip': 200.0,
      'minimum_km_for_billing': 1.5,
      'monthly_trip_limit': 1000,
      'subscription_status': 'active',
      'trips_used_this_month': 0,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Seed users
    final passwordHash = BCrypt.hashpw('password123', BCrypt.gensalt());

    // Seed super admin user
    db.insert('users', {
      'id': 'usr_super_01',
      'email': 'superadmin@etm.com',
      'first_name': 'Super',
      'last_name': 'Admin',
      'phone': '+91 90000 00000',
      'password_hash': passwordHash,
      'role': 'super_admin',
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Admin
    db.insert('users', {
      'id': 'usr_admin_01',
      'email': 'admin@techcorp.com',
      'first_name': 'Rajesh',
      'last_name': 'Kumar',
      'phone': '+91 98765 43210',
      'password_hash': passwordHash,
      'role': 'admin',
      'company_id': 'comp_001',
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Drivers
    final drivers = [
      {'id': 'usr_drv_01', 'email': 'john.driver@techcorp.com', 'first_name': 'John', 'last_name': 'Doe', 'phone': '+91 98765 11111'},
      {'id': 'usr_drv_02', 'email': 'mike.driver@techcorp.com', 'first_name': 'Mike', 'last_name': 'Smith', 'phone': '+91 98765 22222'},
      {'id': 'usr_drv_03', 'email': 'sarah.driver@techcorp.com', 'first_name': 'Sarah', 'last_name': 'Wilson', 'phone': '+91 98765 33333'},
    ];

    for (var drv in drivers) {
      db.insert('users', {
        ...drv,
        'password_hash': passwordHash,
        'role': 'driver',
        'company_id': 'comp_001',
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
      });

      db.insert('drivers', {
        'id': '${drv['id']}_drv',
        'user_id': drv['id'],
        'company_id': 'comp_001',
        'license_number': 'DL-${10000000 + drivers.indexOf(drv) * 11111111}',
        'license_expiry': DateTime(2026, 12, 31).toIso8601String(),
        'phone': drv['phone'],
        'rating': 4.5 + drivers.indexOf(drv) * 0.1,
        'total_trips': 50 + drivers.indexOf(drv) * 30,
        'is_available': true,
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    // Employees
    final employees = [
      {'id': 'usr_emp_01', 'email': 'alice@techcorp.com', 'first_name': 'Alice', 'last_name': 'Johnson', 'code': 'EMP001', 'dept': 'Engineering', 'desig': 'Senior Developer'},
      {'id': 'usr_emp_02', 'email': 'bob@techcorp.com', 'first_name': 'Bob', 'last_name': 'Williams', 'code': 'EMP002', 'dept': 'Marketing', 'desig': 'Marketing Manager'},
      {'id': 'usr_emp_03', 'email': 'charlie@techcorp.com', 'first_name': 'Charlie', 'last_name': 'Brown', 'code': 'EMP003', 'dept': 'Engineering', 'desig': 'Software Engineer'},
      {'id': 'usr_emp_04', 'email': 'diana@techcorp.com', 'first_name': 'Diana', 'last_name': 'Ross', 'code': 'EMP004', 'dept': 'HR', 'desig': 'HR Manager'},
      {'id': 'usr_emp_05', 'email': 'edward@techcorp.com', 'first_name': 'Edward', 'last_name': 'Norton', 'code': 'EMP005', 'dept': 'Finance', 'desig': 'Accountant'},
    ];

    for (var emp in employees) {
      db.insert('users', {
        'id': emp['id'],
        'email': emp['email'],
        'first_name': emp['first_name'],
        'last_name': emp['last_name'],
        'phone': '+91 98765 ${(employees.indexOf(emp) + 4) * 11111}',
        'password_hash': passwordHash,
        'role': 'employee',
        'company_id': 'comp_001',
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
      });

      db.insert('employees', {
        'id': '${emp['id']}_emp',
        'user_id': emp['id'],
        'company_id': 'comp_001',
        'employee_code': emp['code'],
        'department': emp['dept'],
        'designation': emp['desig'],
        'is_transport_required': true,
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    // Vehicles
    final vehicles = [
      {'id': 'veh_001', 'plate_number': 'MH-12-AB-1234', 'model': 'Tata Ace', 'brand': 'Tata', 'year': 2022, 'seating_capacity': 20, 'color': 'White', 'status': 'active', 'driver_id': 'usr_drv_01_drv'},
      {'id': 'veh_002', 'plate_number': 'MH-12-CD-5678', 'model': 'Eeco', 'brand': 'Maruti', 'year': 2021, 'seating_capacity': 15, 'color': 'Silver', 'status': 'active', 'driver_id': 'usr_drv_02_drv'},
      {'id': 'veh_003', 'plate_number': 'MH-12-EF-9012', 'model': 'Traveller', 'brand': 'Force', 'year': 2023, 'seating_capacity': 26, 'color': 'White', 'status': 'active', 'driver_id': 'usr_drv_03_drv'},
    ];

    for (var veh in vehicles) {
      db.insert('vehicles', {
        ...veh,
        'company_id': 'comp_001',
        'current_latitude': 19.0760 + (vehicles.indexOf(veh) * 0.005),
        'current_longitude': 72.8777 + (vehicles.indexOf(veh) * 0.005),
        'last_location_update': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    // Stops
    final stops = [
      {'id': 'stop_001', 'name': 'Andheri Station West', 'latitude': 19.1197, 'longitude': 72.8464, 'address': 'Andheri West Station Road'},
      {'id': 'stop_002', 'name': 'SEEPZ', 'latitude': 19.1210, 'longitude': 72.8803, 'address': 'SEEPZ MIDC, Andheri East'},
      {'id': 'stop_003', 'name': 'MIDC Marol', 'latitude': 19.1247, 'longitude': 72.8856, 'address': 'Marol Naka, Andheri East'},
      {'id': 'stop_004', 'name': 'Powai Lake', 'latitude': 19.1309, 'longitude': 72.9073, 'address': 'Powai Lake, Powai'},
      {'id': 'stop_005', 'name': 'Hiranandani Gardens', 'latitude': 19.1352, 'longitude': 72.9238, 'address': 'Hiranandani Gardens, Powai'},
      {'id': 'stop_006', 'name': 'Goregaon East', 'latitude': 19.1663, 'longitude': 72.8526, 'address': 'Goregaon East, Film City Road'},
      {'id': 'stop_007', 'name': 'Malad East', 'latitude': 19.1875, 'longitude': 72.8485, 'address': 'Malad East, Mindspace'},
      {'id': 'stop_008', 'name': 'TechCorp Office', 'latitude': 19.1300, 'longitude': 72.8900, 'address': '42 Tech Park, Andheri East'},
    ];

    for (var stop in stops) {
      db.insert('stops', {
        ...stop,
        'company_id': 'comp_001',
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    // Routes
    final route1Id = 'route_001';
    db.insert('routes', {
      'id': route1Id,
      'name': 'Route A - Western Line',
      'description': 'Western suburbs to TechCorp office',
      'company_id': 'comp_001',
      'total_distance': 15.5,
      'estimated_duration': 45,
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Route stops
    final routeStops = [
      {'route_id': route1Id, 'stop_id': 'stop_001', 'name': 'Andheri Station West', 'order': 0, 'lat': 19.1197, 'lng': 72.8464, 'time': 0, 'dist': 0},
      {'route_id': route1Id, 'stop_id': 'stop_002', 'name': 'SEEPZ', 'order': 1, 'lat': 19.1210, 'lng': 72.8803, 'time': 600, 'dist': 3200},
      {'route_id': route1Id, 'stop_id': 'stop_003', 'name': 'MIDC Marol', 'order': 2, 'lat': 19.1247, 'lng': 72.8856, 'time': 300, 'dist': 800},
      {'route_id': route1Id, 'stop_id': 'stop_008', 'name': 'TechCorp Office', 'order': 3, 'lat': 19.1300, 'lng': 72.8900, 'time': 600, 'dist': 1500},
    ];

    for (var rs in routeStops) {
      db.insert('route_stops', {
        'id': '${rs['route_id']}_${rs['order']}',
        'route_id': rs['route_id'],
        'stop_id': rs['stop_id'],
        'name': rs['name'],
        'latitude': rs['lat'],
        'longitude': rs['lng'],
        'sequence_order': rs['order'],
        'estimated_time_from_previous': rs['time'],
        'distance_from_previous': rs['dist'],
      });
    }

    // Route 2
    final route2Id = 'route_002';
    db.insert('routes', {
      'id': route2Id,
      'name': 'Route B - Eastern Line',
      'description': 'Eastern suburbs to TechCorp office',
      'company_id': 'comp_001',
      'total_distance': 22.3,
      'estimated_duration': 60,
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
    });

    final route2Stops = [
      {'route_id': route2Id, 'stop_id': 'stop_006', 'name': 'Goregaon East', 'order': 0, 'lat': 19.1663, 'lng': 72.8526, 'time': 0, 'dist': 0},
      {'route_id': route2Id, 'stop_id': 'stop_007', 'name': 'Malad East', 'order': 1, 'lat': 19.1875, 'lng': 72.8485, 'time': 600, 'dist': 2800},
      {'route_id': route2Id, 'stop_id': 'stop_004', 'name': 'Powai Lake', 'order': 2, 'lat': 19.1309, 'lng': 72.9073, 'time': 1200, 'dist': 8500},
      {'route_id': route2Id, 'stop_id': 'stop_005', 'name': 'Hiranandani Gardens', 'order': 3, 'lat': 19.1352, 'lng': 72.9238, 'time': 300, 'dist': 1800},
      {'route_id': route2Id, 'stop_id': 'stop_008', 'name': 'TechCorp Office', 'order': 4, 'lat': 19.1300, 'lng': 72.8900, 'time': 900, 'dist': 3200},
    ];

    for (var rs in route2Stops) {
      db.insert('route_stops', {
        'id': '${rs['route_id']}_${rs['order']}',
        'route_id': rs['route_id'],
        'stop_id': rs['stop_id'],
        'name': rs['name'],
        'latitude': rs['lat'],
        'longitude': rs['lng'],
        'sequence_order': rs['order'],
        'estimated_time_from_previous': rs['time'],
        'distance_from_previous': rs['dist'],
      });
    }

    // Assign employees to routes/stops
    final employeeIds = ['usr_emp_01_emp', 'usr_emp_02_emp', 'usr_emp_03_emp', 'usr_emp_04_emp', 'usr_emp_05_emp'];
    final assignedRoutes = [route1Id, route1Id, route2Id, route1Id, route2Id];
    final assignedStops = ['stop_001', 'stop_002', 'stop_006', 'stop_003', 'stop_004'];

    for (var i = 0; i < employeeIds.length; i++) {
      db.update('employees', {
        'assigned_route_id': assignedRoutes[i],
        'assigned_stop_id': assignedStops[i],
      }, where: {'id': employeeIds[i]});
    }

    // Create trips
    final now = DateTime.now();
    final morningTime = DateTime(now.year, now.month, now.day, 8, 0);
    final eveningTime = DateTime(now.year, now.month, now.day, 17, 0);

    db.insert('trips', {
      'id': 'trip_001',
      'route_id': route1Id,
      'vehicle_id': 'veh_001',
      'driver_id': 'usr_drv_01',
      'type': 'pickup',
      'status': 'completed',
      'scheduled_time': morningTime.toIso8601String(),
      'actual_start_time': morningTime.add(const Duration(minutes: 5)).toIso8601String(),
      'actual_end_time': morningTime.add(const Duration(minutes: 42)).toIso8601String(),
      'company_id': 'comp_001',
      'total_passengers': 3,
      'boarded_passengers': 3,
      'total_distance': 14.8,
      'created_at': DateTime.now().toIso8601String(),
    });

    db.insert('trips', {
      'id': 'trip_002',
      'route_id': route1Id,
      'vehicle_id': 'veh_001',
      'driver_id': 'usr_drv_01',
      'type': 'dropoff',
      'status': 'scheduled',
      'scheduled_time': eveningTime.toIso8601String(),
      'company_id': 'comp_001',
      'total_passengers': 3,
      'boarded_passengers': 0,
      'total_distance': 14.8,
      'created_at': DateTime.now().toIso8601String(),
    });

    db.insert('trips', {
      'id': 'trip_003',
      'route_id': route2Id,
      'vehicle_id': 'veh_002',
      'driver_id': 'usr_drv_02',
      'type': 'pickup',
      'status': 'completed',
      'scheduled_time': morningTime.add(const Duration(minutes: 15)).toIso8601String(),
      'actual_start_time': morningTime.add(const Duration(minutes: 18)).toIso8601String(),
      'actual_end_time': morningTime.add(const Duration(minutes: 70)).toIso8601String(),
      'company_id': 'comp_001',
      'total_passengers': 2,
      'boarded_passengers': 2,
      'total_distance': 21.5,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Trip passengers
    db.insert('trip_passengers', {
      'id': 'tp_001', 'trip_id': 'trip_001', 'employee_id': 'usr_emp_01_emp', 'stop_id': 'stop_001',
      'is_boarded': true, 'is_dropped': false, 'boarded_at': morningTime.add(const Duration(minutes: 8)).toIso8601String(),
    });
    db.insert('trip_passengers', {
      'id': 'tp_002', 'trip_id': 'trip_001', 'employee_id': 'usr_emp_02_emp', 'stop_id': 'stop_002',
      'is_boarded': true, 'is_dropped': false, 'boarded_at': morningTime.add(const Duration(minutes: 22)).toIso8601String(),
    });
    db.insert('trip_passengers', {
      'id': 'tp_003', 'trip_id': 'trip_001', 'employee_id': 'usr_emp_04_emp', 'stop_id': 'stop_003',
      'is_boarded': true, 'is_dropped': false, 'boarded_at': morningTime.add(const Duration(minutes: 32)).toIso8601String(),
    });

    // Attendance
    db.insert('attendance', {
      'id': 'att_001', 'employee_id': 'usr_emp_01_emp', 'date': now.toIso8601String(),
      'status': 'present', 'trip_id': 'trip_001', 'boarding_method': 'qr',
      'check_in_time': morningTime.add(const Duration(minutes: 8)).toIso8601String(),
      'company_id': 'comp_001',
    });
    db.insert('attendance', {
      'id': 'att_002', 'employee_id': 'usr_emp_02_emp', 'date': now.toIso8601String(),
      'status': 'present', 'trip_id': 'trip_001', 'boarding_method': 'qr',
      'check_in_time': morningTime.add(const Duration(minutes: 22)).toIso8601String(),
      'company_id': 'comp_001',
    });
    db.insert('attendance', {
      'id': 'att_003', 'employee_id': 'usr_emp_04_emp', 'date': now.toIso8601String(),
      'status': 'present', 'trip_id': 'trip_001', 'boarding_method': 'manual',
      'check_in_time': morningTime.add(const Duration(minutes: 32)).toIso8601String(),
      'company_id': 'comp_001',
    });

    // Notifications
    db.insert('notifications', {
      'id': 'notif_001', 'user_id': 'usr_emp_01', 'type': 'trip',
      'title': 'Trip Reminder', 'body': 'Your morning pickup trip is scheduled in 30 minutes',
      'is_read': false, 'company_id': 'comp_001',
      'created_at': DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
    });
    db.insert('notifications', {
      'id': 'notif_002', 'user_id': 'usr_drv_01', 'type': 'trip',
      'title': 'New Trip Assigned', 'body': 'You have a new pickup trip assigned for Route A at 08:00 AM',
      'is_read': true, 'company_id': 'comp_001',
      'created_at': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
    });

    // Sample billing records for comp_001
    final billMonth = DateTime.now().toIso8601String().substring(0, 7);
    db.insert('billing_records', {
      'id': 'bill_trip_001',
      'company_id': 'comp_001',
      'trip_id': 'trip_001',
      'month': billMonth,
      'total_distance': 14.8,
      'trip_cost': 100.0,
      'is_billable': true,
      'needs_review': false,
      'created_at': DateTime.now().toIso8601String(),
    });
    db.insert('billing_records', {
      'id': 'bill_trip_003',
      'company_id': 'comp_001',
      'trip_id': 'trip_003',
      'month': billMonth,
      'total_distance': 21.5,
      'trip_cost': 100.0,
      'is_billable': true,
      'needs_review': false,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Sample rosters for this week
    final today = DateTime.now();
    final monday = today.subtract(Duration(days: today.weekday - 1));
    for (var i = 0; i < 5; i++) {
      final date = monday.add(Duration(days: i));
      final dateStr = date.toIso8601String().substring(0, 10);
      for (var empId in employeeIds) {
        db.insert('rosters', {
          'id': 'rost_${dateStr}_${empId}',
          'employee_id': empId,
          'company_id': 'comp_001',
          'date': dateStr,
          'route_id': assignedRoutes[employeeIds.indexOf(empId)],
          'stop_id': assignedStops[employeeIds.indexOf(empId)],
          'shift_type': i < 3 ? 'morning' : 'evening',
          'status': 'approved',
          'is_active': true,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    }

    // Sample vehicle documents
    db.insert('vehicle_documents', {
      'id': 'vdoc_001', 'vehicle_id': 'veh_001', 'company_id': 'comp_001',
      'document_type': 'rc', 'document_number': 'MH12AB1234',
      'issue_date': '2022-01-15', 'expiry_date': '2037-01-15',
      'document_url': '', 'status': 'valid',
      'created_at': DateTime.now().toIso8601String(),
    });
    db.insert('vehicle_documents', {
      'id': 'vdoc_002', 'vehicle_id': 'veh_001', 'company_id': 'comp_001',
      'document_type': 'insurance', 'document_number': 'INS-2024-001',
      'issue_date': '2024-04-01', 'expiry_date': '2025-03-31',
      'document_url': '', 'status': 'expiring_soon',
      'created_at': DateTime.now().toIso8601String(),
    });
    db.insert('vehicle_documents', {
      'id': 'vdoc_003', 'vehicle_id': 'veh_002', 'company_id': 'comp_001',
      'document_type': 'puc', 'document_number': 'PUC-2024-002',
      'issue_date': '2024-06-01', 'expiry_date': '2025-05-31',
      'document_url': '', 'status': 'valid',
      'created_at': DateTime.now().toIso8601String(),
    });
    db.insert('vehicle_documents', {
      'id': 'vdoc_004', 'vehicle_id': 'veh_003', 'company_id': 'comp_001',
      'document_type': 'permit', 'document_number': 'PER-2024-003',
      'issue_date': '2024-02-15', 'expiry_date': '2025-02-14',
      'document_url': '', 'status': 'expired',
      'created_at': DateTime.now().toIso8601String(),
    });

    print('Database seeded successfully!');
    print('  - 3 Companies');
    print('  - ${2 + drivers.length + employees.length} Users');
    print('  - ${drivers.length} Drivers');
    print('  - ${employees.length} Employees');
    print('  - ${vehicles.length} Vehicles');
    print('  - ${stops.length} Stops');
    print('  - 2 Routes');
    print('  - 3 Trips');
    print('  - 3 Attendance records');
    print('  - 2 Notifications');
    print('  - 2 Billing records');
    print('  - ${employeeIds.length * 5} Roster entries');
    print('  - 4 Vehicle documents');
  }
}
