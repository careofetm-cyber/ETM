import 'package:etm_core/etm_core.dart';
import '../api_client.dart';

class EmployeeApi {
  final ApiClient _client;
  
  EmployeeApi(this._client);
  
  Future<List<Employee>> getEmployees({int page = 1, int limit = 20, String? search}) async {
    final response = await _client.dio.get('/employees', queryParameters: {
      'page': page,
      'limit': limit,
      if (search != null) 'search': search,
    });
    return (response.data['data'] as List).map((e) => Employee.fromJson(e)).toList();
  }
  
  Future<Employee> getEmployee(String id) async {
    final response = await _client.dio.get('/employees/$id');
    return Employee.fromJson(response.data);
  }
  
  Future<void> createEmployee(Map<String, dynamic> data) async {
    await _client.dio.post('/employees', data: data);
  }
  
  Future<void> updateEmployee(String id, Map<String, dynamic> data) async {
    await _client.dio.put('/employees/$id', data: data);
  }
  
  Future<void> deleteEmployee(String id) async {
    await _client.dio.delete('/employees/$id');
  }
}

class DriverApi {
  final ApiClient _client;
  
  DriverApi(this._client);
  
  Future<List<Driver>> getDrivers({int page = 1, int limit = 20, String? search}) async {
    final response = await _client.dio.get('/drivers', queryParameters: {
      'page': page,
      'limit': limit,
      if (search != null) 'search': search,
    });
    return (response.data['data'] as List).map((d) => Driver.fromJson(d)).toList();
  }
  
  Future<Driver> getDriver(String id) async {
    final response = await _client.dio.get('/drivers/$id');
    return Driver.fromJson(response.data);
  }
  
  Future<void> createDriver(Map<String, dynamic> data) async {
    await _client.dio.post('/drivers', data: data);
  }
  
  Future<void> updateDriver(String id, Map<String, dynamic> data) async {
    await _client.dio.put('/drivers/$id', data: data);
  }
  
  Future<void> deleteDriver(String id) async {
    await _client.dio.delete('/drivers/$id');
  }
  
  Future<void> updateAvailability(String id, bool isAvailable) async {
    await _client.dio.put('/drivers/$id/availability', data: {
      'isAvailable': isAvailable,
    });
  }
}

class CompanyApi {
  final ApiClient _client;
  
  CompanyApi(this._client);
  
  Future<Company> getCompany(String id) async {
    final response = await _client.dio.get('/companies/me');
    return Company.fromJson(response.data);
  }
  
  Future<void> updateCompany(String id, Map<String, dynamic> data) async {
    await _client.dio.put('/companies/me', data: data);
  }
}
