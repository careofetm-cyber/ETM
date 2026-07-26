import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

class AuthState {
  final bool isAuthenticated;
  final User? user;
  final String? token;
  final String? error;
  final bool isLoading;

  AuthState({
    this.isAuthenticated = false,
    this.user,
    this.token,
    this.error,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    User? user,
    String? token,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      token: token ?? this.token,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  
  AuthNotifier(this.ref) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authApi = await ref.read(authApiProvider.future);
      final response = await authApi.login(LoginRequest(
        email: email,
        password: password,
      ));
      
      final client = await ref.read(apiClientProvider.future);
      client.setToken(response.token);
      
      state = state.copyWith(
        isAuthenticated: true,
        user: response.user,
        token: response.token,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString().contains('Exception') 
            ? e.toString().replaceFirst('Exception: ', '')
            : 'Login failed. Please check your credentials.',
        isLoading: false,
      );
    }
  }

  Future<void> logout() async {
    try {
      final authApi = await ref.read(authApiProvider.future);
      await authApi.logout();
    } catch (_) {}
    
    final client = await ref.read(apiClientProvider.future);
    client.clearToken();
    state = AuthState();
  }

  Future<void> checkAuth() async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final token = prefs.getString('auth_token');
      if (token != null) {
        final authApi = await ref.read(authApiProvider.future);
        final user = await authApi.getProfile();
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          token: token,
        );
      }
    } catch (_) {
      state = AuthState();
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
