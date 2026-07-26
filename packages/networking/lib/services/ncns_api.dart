import 'package:dio/dio.dart';

class NcnsApi {
  final Dio _dio;

  NcnsApi(this._dio);

  Future<List<dynamic>> getNcnsLog({int page = 1}) async {
    final response = await _dio.get('/ncns', queryParameters: {'page': page});
    return response.data['data'] ?? [];
  }

  Future<List<dynamic>> getEmployeeNcns(String employeeId) async {
    final response = await _dio.get('/ncns/employee/$employeeId');
    return response.data['data'] ?? [];
  }

  Future<void> markNcns(Map<String, dynamic> data) async {
    await _dio.post('/ncns/mark', data: data);
  }

  Future<Map<String, dynamic>> getNcnsSettings() async {
    final response = await _dio.get('/ncns/settings');
    return response.data;
  }

  Future<void> updateNcnsSettings(Map<String, dynamic> data) async {
    await _dio.put('/ncns/settings', data: data);
  }
}
