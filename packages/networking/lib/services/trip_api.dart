import 'package:etm_core/etm_core.dart';
import '../api_client.dart';

class TripApi {
  final ApiClient _client;
  
  TripApi(this._client);
  
  Future<List<Trip>> getTrips({
    int page = 1,
    int limit = 20,
    String? status,
    DateTime? date,
    String? routeId,
    String? vehicleId,
    String? driverId,
  }) async {
    final response = await _client.dio.get('/trips', queryParameters: {
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
      if (date != null) 'date': date.toIso8601String(),
      if (routeId != null) 'routeId': routeId,
      if (vehicleId != null) 'vehicleId': vehicleId,
      if (driverId != null) 'driverId': driverId,
    });
    return (response.data['data'] as List).map((t) => Trip.fromJson(t)).toList();
  }
  
  Future<Trip> getTrip(String id) async {
    final response = await _client.dio.get('/trips/$id');
    return Trip.fromJson(response.data);
  }
  
  Future<void> createTrip(Map<String, dynamic> data) async {
    await _client.dio.post('/trips', data: data);
  }
  
  Future<void> updateTrip(String id, Map<String, dynamic> data) async {
    await _client.dio.put('/trips/$id', data: data);
  }
  
  Future<void> cancelTrip(String id, String reason) async {
    await _client.dio.post('/trips/$id/cancel', data: {'reason': reason});
  }
  
  Future<void> startTrip(String id) async {
    await _client.dio.post('/trips/$id/start');
  }
  
  Future<void> completeTrip(String id) async {
    await _client.dio.post('/trips/$id/complete', data: {});
  }
  
  Future<void> assignCab(String tripId, String vehicleId, String driverId) async {
    await _client.dio.put('/trips/$tripId/assign-cab', data: {
      'vehicleId': vehicleId,
      'driverId': driverId,
    });
  }
  
  Future<List<TripPassenger>> getTripPassengers(String tripId) async {
    final response = await _client.dio.get('/trips/$tripId/passengers');
    return (response.data['data'] as List).map((p) => TripPassenger.fromJson(p)).toList();
  }
  
  Future<void> addPassenger(String tripId, String employeeId, String? stopId) async {
    await _client.dio.put('/trips/$tripId/passengers', data: {
      'action': 'add',
      'employeeId': employeeId,
      'stopId': stopId,
    });
  }
  
  Future<void> removePassenger(String tripId, String employeeId) async {
    await _client.dio.put('/trips/$tripId/passengers', data: {
      'action': 'remove',
      'employeeId': employeeId,
    });
  }
  
  Future<void> boardPassenger(String tripId, String employeeId) async {
    await _client.dio.post('/trips/$tripId/passengers/$employeeId/board');
  }
  
  Future<void> dropPassenger(String tripId, String employeeId) async {
    await _client.dio.post('/trips/$tripId/passengers/$employeeId/drop');
  }
  
  Future<List<GPSLog>> getGPSLogs(String vehicleId, {DateTime? start, DateTime? end}) async {
    final response = await _client.dio.get('/trips/gps/$vehicleId', queryParameters: {
      if (start != null) 'start': start.toIso8601String(),
      if (end != null) 'end': end.toIso8601String(),
    });
    return (response.data['data'] as List).map((g) => GPSLog.fromJson(g)).toList();
  }
  
  Future<void> sendLocationUpdate(LocationUpdate update) async {
    await _client.dio.post('/trips/location', data: update.toJson());
  }
}
