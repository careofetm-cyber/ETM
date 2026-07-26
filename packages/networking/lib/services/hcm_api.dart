import 'package:dio/dio.dart';

class HcmApi {
  final Dio _dio;

  HcmApi(this._dio);

  Future<List<dynamic>> getHcmConfigs() async {
    final response = await _dio.get('/hcm/configs');
    return response.data['data'] ?? [];
  }

  Future<void> createHcmConfig(Map<String, dynamic> data) async {
    await _dio.post('/hcm/configs', data: data);
  }

  Future<void> updateHcmConfig(String id, Map<String, dynamic> data) async {
    await _dio.put('/hcm/configs/$id', data: data);
  }

  Future<void> deleteHcmConfig(String id) async {
    await _dio.delete('/hcm/configs/$id');
  }

  Future<void> syncEmployees(String configId) async {
    await _dio.post('/hcm/sync/employees', data: {'configId': configId});
  }

  Future<void> syncAttendance(String configId) async {
    await _dio.post('/hcm/sync/attendance', data: {'configId': configId});
  }

  Future<Map<String, dynamic>> getSyncStatus() async {
    final response = await _dio.get('/hcm/sync/status');
    return response.data;
  }
}
