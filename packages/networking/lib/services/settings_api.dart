import '../api_client.dart';

class SettingsApi {
  final ApiClient _client;
  
  SettingsApi(this._client);
  
  Future<Map<String, dynamic>> getSettings() async {
    final response = await _client.dio.get('/settings');
    return response.data as Map<String, dynamic>;
  }
  
  Future<Map<String, dynamic>> updateSettings(Map<String, dynamic> data) async {
    final response = await _client.dio.put('/settings', data: data);
    return response.data as Map<String, dynamic>;
  }
  
  Future<Map<String, dynamic>> getCompanySettings(String companyId) async {
    final response = await _client.dio.get('/settings/company/$companyId');
    return response.data as Map<String, dynamic>;
  }
  
  Future<Map<String, dynamic>> updateCompanySettings(String companyId, Map<String, dynamic> data) async {
    final response = await _client.dio.put('/settings/company/$companyId', data: data);
    return response.data as Map<String, dynamic>;
  }
}
