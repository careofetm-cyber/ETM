import 'package:etm_core/etm_core.dart';
import '../api_client.dart';

class DashboardApi {
  final ApiClient _client;
  
  DashboardApi(this._client);
  
  Future<DashboardStats> getAdminDashboard() async {
    final response = await _client.dio.get('/dashboard/admin');
    return DashboardStats.fromJson(response.data);
  }
  
  Future<DriverDashboard> getDriverDashboard() async {
    final response = await _client.dio.get('/dashboard/driver');
    return DriverDashboard.fromJson(response.data);
  }
  
  Future<EmployeeDashboard> getEmployeeDashboard() async {
    final response = await _client.dio.get('/dashboard/employee');
    return EmployeeDashboard.fromJson(response.data);
  }
}

class ReportApi {
  final ApiClient _client;
  
  ReportApi(this._client);
  
  Future<ReportData> getAttendanceReport(DateTime startDate, DateTime endDate) async {
    final response = await _client.dio.get('/reports/attendance', queryParameters: {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    });
    return ReportData.fromJson(response.data);
  }
  
  Future<ReportData> getTripReport(DateTime startDate, DateTime endDate) async {
    final response = await _client.dio.get('/reports/trips', queryParameters: {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    });
    return ReportData.fromJson(response.data);
  }
  
  Future<ReportData> getFuelReport(DateTime startDate, DateTime endDate) async {
    final response = await _client.dio.get('/reports/fuel', queryParameters: {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    });
    return ReportData.fromJson(response.data);
  }
  
  Future<ReportData> getMaintenanceReport(DateTime startDate, DateTime endDate) async {
    final response = await _client.dio.get('/reports/maintenance', queryParameters: {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    });
    return ReportData.fromJson(response.data);
  }
}

class NotificationApi {
  final ApiClient _client;
  
  NotificationApi(this._client);
  
  Future<List<AppNotification>> getNotifications({int page = 1, int limit = 20, bool? unreadOnly}) async {
    final response = await _client.dio.get('/notifications', queryParameters: {
      'page': page,
      'limit': limit,
      if (unreadOnly != null) 'unreadOnly': unreadOnly,
    });
    return (response.data['data'] as List).map((n) => AppNotification.fromJson(n)).toList();
  }
  
  Future<void> markAsRead(String id) async {
    await _client.dio.put('/notifications/$id/read');
  }
  
  Future<void> markAllAsRead() async {
    await _client.dio.put('/notifications/read-all');
  }
  
  Future<int> getUnreadCount() async {
    final response = await _client.dio.get('/notifications/unread-count');
    return response.data['count'];
  }
}

class IncidentApi {
  final ApiClient _client;
  
  IncidentApi(this._client);
  
  Future<List<Incident>> getIncidents({int page = 1, int limit = 20, String? status}) async {
    final response = await _client.dio.get('/incidents', queryParameters: {
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
    });
    return (response.data['data'] as List).map((i) => Incident.fromJson(i)).toList();
  }
  
  Future<Incident> reportIncident(Map<String, dynamic> data) async {
    final response = await _client.dio.post('/incidents', data: data);
    return Incident.fromJson(response.data);
  }
  
  Future<Incident> updateIncident(String id, Map<String, dynamic> data) async {
    final response = await _client.dio.put('/incidents/$id', data: data);
    return Incident.fromJson(response.data);
  }
  
  Future<SOSAlert> sendSOS(double latitude, double longitude, String? message) async {
    final response = await _client.dio.post('/sos', data: {
      'latitude': latitude,
      'longitude': longitude,
      if (message != null) 'message': message,
    });
    return SOSAlert.fromJson(response.data);
  }
  
  Future<void> resolveSOS(String id) async {
    await _client.dio.post('/sos/$id/resolve');
  }
}
