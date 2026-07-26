import '../api_client.dart';

class PermissionApi {
  final ApiClient _client;
  
  PermissionApi(this._client);
  
  Future<Map<String, dynamic>> getRoles() async {
    final response = await _client.dio.get('/permissions/roles');
    return response.data as Map<String, dynamic>;
  }
  
  Future<Map<String, dynamic>> getRolePermissions(String role) async {
    final response = await _client.dio.get('/permissions/roles/$role');
    return response.data as Map<String, dynamic>;
  }
  
  Future<void> updateRolePermissions(String role, List<String> permissions) async {
    await _client.dio.put('/permissions/roles/$role', data: {'permissions': permissions});
  }
}
