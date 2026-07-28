import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class StopRoutes {
  final router = Router();

  StopRoutes() {
    router.get('/', authMiddleware()(getStops));
    router.post('/', authMiddleware(requiredRoles: ['admin', 'manager'])(createStop));
    router.put('/<id>', authMiddleware(requiredRoles: ['admin', 'manager'])(updateStop));
    router.delete('/<id>', authMiddleware(requiredRoles: ['admin'])(deleteStop));
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
