import '../api_client.dart';

class UserManagementApi {
  final ApiClient _client;
  
  UserManagementApi(this._client);
  
  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await _client.dio.get('/users');
    final data = response.data;
    final list = data is Map ? data['data'] ?? [] : data;
    return (list as List).map((u) => Map<String, dynamic>.from(u)).toList();
  }
  
  Future<void> createUser(Map<String, dynamic> data) async {
    await _client.dio.post('/users', data: data);
  }
  
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _client.dio.put('/users/$id', data: data);
  }
  
  Future<void> deleteUser(String id) async {
    await _client.dio.delete('/users/$id');
  }
}
