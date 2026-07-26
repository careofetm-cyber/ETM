import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class VehicleDocumentRoutes {
  final router = Router();

  VehicleDocumentRoutes() {
    router.get('/', authMiddleware()(getDocuments));
    router.get('/vehicle/<vehicleId>', authMiddleware()(getVehicleDocuments));
    router.get('/expiring', authMiddleware(requiredRoles: ['admin', 'manager'])(getExpiringDocuments));
    router.get('/alerts', authMiddleware(requiredRoles: ['admin', 'manager'])(getDocumentAlerts));
    router.post('/', authMiddleware(requiredRoles: ['admin', 'manager'])(createDocument));
    router.put('/<id>', authMiddleware(requiredRoles: ['admin', 'manager'])(updateDocument));
    router.delete('/<id>', authMiddleware(requiredRoles: ['admin'])(deleteDocument));
  }

  Future<Response> getDocuments(Request request) async {
    final page = int.tryParse(request.url.queryParameters['page'] ?? '1') ?? 1;
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '20') ?? 20;
    final type = request.url.queryParameters['type'];
    final companyId = request.context['companyId'] as String?;

    final db = DatabaseConfig.db;
    final filters = <String, dynamic>{'company_id': companyId};
    if (type != null) filters['document_type'] = type;

    var docs = db.findAll('vehicle_documents', filters: filters);
    final total = docs.length;
    docs.sort((a, b) => (b['expiry_date'] ?? '').toString().compareTo((a['expiry_date'] ?? '').toString()));
    final paginated = docs.skip((page - 1) * limit).take(limit).toList();

    return paginatedResponse(paginated, total, page, limit);
  }

  Future<Response> getVehicleDocuments(Request request) async {
    final vehicleId = request.params['vehicleId'];
    final db = DatabaseConfig.db;
    final docs = db.findAll('vehicle_documents', filters: {'vehicle_id': vehicleId});
    docs.sort((a, b) => (a['document_type'] ?? '').toString().compareTo((b['document_type'] ?? '').toString()));
    return jsonResponse({'data': docs});
  }

  Future<Response> getExpiringDocuments(Request request) async {
    final days = int.tryParse(request.url.queryParameters['days'] ?? '30') ?? 30;
    final companyId = request.context['companyId'] as String?;

    final db = DatabaseConfig.db;
    final now = DateTime.now();
    final threshold = now.add(Duration(days: days)).toIso8601String().substring(0, 10);

    var docs = db.findAll('vehicle_documents', filters: {'company_id': companyId});
    docs = docs.where((d) {
      final expiry = d['expiry_date']?.toString() ?? '';
      return expiry.isNotEmpty && expiry.compareTo(now.toIso8601String().substring(0, 10)) >= 0 && expiry.compareTo(threshold) <= 0;
    }).toList();

    docs.sort((a, b) => (a['expiry_date'] ?? '').toString().compareTo((b['expiry_date'] ?? '').toString()));
    return jsonResponse({'data': docs, 'total': docs.length});
  }

  Future<Response> getDocumentAlerts(Request request) async {
    final companyId = request.context['companyId'] as String?;
    final db = DatabaseConfig.db;
    final now = DateTime.now();
    final today = now.toIso8601String().substring(0, 10);
    final thirtyDays = now.add(Duration(days: 30)).toIso8601String().substring(0, 10);

    var allDocs = db.findAll('vehicle_documents', filters: {'company_id': companyId});

    int expired = 0;
    int expiringSoon = 0;
    int valid = 0;

    for (var doc in allDocs) {
      final expiry = doc['expiry_date']?.toString() ?? '';
      if (expiry.isEmpty) continue;
      if (expiry.compareTo(today) < 0) {
        expired++;
      } else if (expiry.compareTo(thirtyDays) <= 0) {
        expiringSoon++;
      } else {
        valid++;
      }
    }

    return jsonResponse({
      'total': allDocs.length,
      'expired': expired,
      'expiringSoon': expiringSoon,
      'valid': valid,
    });
  }

  Future<Response> createDocument(Request request) async {
    final body = jsonDecode(await request.readAsString());
    final companyId = request.context['companyId'] as String;

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now().toIso8601String();
    final db = DatabaseConfig.db;

    final expiryDate = body['expiryDate'] as String? ?? '';
    final today = now.substring(0, 10);
    final thirtyDays = DateTime.now().add(Duration(days: 30)).toIso8601String().substring(0, 10);
    String status = 'valid';
    if (expiryDate.isNotEmpty) {
      if (expiryDate.compareTo(today) < 0) {
        status = 'expired';
      } else if (expiryDate.compareTo(thirtyDays) <= 0) {
        status = 'expiring_soon';
      }
    }

    db.insert('vehicle_documents', {
      'id': id,
      'vehicle_id': body['vehicleId'],
      'company_id': companyId,
      'document_type': body['documentType'],
      'document_number': body['documentNumber'],
      'issue_date': body['issueDate'],
      'expiry_date': body['expiryDate'],
      'document_url': body['documentUrl'] ?? '',
      'status': status,
      'created_at': now,
    });

    return jsonResponse({'id': id, 'message': 'Document created successfully'}, statusCode: 201);
  }

  Future<Response> updateDocument(Request request) async {
    final id = request.params['id'];
    final body = jsonDecode(await request.readAsString());

    final db = DatabaseConfig.db;
    final updates = <String, dynamic>{};
    if (body['documentType'] != null) updates['document_type'] = body['documentType'];
    if (body['documentNumber'] != null) updates['document_number'] = body['documentNumber'];
    if (body['issueDate'] != null) updates['issue_date'] = body['issueDate'];
    if (body['expiryDate'] != null) {
      updates['expiry_date'] = body['expiryDate'];
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final thirtyDays = DateTime.now().add(Duration(days: 30)).toIso8601String().substring(0, 10);
      if (body['expiryDate'].compareTo(today) < 0) {
        updates['status'] = 'expired';
      } else if (body['expiryDate'].compareTo(thirtyDays) <= 0) {
        updates['status'] = 'expiring_soon';
      } else {
        updates['status'] = 'valid';
      }
    }
    if (body['documentUrl'] != null) updates['document_url'] = body['documentUrl'];
    if (updates.isNotEmpty) {
      updates['updated_at'] = DateTime.now().toIso8601String();
      db.update('vehicle_documents', updates, where: {'id': id});
    }

    return jsonResponse({'message': 'Document updated successfully'});
  }

  Future<Response> deleteDocument(Request request) async {
    final id = request.params['id'];
    final db = DatabaseConfig.db;
    db.delete('vehicle_documents', where: {'id': id});
    return jsonResponse({'message': 'Document deleted successfully'});
  }
}
