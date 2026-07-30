import 'dart:convert';
import 'dart:math';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';
import '../utils/notification_helper.dart';

class OtpRoutes {
  final router = Router();

  OtpRoutes() {
    router.post('/generate', authMiddleware()(generateOtp));
    router.post('/verify', authMiddleware()(verifyOtp));
    router.get('/trip/:tripId', authMiddleware()(getTripOtp));
    router.get('/employee/:employeeId', authMiddleware()(getEmployeeOtp));
    router.post('/regenerate', authMiddleware()(regenerateOtp));
  }

  Future<Response> generateOtp(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final tripId = body['tripId'] as String;
    final db = DatabaseConfig.db;

    final trip = db.findOne('trips', where: {'id': tripId});
    if (trip == null) {
      return errorResponse('Trip not found', statusCode: 404);
    }

    final otp = _generateOtpCode();
    final expiresAt = DateTime.now().add(const Duration(minutes: 10)).toIso8601String();

    db.insert('trip_otps', {
      'id': 'otp_${DateTime.now().millisecondsSinceEpoch}',
      'trip_id': tripId,
      'otp': otp,
      'is_verified': false,
      'expires_at': expiresAt,
      'created_at': DateTime.now().toIso8601String(),
    });

    final passengers = db.findAll('trip_passengers', filters: {'trip_id': tripId});
    for (final p in passengers) {
      final employee = db.findOne('employees', where: {'id': p['employee_id']});
      if (employee != null) {
        final user = db.findOne('users', where: {'id': employee['user_id']});
        if (user != null) {
          NotificationHelper.create(
            userId: user['id'],
            title: 'OTP Generated',
            message: 'An OTP has been generated for your trip.',
            type: 'otp_generated',
            referenceId: tripId,
            referenceType: 'trip',
            companyId: trip['company_id'],
          );
        }
      }
    }

    return jsonResponse({
      'otp': otp,
      'expiresAt': expiresAt,
      'tripId': tripId,
    });
  }

