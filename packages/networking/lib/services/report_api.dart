import '../api_client.dart';

class ExportReportApi {
  final ApiClient _client;
  
  ExportReportApi(this._client);
  
  Future<List<Map<String, dynamic>>> exportEmployees() async {
    final response = await _client.dio.get('/reports/employees');
    final data = response.data;
    final list = data is Map ? data['data'] ?? [] : data;
    return (list as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }
  
  Future<List<Map<String, dynamic>>> exportTrips() async {
    final response = await _client.dio.get('/reports/trips');
    final data = response.data;
    final list = data is Map ? data['data'] ?? [] : data;
    return (list as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }
  
  Future<List<Map<String, dynamic>>> exportBilling() async {
    final response = await _client.dio.get('/reports/billing');
    final data = response.data;
    final list = data is Map ? data['data'] ?? [] : data;
    return (list as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }
  
  Future<List<Map<String, dynamic>>> exportAttendance() async {
    final response = await _client.dio.get('/reports/attendance');
    final data = response.data;
    final list = data is Map ? data['data'] ?? [] : data;
    return (list as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }
  
  Future<List<Map<String, dynamic>>> exportVehicles() async {
    final response = await _client.dio.get('/reports/vehicles');
    final data = response.data;
    final list = data is Map ? data['data'] ?? [] : data;
    return (list as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
