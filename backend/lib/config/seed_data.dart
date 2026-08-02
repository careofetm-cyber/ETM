import 'in_memory_db.dart';
import 'package:bcrypt/bcrypt.dart';

class SeedData {
  static void seed(InMemoryDatabase db) {
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
    db.createTable('shifts');

    final passwordHash = BCrypt.hashpw('password123', BCrypt.gensalt());
    final now = DateTime.now();
    final nowStr = now.toIso8601String();
    final today = nowStr.substring(0, 10);

    // Company
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
      'trips_used_this_month': 0,
      'created_at': nowStr,
    });

    db.insert('company_settings', {
      'id': 'cs_comp_001',
      'company_id': 'comp_001',
      'employee_id_prefix': 'EMP',
      'employee_id_digits': '4',
      'home_location_enabled': true,
      'created_at': nowStr,
    });

    // Super Admin
    db.insert('users', {
      'id': 'usr_super_01',
      'email': 'superadmin@etm.com',
      'first_name': 'Super',
      'last_name': 'Admin',
      'phone': '+91 90000 00000',
      'password_hash': passwordHash,
      'role': 'super_admin',
      'is_active': true,
      'created_at': nowStr,
    });

    // Company Admin
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
      'created_at': nowStr,
    });

    // === DEMO DRIVERS ===
    final driverUsers = [
      {'id': 'drv_usr_01', 'email': 'driver1@techcorp.com', 'first_name': 'Amit', 'last_name': 'Sharma', 'phone': '+91 98000 00001'},
      {'id': 'drv_usr_02', 'email': 'driver2@techcorp.com', 'first_name': 'Vikram', 'last_name': 'Singh', 'phone': '+91 98000 00002'},
    ];
    for (final u in driverUsers) {
      db.insert('users', {
        ...u,
        'password_hash': passwordHash,
        'role': 'driver',
        'company_id': 'comp_001',
        'is_active': true,
        'created_at': nowStr,
      });
    }
    db.insert('drivers', {
      'id': 'drv_usr_01_drv',
      'user_id': 'drv_usr_01',
      'company_id': 'comp_001',
      'license_number': 'MH-2023-0001',
      'license_expiry': '2028-12-31',
      'is_available': true,
      'created_at': nowStr,
    });
    db.insert('drivers', {
      'id': 'drv_usr_02_drv',
      'user_id': 'drv_usr_02',
      'company_id': 'comp_001',
      'license_number': 'MH-2023-0002',
      'license_expiry': '2028-12-31',
      'is_available': true,
      'created_at': nowStr,
    });

    // === DEMO EMPLOYEES ===
    final employeeUsers = [
      {'id': 'emp_usr_01', 'email': 'priya.patel@techcorp.com', 'first_name': 'Priya', 'last_name': 'Patel', 'phone': '+91 97000 00001'},
      {'id': 'emp_usr_02', 'email': 'ankit.mehta@techcorp.com', 'first_name': 'Ankit', 'last_name': 'Mehta', 'phone': '+91 97000 00002'},
      {'id': 'emp_usr_03', 'email': 'sneha.reddy@techcorp.com', 'first_name': 'Sneha', 'last_name': 'Reddy', 'phone': '+91 97000 00003'},
      {'id': 'emp_usr_04', 'email': 'rahul.gupta@techcorp.com', 'first_name': 'Rahul', 'last_name': 'Gupta', 'phone': '+91 97000 00004'},
    ];
    for (final u in employeeUsers) {
      db.insert('users', {
        ...u,
        'password_hash': passwordHash,
        'role': 'employee',
        'company_id': 'comp_001',
        'is_active': true,
        'created_at': nowStr,
      });
    }
    final employeeData = [
      {'id': 'emp_usr_01_emp', 'user_id': 'emp_usr_01', 'employee_code': 'EMP001', 'department': 'Engineering', 'designation': 'Senior Developer', 'home_latitude': 19.0760, 'home_longitude': 72.8777, 'home_address': 'Andheri West, Mumbai'},
      {'id': 'emp_usr_02_emp', 'user_id': 'emp_usr_02', 'employee_code': 'EMP002', 'department': 'Engineering', 'designation': 'Tech Lead', 'home_latitude': 19.0596, 'home_longitude': 72.8295, 'home_address': 'Bandra East, Mumbai'},
      {'id': 'emp_usr_03_emp', 'user_id': 'emp_usr_03', 'employee_code': 'EMP003', 'department': 'Design', 'designation': 'UX Designer', 'home_latitude': 19.1197, 'home_longitude': 72.8896, 'home_address': 'Powai, Mumbai'},
      {'id': 'emp_usr_04_emp', 'user_id': 'emp_usr_04', 'employee_code': 'EMP004', 'department': 'Product', 'designation': 'Product Manager', 'home_latitude': 19.0430, 'home_longitude': 72.8686, 'home_address': 'Lower Parel, Mumbai'},
    ];
    for (final e in employeeData) {
      db.insert('employees', {
        ...e,
        'company_id': 'comp_001',
        'is_transport_required': true,
        'created_at': nowStr,
      });
    }

    // === DEMO VEHICLES ===
    final vehicles = [
      {'id': 'veh_001', 'plate_number': 'MH-01-AB-1234', 'model': 'Traveller', 'brand': 'Tata', 'year': 2023, 'seating_capacity': 12, 'color': 'White', 'status': 'active', 'driver_id': 'drv_usr_01_drv'},
      {'id': 'veh_002', 'plate_number': 'MH-02-CD-5678', 'model': 'Eeco', 'brand': 'Maruti', 'year': 2022, 'seating_capacity': 7, 'color': 'Silver', 'status': 'active', 'driver_id': 'drv_usr_02_drv'},
    ];
    for (final v in vehicles) {
      db.insert('vehicles', {
        ...v,
        'company_id': 'comp_001',
        'created_at': nowStr,
      });
    }

    // === DEMO ROUTES ===
    db.insert('routes', {
      'id': 'route_001',
      'name': 'Andheri - TechPark (Morning)',
      'company_id': 'comp_001',
      'description': 'Morning pickup route from Andheri to TechPark',
      'total_distance': 12.5,
      'estimated_duration': 30,
      'is_active': true,
      'created_at': nowStr,
    });
    db.insert('routes', {
      'id': 'route_002',
      'name': 'Bandra - TechPark (Morning)',
      'company_id': 'comp_001',
      'description': 'Morning pickup route from Bandra to TechPark',
      'total_distance': 14.2,
      'estimated_duration': 35,
      'is_active': true,
      'created_at': nowStr,
    });
    db.insert('routes', {
      'id': 'route_003',
      'name': 'TechPark - Andheri (Evening)',
      'company_id': 'comp_001',
      'description': 'Evening drop route from TechPark to Andheri',
      'total_distance': 12.5,
      'estimated_duration': 30,
      'is_active': true,
      'created_at': nowStr,
    });

    // === DEMO STOPS ===
    db.insert('stops', {
      'id': 'stop_001', 'name': 'Andheri Station', 'route_id': 'route_001', 'latitude': 19.0760, 'longitude': 72.8777, 'sequence': 1, 'company_id': 'comp_001', 'created_at': nowStr,
    });
    db.insert('stops', {
      'id': 'stop_002', 'name': 'MIDC Junction', 'route_id': 'route_001', 'latitude': 19.0900, 'longitude': 72.8750, 'sequence': 2, 'company_id': 'comp_001', 'created_at': nowStr,
    });
    db.insert('stops', {
      'id': 'stop_003', 'name': 'Bandra Station', 'route_id': 'route_002', 'latitude': 19.0596, 'longitude': 72.8295, 'sequence': 1, 'company_id': 'comp_001', 'created_at': nowStr,
    });
    db.insert('stops', {
      'id': 'stop_004', 'name': 'Kurla Signal', 'route_id': 'route_002', 'latitude': 19.0750, 'longitude': 72.8500, 'sequence': 2, 'company_id': 'comp_001', 'created_at': nowStr,
    });

    // === DEMO TRIPS (Morning today + one scheduled) ===
    final morningTime = '${today}T07:30:00.000';
    final eveningTime = '${today}T17:30:00.000';
    final tomorrow = DateTime(now.year, now.month, now.day + 1).toIso8601String().substring(0, 10);
    final tomorrowMorning = '${tomorrow}T07:30:00.000';

    // Trip 1: Morning pickup (in-progress for driver 1)
    db.insert('trips', {
      'id': 'trip_001',
      'route_id': 'route_001',
      'vehicle_id': 'veh_001',
      'driver_id': 'drv_usr_01_drv',
      'type': 'pickup',
      'status': 'inProgress',
      'scheduled_time': morningTime,
      'actual_start_time': morningTime,
      'total_passengers': 2,
      'company_id': 'comp_001',
      'created_at': nowStr,
    });

    // Trip 2: Morning pickup (scheduled for tomorrow)
    db.insert('trips', {
      'id': 'trip_002',
      'route_id': 'route_002',
      'vehicle_id': 'veh_002',
      'driver_id': 'drv_usr_02_drv',
      'type': 'pickup',
      'status': 'scheduled',
      'scheduled_time': tomorrowMorning,
      'total_passengers': 2,
      'company_id': 'comp_001',
      'created_at': nowStr,
    });

    // Trip 3: Evening drop (scheduled)
    db.insert('trips', {
      'id': 'trip_003',
      'route_id': 'route_003',
      'vehicle_id': 'veh_001',
      'driver_id': 'drv_usr_01_drv',
      'type': 'drop',
      'status': 'scheduled',
      'scheduled_time': eveningTime,
      'total_passengers': 2,
      'company_id': 'comp_001',
      'created_at': nowStr,
    });

    // === TRIP PASSENGERS ===
    db.insert('trip_passengers', {
      'id': 'tp_001', 'trip_id': 'trip_001', 'employee_id': 'emp_usr_01_emp', 'stop_id': 'stop_001', 'is_boarded': true, 'boarded_at': morningTime, 'is_dropped': false, 'created_at': nowStr,
    });
    db.insert('trip_passengers', {
      'id': 'tp_002', 'trip_id': 'trip_001', 'employee_id': 'emp_usr_03_emp', 'stop_id': 'stop_002', 'is_boarded': false, 'is_dropped': false, 'created_at': nowStr,
    });
    db.insert('trip_passengers', {
      'id': 'tp_003', 'trip_id': 'trip_002', 'employee_id': 'emp_usr_02_emp', 'stop_id': 'stop_003', 'is_boarded': false, 'is_dropped': false, 'created_at': nowStr,
    });
    db.insert('trip_passengers', {
      'id': 'tp_004', 'trip_id': 'trip_002', 'employee_id': 'emp_usr_04_emp', 'stop_id': 'stop_004', 'is_boarded': false, 'is_dropped': false, 'created_at': nowStr,
    });
    db.insert('trip_passengers', {
      'id': 'tp_005', 'trip_id': 'trip_003', 'employee_id': 'emp_usr_01_emp', 'stop_id': 'stop_001', 'is_boarded': false, 'is_dropped': false, 'created_at': nowStr,
    });
    db.insert('trip_passengers', {
      'id': 'tp_006', 'trip_id': 'trip_003', 'employee_id': 'emp_usr_03_emp', 'stop_id': 'stop_002', 'is_boarded': false, 'is_dropped': false, 'created_at': nowStr,
    });

    // === DEMO ROSTERS ===
    db.insert('rosters', {
      'id': 'roster_001',
      'employee_id': 'emp_usr_01_emp',
      'date': today,
      'shift_id': 'shift_001',
      'status': 'active',
      'route_id': 'route_001',
      'stop_id': 'stop_001',
      'company_id': 'comp_001',
      'created_at': nowStr,
    });
    db.insert('rosters', {
      'id': 'roster_002',
      'employee_id': 'emp_usr_02_emp',
      'date': tomorrow,
      'shift_id': 'shift_001',
      'status': 'active',
      'route_id': 'route_002',
      'stop_id': 'stop_003',
      'company_id': 'comp_001',
      'created_at': nowStr,
    });

    // Default shifts
    db.insert('shifts', {
      'id': 'shift_001', 'name': 'Morning Shift', 'code': 'morning', 'start_time': '06:00', 'end_time': '14:00', 'company_id': 'comp_001', 'is_active': true, 'created_at': nowStr,
    });
    db.insert('shifts', {
      'id': 'shift_002', 'name': 'Evening Shift', 'code': 'evening', 'start_time': '14:00', 'end_time': '22:00', 'company_id': 'comp_001', 'is_active': true, 'created_at': nowStr,
    });
    db.insert('shifts', {
      'id': 'shift_003', 'name': 'Night Shift', 'code': 'night', 'start_time': '22:00', 'end_time': '06:00', 'company_id': 'comp_001', 'is_active': true, 'created_at': nowStr,
    });

    print('Database seeded successfully!');
    print('  - 1 Company');
    print('  - 6 Users (1 super admin, 1 admin, 2 drivers, 4 employees)');
    print('  - 2 Drivers, 4 Employees');
    print('  - 2 Vehicles');
    print('  - 3 Routes, 4 Stops');
    print('  - 3 Trips (1 in-progress, 1 scheduled tomorrow, 1 scheduled today evening)');
    print('  - 6 Trip Passengers');
    print('  - 3 Shifts');
  }
}
