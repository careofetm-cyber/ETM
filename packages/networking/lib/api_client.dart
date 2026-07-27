import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio _dio;
  final SharedPreferences _prefs;
  
  ApiClient(this._dio, this._prefs, {String? baseUrl}) {
    if (baseUrl != null) {
      _dio.options.baseUrl = baseUrl;
    }
    _dio.options.connectTimeout = const Duration(seconds: 90);
    _dio.options.receiveTimeout = const Duration(seconds: 90);
    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              final token = _prefs.getString('auth_token');
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = _prefs.getString('refresh_token');
      if (refreshToken == null) return false;
      
      final response = await _dio.post('/auth/refresh', data: {
        'refreshToken': refreshToken,
      });
      
      if (response.statusCode == 200) {
        final data = response.data;
        await _prefs.setString('auth_token', data['token']);
        await _prefs.setString('refresh_token', data['refreshToken']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void setBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }

  void setToken(String token) {
    _prefs.setString('auth_token', token);
  }

  void clearToken() {
    _prefs.remove('auth_token');
    _prefs.remove('refresh_token');
  }

  Dio get dio => _dio;
}
