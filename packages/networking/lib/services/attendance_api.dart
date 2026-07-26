import 'package:etm_core/etm_core.dart';
import '../api_client.dart';

class AttendanceApi {
  final ApiClient _client;
  
  AttendanceApi(this._client);
  
  Future<List<Attendance>> getAttendance({
    int page = 1,
    int limit = 20,
    String? employeeId,
    DateTime? date,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    final response = await _client.dio.get('/attendance', queryParameters: {
      'page': page,
      'limit': limit,
      if (employeeId != null) 'employeeId': employeeId,
      if (date != null) 'date': date.toIso8601String(),
      if (startDate != null) 'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate.toIso8601String(),
      if (status != null) 'status': status,
    });
    return (response.data['data'] as List).map((a) => Attendance.fromJson(a)).toList();
  }
  
  Future<Attendance> checkIn(String employeeId, {BoardingMethod? method, String? tripId}) async {
    final response = await _client.dio.post('/attendance/check-in', data: {
      'employeeId': employeeId,
      'method': method?.name,
      if (tripId != null) 'tripId': tripId,
    });
    return Attendance.fromJson(response.data);
  }
  
  Future<Attendance> checkOut(String employeeId) async {
    final response = await _client.dio.post('/attendance/check-out', data: {
      'employeeId': employeeId,
    });
    return Attendance.fromJson(response.data);
  }
  
  Future<List<TransportRequest>> getTransportRequests({
    int page = 1,
    int limit = 20,
    String? status,
    String? employeeId,
  }) async {
    final response = await _client.dio.get('/transport-requests', queryParameters: {
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
      if (employeeId != null) 'employeeId': employeeId,
    });
    return (response.data['data'] as List).map((r) => TransportRequest.fromJson(r)).toList();
  }
  
  Future<TransportRequest> createTransportRequest(Map<String, dynamic> data) async {
    final response = await _client.dio.post('/transport-requests', data: data);
    return TransportRequest.fromJson(response.data);
  }
  
  Future<TransportRequest> approveTransportRequest(String id, String approvedBy) async {
    final response = await _client.dio.post('/transport-requests/$id/approve', data: {
      'approvedBy': approvedBy,
    });
    return TransportRequest.fromJson(response.data);
  }
  
  Future<TransportRequest> rejectTransportRequest(String id, String reason) async {
    final response = await _client.dio.post('/transport-requests/$id/reject', data: {
      'reason': reason,
    });
    return TransportRequest.fromJson(response.data);
  }
}
