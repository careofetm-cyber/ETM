import 'package:etm_core/etm_core.dart';
import '../api_client.dart';

class AuthApi {
  final ApiClient _client;
  
  AuthApi(this._client);
  
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _client.dio.post('/auth/login', data: request.toJson());
    return AuthResponse.fromJson(response.data);
  }
  
  Future<void> logout() async {
    await _client.dio.post('/auth/logout');
    _client.clearToken();
  }
  
  Future<User> getProfile() async {
    final response = await _client.dio.get('/auth/profile');
    return User.fromJson(response.data);
  }
  
  Future<User> updateProfile(Map<String, dynamic> data) async {
    final response = await _client.dio.put('/auth/profile', data: data);
    return User.fromJson(response.data);
  }
  
  Future<void> changePassword(String currentPassword, String newPassword) async {
    await _client.dio.put('/auth/change-password', data: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }
  
  Future<void> forgotPassword(String email) async {
    await _client.dio.post('/auth/forgot-password', data: {'email': email});
  }
  
  Future<void> resetPassword(String token, String newPassword) async {
    await _client.dio.post('/auth/reset-password', data: {
      'token': token,
      'newPassword': newPassword,
    });
  }
}
