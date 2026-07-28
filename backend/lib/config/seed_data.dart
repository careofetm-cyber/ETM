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
      'created_at': DateTime.now().toIso8601String(),
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
      'created_at': DateTime.now().toIso8601String(),
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
      'created_at': DateTime.now().toIso8601String(),
    });

    // Default shifts
    db.insert('shifts', {
      'id': 'shift_001',
      'name': 'Morning Shift',
      'code': 'morning',
      'start_time': '06:00',
      'end_time': '14:00',
      'company_id': 'comp_001',
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
    });
    db.insert('shifts', {
      'id': 'shift_002',
      'name': 'Evening Shift',
      'code': 'evening',
      'start_time': '14:00',
      'end_time': '22:00',
      'company_id': 'comp_001',
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
    });
    db.insert('shifts', {
      'id': 'shift_003',
      'name': 'Night Shift',
      'code': 'night',
      'start_time': '22:00',
      'end_time': '06:00',
      'company_id': 'comp_001',
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
    });

    print('Database seeded successfully!');
    print('  - 1 Company');
    print('  - 2 Users (Super Admin + Company Admin)');
    print('  - 3 Shift definitions');
  }
}
