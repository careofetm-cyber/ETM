import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:etm_networking/etm_networking.dart';

String get baseUrl {
  if (kIsWeb) return 'https://etm-gp12.onrender.com/api/v1';
  return 'https://etm-gp12.onrender.com/api/v1';
}

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      options.headers['Content-Type'] = 'application/json';
      options.headers['Accept'] = 'application/json';
      handler.next(options);
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        final prefs = await SharedPreferences.getInstance();
        final refreshToken = prefs.getString('refresh_token');
        if (refreshToken != null) {
          try {
            final refreshDio = Dio(BaseOptions(baseUrl: baseUrl));
            final response = await refreshDio.post('/auth/refresh', data: {'refreshToken': refreshToken});
            final data = response.data;
            await prefs.setString('auth_token', data['token']);
            await prefs.setString('refresh_token', data['refreshToken']);
            error.requestOptions.headers['Authorization'] = 'Bearer ${data['token']}';
            final retryResponse = await dio.fetch(error.requestOptions);
            return handler.resolve(retryResponse);
          } catch (_) {
            await prefs.clear();
          }
        }
      }
      handler.next(error);
    },
  ));

  return dio;
});

final apiClientProvider = FutureProvider<ApiClient>((ref) async {
  final dio = ref.watch(dioProvider);
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return ApiClient(dio, prefs, baseUrl: baseUrl);
});

final authApiProvider = FutureProvider<AuthApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return AuthApi(client);
});

final dashboardApiProvider = FutureProvider<DashboardApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return DashboardApi(client);
});

final tripApiProvider = FutureProvider<TripApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return TripApi(client);
});

final otpApiProvider = FutureProvider<OtpApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return OtpApi(client);
});

enum AppThemeMode { light, dark, system }

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, AppThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  ThemeModeNotifier() : super(AppThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('theme_mode') ?? 'system';
    state = AppThemeMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AppThemeMode.system,
    );
  }

  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.name);
  }
}
