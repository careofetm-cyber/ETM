import 'package:dio/dio.dart';

class VehicleDocumentApi {
  final Dio _dio;

  VehicleDocumentApi(this._dio);

  Future<List<dynamic>> getDocuments({String? type, int page = 1}) async {
    final params = <String, dynamic>{'page': page};
    if (type != null) params['type'] = type;
    final response = await _dio.get('/vehicle-documents', queryParameters: params);
    return response.data['data'] ?? [];
  }

  Future<List<dynamic>> getVehicleDocuments(String vehicleId) async {
    final response = await _dio.get('/vehicle-documents/vehicle/$vehicleId');
    return response.data['data'] ?? [];
  }

  Future<List<dynamic>> getExpiringDocuments({int days = 30}) async {
    final response = await _dio.get('/vehicle-documents/expiring', queryParameters: {'days': days});
    return response.data['data'] ?? [];
  }

  Future<Map<String, dynamic>> getDocumentAlerts() async {
    final response = await _dio.get('/vehicle-documents/alerts');
    return response.data;
  }

  Future<void> createDocument(Map<String, dynamic> data) async {
    await _dio.post('/vehicle-documents', data: data);
  }

  Future<void> updateDocument(String id, Map<String, dynamic> data) async {
    await _dio.put('/vehicle-documents/$id', data: data);
  }

  Future<void> deleteDocument(String id) async {
    await _dio.delete('/vehicle-documents/$id');
  }
}
