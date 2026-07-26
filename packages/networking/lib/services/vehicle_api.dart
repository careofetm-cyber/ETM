import 'package:etm_core/etm_core.dart';
import '../api_client.dart';

class VehicleApi {
  final ApiClient _client;
  
  VehicleApi(this._client);
  
  Future<List<Vehicle>> getVehicles({int page = 1, int limit = 20, String? status}) async {
    final response = await _client.dio.get('/vehicles', queryParameters: {
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
    });
    return (response.data['data'] as List).map((v) => Vehicle.fromJson(v)).toList();
  }
  
  Future<Vehicle> getVehicle(String id) async {
    final response = await _client.dio.get('/vehicles/$id');
    return Vehicle.fromJson(response.data);
  }
  
  Future<Vehicle> createVehicle(Map<String, dynamic> data) async {
    final response = await _client.dio.post('/vehicles', data: data);
    return Vehicle.fromJson(response.data);
  }
  
  Future<Vehicle> updateVehicle(String id, Map<String, dynamic> data) async {
    final response = await _client.dio.put('/vehicles/$id', data: data);
    return Vehicle.fromJson(response.data);
  }
  
  Future<void> deleteVehicle(String id) async {
    await _client.dio.delete('/vehicles/$id');
  }
  
  Future<Vehicle> updateVehicleLocation(String id, double lat, double lng) async {
    final response = await _client.dio.put('/vehicles/$id/location', data: {
      'latitude': lat,
      'longitude': lng,
    });
    return Vehicle.fromJson(response.data);
  }
  
  Future<List<VehicleInspection>> getInspections(String vehicleId) async {
    final response = await _client.dio.get('/vehicles/$vehicleId/inspections');
    return (response.data['data'] as List).map((i) => VehicleInspection.fromJson(i)).toList();
  }
  
  Future<VehicleInspection> createInspection(String vehicleId, Map<String, dynamic> data) async {
    final response = await _client.dio.post('/vehicles/$vehicleId/inspections', data: data);
    return VehicleInspection.fromJson(response.data);
  }
}