  Future<Response> verifyOtp(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final tripId = body['tripId'] as String;
    final otp = body['otp'] as String;
    final db = DatabaseConfig.db;

    final otpRecord = db.findAll('trip_otps', filters: {'trip_id': tripId});
    if (otpRecord.isEmpty) {
      return errorResponse('No OTP found for this trip', statusCode: 404);
    }

    otpRecord.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));
    final latestOtp = otpRecord.first;

    if (latestOtp['otp'] != otp) {
      return errorResponse('Invalid OTP', statusCode: 400);
    }

    final expiresAt = DateTime.parse(latestOtp['expires_at'] as String);
    if (DateTime.now().isAfter(expiresAt)) {
      return errorResponse('OTP has expired', statusCode: 400);
    }

    db.update('trip_otps', {'is_verified': true}, where: {'id': latestOtp['id']});
    db.update('trips', {
      'status': 'in_progress',
      'otp_verified_at': DateTime.now().toIso8601String(),
    }, where: {'id': tripId});

    return jsonResponse({'message': 'OTP verified, trip started', 'tripId': tripId});
  }

  Future<Response> getTripOtp(Request request) async {
    final tripId = request.params['tripId'];
    final db = DatabaseConfig.db;

    final otps = db.findAll('trip_otps', filters: {'trip_id': tripId});
    if (otps.isEmpty) {
      return jsonResponse({'otp': null, 'verified': false});
    }

    otps.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));
    final latest = otps.first;

    return jsonResponse({
      'otp': latest['otp'],
      'verified': latest['is_verified'],
      'expiresAt': latest['expires_at'],
    });
  }

  Future<Response> getEmployeeOtp(Request request) async {
    final employeeId = request.params['employeeId'];
    final db = DatabaseConfig.db;

    final employee = db.findOne('employees', where: {'id': employeeId});
    if (employee == null) {
      return errorResponse('Employee not found', statusCode: 404);
    }

    final passengers = db.findAll('trip_passengers', filters: {'employee_id': employeeId});
    Map<String, dynamic>? activeTrip;

    for (final p in passengers) {
      final trip = db.findOne('trips', where: {'id': p['trip_id']});
      if (trip != null && (trip['status'] == 'scheduled' || trip['status'] == 'in_progress')) {
        activeTrip = trip;
        break;
      }
    }

    if (activeTrip == null) {
      return jsonResponse({'otp': null, 'tripId': null, 'message': 'No active trip assigned'});
    }

    final tripId = activeTrip['id'];

    var otps = db.findAll('trip_otps', filters: {'trip_id': tripId});
    otps.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));

    String? otpCode;
    String? expiresAt;
    bool verified = false;

    if (otps.isNotEmpty) {
      final latest = otps.first;
      final exp = DateTime.parse(latest['expires_at'] as String);
      if (DateTime.now().isAfter(exp)) {
        final newOtp = _generateOtpCode();
        final newExpiry = DateTime.now().add(const Duration(minutes: 10)).toIso8601String();
        db.insert('trip_otps', {
          'id': 'otp_${DateTime.now().millisecondsSinceEpoch}',
          'trip_id': tripId,
          'otp': newOtp,
          'is_verified': false,
          'expires_at': newExpiry,
          'created_at': DateTime.now().toIso8601String(),
        });
        otpCode = newOtp;
        expiresAt = newExpiry;
      } else {
        otpCode = latest['otp'];
        expiresAt = latest['expires_at'];
        verified = latest['is_verified'] == true;
      }
    } else {
      final newOtp = _generateOtpCode();
      final newExpiry = DateTime.now().add(const Duration(minutes: 10)).toIso8601String();
      db.insert('trip_otps', {
        'id': 'otp_${DateTime.now().millisecondsSinceEpoch}',
        'trip_id': tripId,
        'otp': newOtp,
        'is_verified': false,
        'expires_at': newExpiry,
        'created_at': DateTime.now().toIso8601String(),
      });
      otpCode = newOtp;
      expiresAt = newExpiry;
    }

    final route = activeTrip['route_id'] != null ? db.findOne('routes', where: {'id': activeTrip['route_id']}) : null;
    final vehicle = activeTrip['vehicle_id'] != null ? db.findOne('vehicles', where: {'id': activeTrip['vehicle_id']}) : null;
    final driver = activeTrip['driver_id'] != null ? db.findOne('users', where: {'id': activeTrip['driver_id']}) : null;

    return jsonResponse({
      'otp': otpCode,
      'expiresAt': expiresAt,
      'verified': verified,
      'tripId': tripId,
      'trip': {
        ...activeTrip,
        'routeName': route?['name'] ?? '',
        'vehiclePlate': vehicle?['plate_number'] ?? '',
        'vehicleModel': vehicle?['model'] ?? '',
        'driverName': driver != null ? '${driver['first_name']} ${driver['last_name']}' : '',
        'scheduledTime': activeTrip['scheduled_time'],
      },
    });
  }

  Future<Response> regenerateOtp(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final tripId = body['tripId'] as String;
    final db = DatabaseConfig.db;

    final trip = db.findOne('trips', where: {'id': tripId});
    if (trip == null) {
      return errorResponse('Trip not found', statusCode: 404);
    }

    final otp = _generateOtpCode();
    final expiresAt = DateTime.now().add(const Duration(minutes: 10)).toIso8601String();

    db.insert('trip_otps', {
      'id': 'otp_${DateTime.now().millisecondsSinceEpoch}',
      'trip_id': tripId,
      'otp': otp,
      'is_verified': false,
      'expires_at': expiresAt,
      'created_at': DateTime.now().toIso8601String(),
    });

    return jsonResponse({
      'otp': otp,
      'expiresAt': expiresAt,
      'tripId': tripId,
    });
  }

  String _generateOtpCode() {
    return (100000 + Random().nextInt(900000)).toString();
  }
}
