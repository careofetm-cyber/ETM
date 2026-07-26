import '../api_client.dart';

class OtpApi {
  final ApiClient _client;
  
  OtpApi(this._client);
  
  Future<Map<String, dynamic>> generateOtp(String tripId) async {
    final response = await _client.dio.post('/otp/generate', data: {'tripId': tripId});
    return response.data as Map<String, dynamic>;
  }
  
  Future<Map<String, dynamic>> verifyOtp(String tripId, String otp) async {
    final response = await _client.dio.post('/otp/verify', data: {'tripId': tripId, 'otp': otp});
    return response.data as Map<String, dynamic>;
  }
  
  Future<Map<String, dynamic>> getTripOtp(String tripId) async {
    final response = await _client.dio.get('/otp/trip/$tripId');
    return response.data as Map<String, dynamic>;
  }
}
