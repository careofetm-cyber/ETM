import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/error_middleware.dart';

class ShiftRoutes {
  final router = Router();

  ShiftRoutes() {
    router.get('/', _getShifts);
    router.post('/', _createShift);
    router.put('/<id>', _updateShift);
    router.delete('/<id>', _deleteShift);
  }

  Future<Response> _getShifts(Request request) async {
    final companyId = request.headers['company_id'];
    final db = DatabaseConfig.db;
    final shifts = db.findAll('shifts', filters: companyId != null ? {'company_id': companyId} : null);
    return jsonResponse({'data': shifts, 'total': shifts.length});
  }

  Future<Response> _createShift(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final db = DatabaseConfig.db;
    final id = 'shift_${DateTime.now().millisecondsSinceEpoch}';
    final shift = {
      'id': id,
      'name': body['name'] ?? '',
      'code': body['code'] ?? '',
      'start_time': body['startTime'] ?? body['start_time'] ?? '09:00',
      'end_time': body['endTime'] ?? body['end_time'] ?? '17:00',
      'company_id': body['companyId'] ?? body['company_id'] ?? '',
      'is_active': true,
      'created_at': DateTime.now().toIso8601String(),
    };
    db.insert('shifts', shift);
    return jsonResponse({'id': id, 'message': 'Shift created successfully'}, statusCode: 201);
  }

  Future<Response> _updateShift(Request request, String id) async {
    final body = jsonDecode(await request.readAsString());
    final db = DatabaseConfig.db;
    final updates = <String, dynamic>{};
    if (body['name'] != null) updates['name'] = body['name'];
    if (body['code'] != null) updates['code'] = body['code'];
    if (body['startTime'] != null) updates['start_time'] = body['startTime'];
    if (body['endTime'] != null) updates['end_time'] = body['endTime'];
    if (body['isActive'] != null) updates['is_active'] = body['isActive'];
    updates['updated_at'] = DateTime.now().toIso8601String();
    db.update('shifts', updates, where: {'id': id});
    return jsonResponse({'message': 'Shift updated successfully'});
  }

  Future<Response> _deleteShift(Request request, String id) async {
    final db = DatabaseConfig.db;
    db.update('shifts', {'is_active': false}, where: {'id': id});
    return jsonResponse({'message': 'Shift deleted successfully'});
  }
}
