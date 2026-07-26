import 'package:dio/dio.dart';
import '../etm_networking.dart';

class RosterApi {
  final Dio _dio;

  RosterApi(this._dio);

  Future<List<dynamic>> getRosters({String? startDate, String? endDate, String? date, int page = 1, int limit = 50}) async {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (date != null) params['date'] = date;
    if (startDate != null) params['startDate'] = startDate;
    if (endDate != null) params['endDate'] = endDate;
    final response = await _dio.get('/rosters', queryParameters: params);
    return response.data['data'] ?? [];
  }

  Future<List<dynamic>> getEmployeeRosters(String employeeId, {String? startDate, String? endDate}) async {
    final params = <String, dynamic>{};
    if (startDate != null) params['startDate'] = startDate;
    if (endDate != null) params['endDate'] = endDate;
    final response = await _dio.get('/rosters/employee/$employeeId', queryParameters: params);
    return response.data['data'] ?? [];
  }

  Future<void> createRoster(Map<String, dynamic> data) async {
    await _dio.post('/rosters', data: data);
  }

  Future<void> updateRoster(String id, Map<String, dynamic> data) async {
    await _dio.put('/rosters/$id', data: data);
  }

  Future<void> deleteRoster(String id) async {
    await _dio.delete('/rosters/$id');
  }

  Future<void> bulkCreateRosters(List<Map<String, dynamic>> rosters) async {
    await _dio.post('/rosters/bulk', data: {'rosters': rosters});
  }

  Future<List<dynamic>> getRosterRequests({String? status, int page = 1}) async {
    final params = <String, dynamic>{'page': page};
    if (status != null) params['status'] = status;
    final response = await _dio.get('/rosters/requests', queryParameters: params);
    return response.data['data'] ?? [];
  }

  Future<void> createRosterRequest(Map<String, dynamic> data) async {
    await _dio.post('/rosters/requests', data: data);
  }

  Future<void> approveRosterRequest(String id) async {
    await _dio.post('/rosters/requests/$id/approve');
  }

  Future<void> rejectRosterRequest(String id, {String? reason}) async {
    await _dio.post('/rosters/requests/$id/reject', data: {'reason': reason});
  }
}
