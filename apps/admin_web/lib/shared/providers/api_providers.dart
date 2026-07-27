import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:etm_networking/etm_networking.dart';

String get _baseUrl {
  if (kIsWeb) {
    // Production backend URL - update this after deploying backend
    // For now use localhost; change to your Render URL after deployment
    return 'http://localhost:8080/api/v1';
  }
  return 'http://localhost:8080/api/v1';
}

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
});

final apiClientProvider = FutureProvider<ApiClient>((ref) async {
  final dio = ref.watch(dioProvider);
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return ApiClient(dio, prefs);
});

final authApiProvider = FutureProvider<AuthApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return AuthApi(client);
});

final dashboardApiProvider = FutureProvider<DashboardApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return DashboardApi(client);
});

final vehicleApiProvider = FutureProvider<VehicleApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return VehicleApi(client);
});

final employeeApiProvider = FutureProvider<EmployeeApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return EmployeeApi(client);
});

final driverApiProvider = FutureProvider<DriverApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return DriverApi(client);
});

final tripApiProvider = FutureProvider<TripApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return TripApi(client);
});

final routeApiProvider = FutureProvider<RouteApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return RouteApi(client);
});

final attendanceApiProvider = FutureProvider<AttendanceApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return AttendanceApi(client);
});

final dashboardApiServiceProvider = FutureProvider<DashboardApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return DashboardApi(client);
});

final notificationApiProvider = FutureProvider<NotificationApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return NotificationApi(client);
});

final incidentApiProvider = FutureProvider<IncidentApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return IncidentApi(client);
});

final superAdminApiProvider = FutureProvider<SuperAdminApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return SuperAdminApi(client);
});

final companyApiProvider = FutureProvider<CompanyApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return CompanyApi(client);
});

final userManagementApiProvider = FutureProvider<UserManagementApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return UserManagementApi(client);
});

final settingsApiProvider = FutureProvider<SettingsApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return SettingsApi(client);
});

final exportReportApiProvider = FutureProvider<ExportReportApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return ExportReportApi(client);
});

final otpApiProvider = FutureProvider<OtpApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return OtpApi(client);
});

final permissionApiProvider = FutureProvider<PermissionApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return PermissionApi(client);
});

final rosterApiProvider = FutureProvider<RosterApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return RosterApi(client.dio);
});

final vehicleDocumentApiProvider = FutureProvider<VehicleDocumentApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return VehicleDocumentApi(client.dio);
});

final ncnsApiProvider = FutureProvider<NcnsApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return NcnsApi(client.dio);
});

final hcmApiProvider = FutureProvider<HcmApi>((ref) async {
  final client = await ref.watch(apiClientProvider.future);
  return HcmApi(client.dio);
});
